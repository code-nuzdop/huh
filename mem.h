// mem.h v40 - iqvw64e BYOVD transport (0x33 read / 0x19 map / 0x1A unmap)
#pragma once
#include <windows.h>
#include <psapi.h>
#include <stdio.h>
#include <stdint.h>
#include <stdarg.h>
#include <string.h>
#include <vector>
#include <string>

#pragma comment(lib, "psapi.lib")
#pragma comment(lib, "advapi32.lib")

#include <winternl.h>
#include <tlhelp32.h>
#include <thread>
#include <mutex>
#include <atomic>
#include <unordered_map>
#include <cmath>
#include <algorithm>

typedef uint64_t u64; typedef uint32_t u32; typedef uint16_t u16; typedef uint8_t u8;

struct Transport;
extern Transport* g_mem;
extern DWORD  g_pid;

// ---------------------------------------------------------------- logging --
inline void Log(const wchar_t* fmt, ...) {
    wchar_t s[2048]; va_list ap; va_start(ap, fmt);
    vswprintf_s(s, 2048, fmt, ap); va_end(ap);
    fwprintf(stdout, L"%ls\n", s); fflush(stdout);
    OutputDebugStringW(s); OutputDebugStringW(L"\n");
    FILE* f = nullptr;
    if (_wfopen_s(&f, L"C:\\r6esp\\r6esp.log", L"a") == 0 && f) {
        fwprintf(f, L"%ls\n", s); fclose(f);
    }
}
inline bool IsElevated() {
    HANDLE t = nullptr;
    if (!OpenProcessToken(GetCurrentProcess(), TOKEN_QUERY, &t)) return false;
    TOKEN_ELEVATION e{}; DWORD n = 0;
    BOOL ok = GetTokenInformation(t, TokenElevation, &e, sizeof e, &n);
    CloseHandle(t);
    return ok && e.TokenIsElevated;
}
inline void EnableDebugPriv() {
    HANDLE t = nullptr;
    if (!OpenProcessToken(GetCurrentProcess(), TOKEN_ADJUST_PRIVILEGES | TOKEN_QUERY, &t)) return;
    LUID l{}; TOKEN_PRIVILEGES tp{};
    if (LookupPrivilegeValueW(nullptr, L"SeDebugPrivilege", &l)) {
        tp.PrivilegeCount = 1; tp.Privileges[0].Luid = l;
        tp.Privileges[0].Attributes = SE_PRIVILEGE_ENABLED;
        AdjustTokenPrivileges(t, FALSE, &tp, sizeof tp, nullptr, nullptr);
    }
    CloseHandle(t);
}
inline bool EnableLoadDriverPriv() {
    HANDLE t = nullptr;
    if (!OpenProcessToken(GetCurrentProcess(), TOKEN_ADJUST_PRIVILEGES | TOKEN_QUERY, &t)) return false;
    LUID l{}; TOKEN_PRIVILEGES tp{};
    if (!LookupPrivilegeValueW(nullptr, L"SeLoadDriverPrivilege", &l)) { CloseHandle(t); return false; }
    tp.PrivilegeCount = 1; tp.Privileges[0].Luid = l;
    tp.Privileges[0].Attributes = SE_PRIVILEGE_ENABLED;
    SetLastError(0);
    BOOL ok = AdjustTokenPrivileges(t, FALSE, &tp, sizeof tp, nullptr, nullptr);
    DWORD e = GetLastError(); CloseHandle(t);
    return ok && e == ERROR_SUCCESS;
}

// -------------------------------------------------------------- transport --
struct Transport {
    const char* label = "none";
    u64 step = 0;
    virtual ~Transport() {}
    virtual bool Read(uintptr_t addr, void* buf, size_t sz) = 0;
    virtual uintptr_t ModuleBase() = 0;
    virtual size_t    ModuleSize() = 0;
    uintptr_t Ptr(uintptr_t a) { uintptr_t v = 0; return Read(a, &v, 8) ? v : 0; }
    template <class T> T Rd(uintptr_t a) { T v{}; Read(a, &v, sizeof(T)); return v; }
};

