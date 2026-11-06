// p41.cpp - descriptor matrix for 0x8086200B cases 4/5/7
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
static u8     g_desc[0x100];
static u8     g_out[0x400];
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

static void Run(u32 cas, u32 tag, u64 s0, u64 s1, u32 d120, u32 d124, const char* nm) {
    memset(g_big, 0, 0x130);
    memset(g_desc, 0, sizeof g_desc);
    memset(g_out, 0xCC, sizeof g_out);
    Q(g_big, 0x00, cas); Q(g_big, 0x08, tag);
    Q(g_desc, 0x00, s0); Q(g_desc, 0x08, s1);
    Q(g_big, 0x18, (u64)(ULONG_PTR)g_desc);
    D(g_big, 0x120, d120); D(g_big, 0x124, d124);
    DWORD e = Call(0x8086200B, g_big, 0x130);
    u32 r10 = Gd(g_big, 0x10);
    u64 slot = 0;
    u32 st = TryMap(0x1000, 0x1000, &slot);
    u16 w = 0; memcpy(&w, g_out, 2);
    L("cas=%02X %-22s err=%lu r10=%08X out=%04X r18=%016llX | map=%08X %s%s",
      cas, nm, e, r10, w, Gq(g_big, 0x18), st,
      (e == 0 && st == 0) ? " ***REGISTERED***" : "",
      (w == 0x5A4D) ? " ***MZ***" : "");
}

int main() {
    g_log = fopen("C:\\r6esp\\p41.log", "w");
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
    L("ntoskrnl=%016llX", g_nt);

    L("--- case 7 descriptor matrix (tag 110) ---");
    Run(7, 0x110, 0, 0, 0, 0, "zero/zero");
    Run(7, 0x110, g_nt, 0, 0, 0, "nt/zero");
    Run(7, 0x110, g_nt, 0x1000, 0, 0, "nt/size");
    Run(7, 0x110, 0x1000, 0x1000, 0, 0, "phys/size");
    Run(7, 0x110, (u64)(ULONG_PTR)g_out, 0x400, 0, 0, "outptr/size");
    Run(7, 0x110, 0, 0x600, 0, 0x600, "count/max600");
    Run(7, 0x110, 0, 0, 0x1000, 0x1000, "d120/d124 1000");
    Run(7, 0x110, 0, 0, 0x600, 0, "d120=600");

    L("--- case 5 (tag 118) ---");
    Run(5, 0x118, 0, 0, 0, 0, "zero/zero");
    Run(5, 0x118, g_nt, 0, 0, 0x20, "nt/-, d124=20");
    Run(5, 0x118, (u64)(ULONG_PTR)g_out, g_nt, 0, 0x20, "out,nt,d124=20");
    Run(5, 0x118, g_nt, 0x20, 0x1000, 0, "nt,20,d120=1000");
    Run(5, 0x118, 0x1000, 0x1000, 0x1000, 0x1000, "phys/size all1000");

    L("--- case 4 (tag 118) ---");
    Run(4, 0x118, 0, 0, 0, 0, "zero/zero");
    Run(4, 0x118, g_nt, 0, 0, 0x20, "nt/-, d124=20");
    Run(4, 0x118, (u64)(ULONG_PTR)g_out, g_nt, 0, 0x20, "out,nt,d124=20");
    Run(4, 0x118, 0x1000, 0x1000, 0x1000, 0x1000, "phys/size all1000");

    L("--- map sweep at phys 0 / 0x1000 ---");
    const u64 ph[] = { 0, 0x1000, 0xA0000 };
    const u32 sz[] = { 0x1000, 0x10000, 0x100000 };
    for (u64 p : ph) for (u32 s : sz) {
        u64 slot = 0;
        u32 st = TryMap(p, s, &slot);
        L("map phys=%llX size=%X -> %08X slot=%llu", p, s, st, slot);
    }
    L("=== p41 done ===");
    if (g_log) fclose(g_log);
    return 0;
}
