// p42.cpp - write family test + 0x80862013 registration matrix
#define WIN32_LEAN_AND_MEAN
#define _CRT_SECURE_NO_WARNINGS
#include <windows.h>
#include <psapi.h>
#include <stdio.h>
#include <stdint.h>
#include <stdarg.h>
#include <string.h>
#pragma comment(lib, "psapi.lib")
typedef uint64_t u64; typedef uint32_t u32; typedef uint16_t u16; typedef uint8_t u8;

static HANDLE g_h = INVALID_HANDLE_VALUE;
static FILE*  g_log = nullptr;
static u8     g_big[0x1400];
static u8     g_dst[0x100];
static u64    g_dstVA;
static u32    g_size;
static u64    g_nt;

static void L(const char* fmt, ...) {
    char s[2048]; va_list ap; va_start(ap, fmt);
    vsnprintf(s, sizeof s, fmt, ap); va_end(ap);
    printf("%s\n", s); fflush(stdout);
    if (g_log) { fprintf(g_log, "%s\n", s); fflush(g_log); }
}
static void Q(u8* b, u32 o, u64 v) { memcpy(b + o, &v, 8); }
static void D(u8* b, u32 o, u32 v) { memcpy(b + o, &v, 4); }
static u32  Gd(u8* b, u32 o) { u32 v; memcpy(&v, b + o, 4); return v; }
static u64  Gq(u8* b, u32 o) { u64 v; memcpy(&v, b + o, 8); return v; }
static DWORD Call(DWORD ioctl, u8* b, DWORD len) {
    DWORD br = 0;
    return DeviceIoControl(g_h, ioctl, b, len, b, len, &br, nullptr) ? 0 : GetLastError();
}
static u32 TryMap(u64 phys, u32 size, u64* slot) {
    memset(g_big, 0, 0x48);
    Q(g_big, 0x00, 0x19); Q(g_big, 0x08, 0x28);
    Q(g_big, 0x20, phys);
    g_size = size;
    Q(g_big, 0x28, (u64)(ULONG_PTR)&g_size);
    DWORD e = Call(0x80862007, g_big, 0x48);
    *slot = Gq(g_big, 0x18);
    return e ? 0xFFFFFFFFu : Gd(g_big, 0x10);
}

static void WrTest(u32 cas, u32 tag, u32 val, const char* nm) {
    memset(g_dst, 0xCC, 0x20);
    memset(g_big, 0, 0x48);
    Q(g_big, 0x00, cas); Q(g_big, 0x08, tag);
    Q(g_big, 0x18, g_dstVA);
    D(g_big, 0x20, val);
    DWORD e = Call(0x80862007, g_big, 0x48);
    u32 r10 = Gd(g_big, 0x10), got = 0;
    memcpy(&got, g_dst, 4);
    L("WR %-10s cas=%02X tag=%02X err=%lu r10=%08X dst=%08X %s",
      nm, cas, tag, e, r10, got, (got != 0xCCCCCCCC) ? "*** CHANGED ***" : "");
}
static void RdTest(u32 cas, u32 tag, const char* nm) {
    memset(g_big, 0, 0x48);
    Q(g_big, 0x00, cas); Q(g_big, 0x08, tag);
    Q(g_big, 0x18, g_dstVA);
    DWORD e = Call(0x80862007, g_big, 0x48);
    L("RD %-10s cas=%02X tag=%02X err=%lu r10=%08X", nm, cas, tag, e, Gd(g_big, 0x10));
}
static void Reg13(u32 cas, u32 tag, u64 p10, const char* nm) {
    memset(g_big, 0, 0x130);
    Q(g_big, 0x00, cas); Q(g_big, 0x08, tag);
    Q(g_big, 0x10, p10);
    DWORD e = Call(0x80862013, g_big, 0x130);
    u32 r10 = Gd(g_big, 0x10), r118 = Gd(g_big, 0x118);
    u64 slot = 0;
    u32 st = TryMap(0x1000, 0x1000, &slot);
    L("R13 %-14s cas=%02X tag=%03X err=%lu r10=%08X r118=%08X | map=%08X slot=%llu %s",
      nm, cas, tag, e, r10, r118, st, slot, (st == 0) ? "***REG***" : "");
}

int main() {
    g_dstVA = (u64)(ULONG_PTR)g_dst;
    g_log = fopen("C:\\r6esp\\p42.log", "w");
    const wchar_t* paths[] = { L"\\\\.\\NAL_1_5", L"\\\\.\\Nal", L"\\\\.\\NAL" };
    for (const wchar_t* p : paths) {
        g_h = CreateFileW(p, GENERIC_READ | GENERIC_WRITE,
                          FILE_SHARE_READ | FILE_SHARE_WRITE, nullptr, OPEN_EXISTING, 0, nullptr);
        if (g_h != INVALID_HANDLE_VALUE) break;
    }
    if (g_h == INVALID_HANDLE_VALUE) { L("no device - start r6espNal_316_1"); return 1; }
    LPVOID mods[1024]; DWORD need = 0;
    EnumDeviceDrivers(mods, sizeof mods, &need);
    g_nt = (u64)(ULONG_PTR)mods[0];
    L("ntoskrnl=%016llX dst=%016llX", g_nt, g_dstVA);

    L("--- write family (into our own buffer) ---");
    WrTest(0x13, 0x18, 0xDEADBEEF, "byte");
    WrTest(0x14, 0x18, 0xDEADBEEF, "word");
    WrTest(0x15, 0x18, 0xDEADBEEF, "dword");

    L("--- read family back ---");
    memset(g_dst, 0xEF, 0x20);
    RdTest(0x0D, 0x10, "byte");
    RdTest(0x0E, 0x10, "word");
    RdTest(0x0F, 0x10, "dword");

    L("--- 0x80862013 case 8 (tag 110) with varying ctx+10 ---");
    Reg13(8, 0x110, 0, "p10=0");
    Reg13(8, 0x110, g_nt, "p10=nt");
    Reg13(8, 0x110, 0x1000, "p10=1000");

    L("--- 0x80862013 other cases x tags ---");
    const u32 tags[] = { 8, 0x18, 0x20, 0x28, 0x110, 0x120 };
    const u32 cases[] = { 6, 7, 0x0A, 0x0B };
    for (u32 c : cases) for (u32 tg : tags) Reg13(c, tg, g_nt, "scan");

    L("=== p42 done ===");
    if (g_log) fclose(g_log);
    return 0;
}