// -------------------------------------------------------------------- RPM --
struct RpmTransport : Transport {
    HANDLE h = nullptr; uintptr_t base = 0; size_t size = 0;
    RpmTransport() { label = "rpm"; }
    bool Open(DWORD pid) {
        h = OpenProcess(PROCESS_VM_READ | PROCESS_QUERY_INFORMATION, FALSE, pid);
        if (!h) return false;
        HMODULE m = nullptr; DWORD n = 0;
        if (EnumProcessModules(h, &m, sizeof m, &n) && m) {
            base = (uintptr_t)m;
            MODULEINFO mi{};
            if (GetModuleInformation(h, m, &mi, sizeof mi)) size = mi.SizeOfImage;
        }
        return base != 0;
    }
    bool Read(uintptr_t a, void* b, size_t s) override {
        SIZE_T got = 0;
        return ReadProcessMemory(h, (LPCVOID)a, b, s, &got) && got == s;
    }
    uintptr_t ModuleBase() override { return base; }
    size_t    ModuleSize() override { return size; }
};

// ----------------------------------------------------------------- kernel --
struct KernelTransport : Transport {
    HANDLE dev = INVALID_HANDLE_VALUE;
    HANDLE hRpm = nullptr;
    u64 cr3 = 0, gameEp = 0, nt = 0;
    uintptr_t base = 0; size_t size = 0;
    u8 buf[0x400];

    KernelTransport() { label = "kernel"; }

    DWORD Ioctl(DWORD code, DWORD len) {
        DWORD br = 0;
        return DeviceIoControl(dev, code, buf, len, buf, len, &br, nullptr) ? 0 : GetLastError();
    }
    bool KRead(u64 va, void* out, u32 len) {
        if (!va || !len) return false;
        memset(buf, 0, 0x48);
        *(u64*)(buf + 0x00) = 0x33;
        *(u64*)(buf + 0x10) = va;
        *(u64*)(buf + 0x18) = (u64)(ULONG_PTR)out;
        *(u64*)(buf + 0x20) = len;
        return Ioctl(0x80862007, 0x48) == 0;
    }
    bool KRead64(u64 va, u64* out) { return KRead(va, out, 8); }
    u64  MapPhys(u64 pa, u32 sz) {
        memset(buf, 0, 0x48);
        *(u64*)(buf + 0x00) = 0x19;
        *(u64*)(buf + 0x20) = pa;
        *(u32*)(buf + 0x28) = sz;
        return Ioctl(0x80862007, 0x48) ? 0 : *(u64*)(buf + 0x18);
    }
    void UnmapPhys(u64 va, u32 sz) {
        if (!va) return;
        memset(buf, 0, 0x48);
        *(u64*)(buf + 0x00) = 0x1A;
        *(u64*)(buf + 0x18) = va;
        *(u32*)(buf + 0x20) = sz;
        Ioctl(0x80862007, 0x48);
    }
    bool PhysRead(u64 pa, void* out, u32 len) {
        u8* p = (u8*)out; u32 left = len;
        while (left) {
            u64 page = pa & ~0xFFFULL;
            u32 off = (u32)(pa & 0xFFF);
            u32 chunk = 0x1000 - off; if (chunk > left) chunk = left;
            u64 m = MapPhys(page, 0x1000);
            if (!m) return false;
            bool ok = KRead(m + off, p, chunk);
            UnmapPhys(m, 0x1000);
            if (!ok) return false;
            pa += chunk; p += chunk; left -= chunk;
        }
        return true;
    }
    bool PhysRead64(u64 pa, u64* out) { return PhysRead(pa, out, 8); }

    struct PtEnt { u64 pa; bool ok; u8 pg[0x1000]; };
    PtEnt ptc[64]; int ptcN = 0;
    u64 tlbKey[512], tlbVal[512]; int tlbN = 0;

    void TlbPut(u64 k, u64 v) { if (tlbN < 512) { tlbKey[tlbN] = k; tlbVal[tlbN] = v; tlbN++; } }
    bool TlbGet(u64 k, u64* v) {
        for (int i = 0; i < tlbN; ++i) if (tlbKey[i] == k) { *v = tlbVal[i]; return true; }
        return false;
    }
    bool PtPage(u64 pa, u8* out) {
        for (int i = 0; i < ptcN; ++i) if (ptc[i].ok && ptc[i].pa == pa) { memcpy(out, ptc[i].pg, 0x1000); return true; }
        u64 m = MapPhys(pa, 0x1000);
        if (!m) return false;
        bool ok = KRead(m, out, 0x1000);
        UnmapPhys(m, 0x1000);
        if (ok && ptcN < 64) { ptc[ptcN].pa = pa; ptc[ptcN].ok = true; memcpy(ptc[ptcN].pg, out, 0x1000); ptcN++; }
        return ok;
    }
    u64 Translate(u64 va) {
        if (!cr3) return 0;
        u64 key = va & ~0xFFFULL, hit = 0;
        if (TlbGet(key, &hit)) return hit + (va & 0xFFF);
        u8 tb[0x1000]; u64 e = 0, pa = cr3 & 0x000FFFFFFFFFF000ull;
        if (!PtPage(pa, tb)) return 0;
        e = *(u64*)(tb + ((va >> 39) & 0x1FF) * 8); if (!(e & 1)) return 0;
        pa = e & 0x000FFFFFFFFFF000ull;
        if (!PtPage(pa, tb)) return 0;
        e = *(u64*)(tb + ((va >> 30) & 0x1FF) * 8); if (!(e & 1)) return 0;
        if (e & 0x80) { u64 r = (e & 0x000FFFFFC0000000ull) + (va & 0x3FFFFFFFull); TlbPut(key, r & ~0xFFFULL); return r; }
        pa = e & 0x000FFFFFFFFFF000ull;
        if (!PtPage(pa, tb)) return 0;
        e = *(u64*)(tb + ((va >> 21) & 0x1FF) * 8); if (!(e & 1)) return 0;
        if (e & 0x80) { u64 r = (e & 0x000FFFFFFFE00000ull) + (va & 0x1FFFFFull); TlbPut(key, r & ~0xFFFULL); return r; }
        pa = e & 0x000FFFFFFFFFF000ull;
        if (!PtPage(pa, tb)) return 0;
        e = *(u64*)(tb + ((va >> 12) & 0x1FF) * 8); if (!(e & 1)) return 0;
        u64 r = (e & 0x000FFFFFFFFFF000ull) + (va & 0xFFFull);
        TlbPut(key, r & ~0xFFFULL);
        return r;
    }
    bool Read(uintptr_t addr, void* b, size_t s) override {
        u64 va = addr;
        if (va >= 0xFFFF800000000000ull) return KRead(va, b, (u32)s);
        u8* p = (u8*)b; size_t left = s; bool any = false;
        while (left) {
            u32 chunk = 0x100000; if (chunk > left) chunk = (u32)left;
            if (hRpm) {
                SIZE_T g = 0;
                if (ReadProcessMemory(hRpm, (LPCVOID)va, p, chunk, &g) && g == chunk) {
                    va += chunk; p += chunk; left -= chunk; any = true; continue;
                }
                if (g) { va += g; p += g; left -= g; any = true; continue; }
                memset(p, 0, chunk); va += chunk; p += chunk; left -= chunk;
                continue;
            }
            u32 off = (u32)(va & 0xFFF);
            u32 c2 = 0x1000 - off; if (c2 > left) c2 = (u32)left;
            u64 pa = Translate(va & ~0xFFFULL);
            if (!pa || !PhysRead(pa + off, p, c2)) { memset(p, 0, c2); } else any = true;
            va += c2; p += c2; left -= c2;
        }
        return any;
    }
    uintptr_t ModuleBase() override { return base; }
    size_t    ModuleSize() override { return size; }

    u64 Resolve(const char* want) {
        u8 h[0x200]{}; if (!KRead(nt, h, sizeof h) || *(u16*)h != 0x5A4D) return 0;
        u32 lf = *(u32*)(h + 0x3C);
        u8 n[0x200]{}; if (!KRead(nt + lf, n, sizeof n) || *(u32*)n != 0x00004550) return 0;
        u32 soi = *(u32*)(n + 0x18 + 0x38), exp = *(u32*)(n + 0x18 + 0x70);
        if (!exp || exp >= soi) return 0;
        u8 ex[0x40]{}; if (!KRead(nt + exp, ex, sizeof ex)) return 0;
        u32 cnt = *(u32*)(ex + 0x18), fr = *(u32*)(ex + 0x1C);
        u32 nr = *(u32*)(ex + 0x20), orr = *(u32*)(ex + 0x24);
        if (!cnt || !fr || !nr || !orr) return 0;
        if (cnt > 0x4000) cnt = 0x4000;
        for (u32 i = 0; i < cnt; ++i) {
            u32 r = 0; if (!KRead(nt + nr + i * 4, &r, 4) || !r || r >= soi) continue;
            char nm[32]{}; if (!KRead(nt + r, nm, 31)) continue;
            if (strncmp(nm, want, 31)) continue;
            u16 od = 0; if (!KRead(nt + orr + i * 2, &od, 2)) return 0;
            u32 f2 = 0;
            if (!KRead(nt + fr + od * 4, &f2, 4)) return 0;
            return nt + f2;
        }
        return 0;
    }
    bool Open() {
        if (!IsElevated()) { Log(L"[kernel] not elevated"); return false; }
        EnableLoadDriverPriv();

        HMODULE nt_ = GetModuleHandleW(L"ntdll.dll");
        typedef NTSTATUS(NTAPI* P)(void*);
        auto pLoad = (P)GetProcAddress(nt_, "NtLoadDriver");
        const wchar_t* reg = L"\\Registry\\Machine\\System\\CurrentControlSet\\Services\\r6espNal2";

        const wchar_t* paths[] = { L"\\\\.\\Nal", L"\\\\.\\NAL", L"\\\\.\\iqvw64e" };
        for (int tries = 0; tries < 2 && dev == INVALID_HANDLE_VALUE; ++tries) {
            for (const wchar_t* p : paths) {
                dev = CreateFileW(p, GENERIC_READ | GENERIC_WRITE,
                                  FILE_SHARE_READ | FILE_SHARE_WRITE, nullptr, OPEN_EXISTING, 0, nullptr);
                Log(L"[kernel] open %ls err=%lu", p, dev == INVALID_HANDLE_VALUE ? GetLastError() : 0);
                if (dev != INVALID_HANDLE_VALUE) break;
            }
            if (dev != INVALID_HANDLE_VALUE) break;
            if (pLoad) {
                UNICODE_STRING us{}; us.Buffer = (PWSTR)reg;
                us.Length = (USHORT)(wcslen(reg) * 2);
                us.MaximumLength = (USHORT)(us.Length + 2);
                NTSTATUS st = pLoad(&us);
                Log(L"[kernel] NtLoadDriver=%08X", (unsigned)st);
                Sleep(500);
            }
        }
        if (dev == INVALID_HANDLE_VALUE) { Log(L"[kernel] no device err=%lu", GetLastError()); return false; }

        LPVOID mods[1024]; DWORD need = 0;
        EnumDeviceDrivers(mods, sizeof mods, &need);
        nt = (u64)(ULONG_PTR)mods[0];

        u8 mz[2]{}; DWORD he = 1;
        for (int t = 0; t < 3; ++t) {
            mz[0] = mz[1] = 0;
            memset(buf, 0, 0x48);
            *(u64*)(buf + 0x00) = 0x33;
            *(u64*)(buf + 0x10) = nt;
            *(u64*)(buf + 0x18) = (u64)(ULONG_PTR)mz;
            *(u64*)(buf + 0x20) = 2;
            he = Ioctl(0x80862007, 0x48);
            if (!he && mz[0] == 'M' && mz[1] == 'Z') break;
            Sleep(200);
        }
        u64 mt = MapPhys(0x100000, 0x1000);
        DWORD me = mt ? 0 : GetLastError();
        Log(L"[kernel] health nt=%llX readerr=%lu b=%02X%02X map=%llX maperr=%lu", nt, he, mz[0], mz[1], mt, me);
        if (mt) UnmapPhys(mt, 0x1000);
        if (he || mz[0] != 'M' || mz[1] != 'Z') { Log(L"[kernel] inert, holding handle"); return false; }
        Log(L"[kernel] open+probe ok");
        return true;
    }
    bool IsOpen() const { return dev != INVALID_HANDLE_VALUE; }
    bool Chain(DWORD pid) {

        u64 sym = Resolve("PsInitialSystemProcess");
        if (!sym) { Log(L"[kernel] no PsInitialSystemProcess"); return false; }
        u64 sys = 0;
        if (!KRead64(sym, &sys) || !sys) { Log(L"[kernel] no system EPROCESS"); return false; }

        u32 apl = 0; int best = 0;
        for (u32 off = 0x3C0; off <= 0x4A0; off += 8) {
            u64 f = 0; if (!KRead64(sys + off, &f) || f < 0xFFFF800000000000ull) continue;
            u64 ep = f - off; if (ep < 0xFFFF800000000000ull) continue;
            int score = 0; u64 cur = f;
            for (int i = 0; i < 12; ++i) {
                u64 nf = 0; if (!KRead64(cur, &nf) || nf < 0xFFFF800000000000ull) break;
                u64 e2 = nf - off; if (e2 < 0xFFFF800000000000ull) break;
                u8 nb[0x40]{}; if (!KRead(e2 + 0x330, nb, 0x40)) break;
                char c = (char)nb[0x08];
                if (c >= 'A' && c <= 'z') score++;
                cur = nf;
            }
            if (score > best) { best = score; apl = off; }
            if (best >= 12) break;
        }
        if (!apl) { Log(L"[kernel] no ActiveProcessLinks"); return false; }
        Log(L"[kernel] APL=0x%X score=%d", apl, best);

        u64 cur = sys + apl;
        for (int i = 0; i < 4000 && !gameEp; ++i) {
            u64 ep = cur - apl;
            u8 blk[0x100]{}; u64 nf = 0;
            if (Read((uintptr_t)(ep + 0x338), blk, 0xF0)) {
                nf = *(u64*)(blk + 0xE0);
                if (!strncmp((char*)blk, "RainbowSix", 10)) { gameEp = ep; break; }
            } else if (!KRead64(cur, &nf)) { Sleep(1); }
            if (!nf || nf < 0xFFFF800000000000ull) break;
            cur = nf;
        }
        if (!gameEp) { Log(L"[kernel] pid %lu not in list", pid); return false; }
        static const u32 po2[] = { 0x1D8, 0x1E0, 0x1E8, 0x440, 0x448 };
        for (u32 o : po2) {
            u64 v = 0; if (KRead64(gameEp + o, &v) && v == pid) Log(L"[kernel] pidoff=0x%X", o);
        }
        if (!KRead64(gameEp + 0x28, &cr3) || !cr3) { Log(L"[kernel] no CR3"); return false; }
        Log(L"[kernel] EPROCESS=%llX CR3=%llX", gameEp, cr3);
        ptcN = 0; tlbN = 0;
        {
            HANDLE ph = OpenProcess(PROCESS_QUERY_INFORMATION | PROCESS_VM_READ, FALSE, pid);
            if (ph) {
                HMODULE hm = nullptr; DWORD nb = 0;
                if (EnumProcessModules(ph, &hm, sizeof hm, &nb) && hm) {
                    base = (uintptr_t)hm;
                    MODULEINFO mi{};
                    if (GetModuleInformation(ph, hm, &mi, sizeof mi)) size = mi.SizeOfImage;
                }
                CloseHandle(ph);
            }
            if (base) Log(L"[kernel] IMG base=%llX size=%zX", (u64)base, size);
            hRpm = OpenProcess(PROCESS_VM_READ, FALSE, pid);
            if (hRpm) {
                u8 t[16]{}; SIZE_T g = 0;
                BOOL ok = ReadProcessMemory(hRpm, (LPCVOID)base, t, 16, &g);
                Log(L"[kernel] rpmprobe ok=%d got=%zu err=%lu", (int)ok, (size_t)g, ok ? 0 : GetLastError());
            } else Log(L"[kernel] rpmprobe open err=%lu", GetLastError());
            if (!base) Log(L"[kernel] user base failed, scanning EPROCESS");
        }

        for (u32 o = 0x300; o <= 0x800 && !base; o += 8) {
            u64 ib = 0;
            if (!KRead64(gameEp + o, &ib)) continue;
            if (ib < 0x10000 || ib >= 0x800000000000ull) continue;
            if (ib & 0xFFFF) continue;
            u8 ph[0x1000]{};
            if (!Read((uintptr_t)ib, ph, sizeof ph)) { Log(L"[kernel] +0x%X unreadable %llX", o, ib); continue; }
            if (ph[0] != 'M' || ph[1] != 'Z') { Log(L"[kernel] +0x%X noMZ %llX", o, ib); continue; }
            u32 lf2 = *(u32*)(ph + 0x3C);
            if (lf2 + 0x60 > 0x1000) continue;
            if (*(u32*)(ph + lf2) != 0x00004550) continue;
            u16 ch = *(u16*)(ph + lf2 + 0x16);
            if (ch & 0x2000) { Log(L"[kernel] dll +0x%X %llX", o, ib); continue; }
            base = (uintptr_t)ib;
            size = *(u32*)(ph + lf2 + 0x18 + 0x38);
            Log(L"[kernel] IMG +0x%X image=%llX size=%zX", o, ib, size);
        }
        if (!base || !size) { Log(L"[kernel] no module"); return false; }
        return true;
    }
};

inline void HexDump(const char* tag, uintptr_t addr) {
    u8 b[64]{};
    if (!g_mem || !g_mem->Read(addr, b, 64)) { Log(L"[%hs] unreadable", tag); return; }
    for (int o = 0; o < 64; o += 16) {
        wchar_t s[128]; int p = 0;
        for (int i = 0; i < 16; ++i) p += swprintf_s(s + p, 128 - p, L"%02X ", b[o + i]);
        Log(L"[%hs] +%02X %ls", tag, o, s);
    }
}
