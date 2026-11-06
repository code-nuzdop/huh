// p45.cpp - run BAR registration, then scan for registered ranges
#define WIN32_LEAN_AND_MEAN
#define _CRT_SECURE_NO_WARNINGS
#include <windows.h>
#include <stdio.h>
#include <stdint.h>
#include <stdarg.h>
#include <string.h>
typedef uint64_t u64; typedef uint32_t u32; typedef uint8_t u8;

static HANDLE g_h = INVALID_HANDLE_VALUE;
static FILE*  g_log = nullptr;
static u8     g_big[0x1400];
static u32    g_size;

static void L(const char* fmt, ...) {
    char s[1024]; va_list ap; va_start(ap, fmt);
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
static void TryUnmap(u64 slot, u64 phys, u32 size) {
    memset(g_big, 0, 0x48);
    Q(g_big, 0x00, 0x1A); Q(g_big, 0x08, 0x28);
    Q(g_big, 0x18, slot); Q(g_big, 0x20, phys); D(g_big, 0x28, size);
    Call(0x80862007, g_big, 0x48);
}
static u32 SlotRd(u64 slot, u32 off) {
    memset(g_big, 0, 0x48);
    Q(g_big, 0x00, 0x0D); Q(g_big, 0x08, 0x18);
    Q(g_big, 0x18, slot); D(g_big, 0x20, off);
    DWORD e = Call(0x80862013, g_big, 0x48);
    return e ? 0xFFFFFFFFu : Gd(g_big, 0x10);
}

static int g_hits = 0;

static void Scan(u64 lo, u64 hi, u64 step) {
    for (u64 p = lo; p < hi; p += step) {
        u64 slot = 0;
        u32 st = TryMap(p, 0x1000, &slot);
        if (st != 0) continue;
        u32 v = SlotRd(slot, 0);
        if (g_hits < 60)
            L("HIT phys=%09llX slot=%llu dword=%08X", p, slot, v);
        g_hits++;
        TryUnmap(slot, p, 0x1000);
    }
    L("  scan %09llX..%09llX step %llX done, hits=%d", lo, hi, step, g_hits);
}

int main() {
    g_log = fopen("C:\\r6esp\\p45.log", "w");
    const wchar_t* paths[] = { L"\\\\.\\NAL_1_5", L"\\\\.\\Nal", L"\\\\.\\NAL" };
    for (const wchar_t* p : paths) {
        g_h = CreateFileW(p, GENERIC_READ | GENERIC_WRITE,
                          FILE_SHARE_READ | FILE_SHARE_WRITE, nullptr, OPEN_EXISTING, 0, nullptr);
        if (g_h != INVALID_HANDLE_VALUE) break;
    }
    if (g_h == INVALID_HANDLE_VALUE) { L("no device - start r6espNal_316_1"); return 1; }

    L("--- run registrar: 0x8086200B case 7 tag 110 ---");
    memset(g_big, 0, 0x130);
    Q(g_big, 0x00, 7); Q(g_big, 0x08, 0x110);
    DWORD e = Call(0x8086200B, g_big, 0x130);
    L("case7 err=%lu r10=%08X r18=%016llX r20=%016llX r120=%08X r124=%08X",
      e, Gd(g_big, 0x10), Gq(g_big, 0x18), Gq(g_big, 0x20), Gd(g_big, 0x120), Gd(g_big, 0x124));

    L("--- 0x80862013 case 6 (tag 4) ---");
    memset(g_big, 0, 0x48);
    Q(g_big, 0x00, 6); Q(g_big, 0x08, 4);
    e = Call(0x80862013, g_big, 0x48);
    L("case6 err=%lu r10=%08X", e, Gd(g_big, 0x10));

    L("--- scan MMIO 0x80000000..0x100000000 step 0x1000 ---");
    Scan(0x80000000ull, 0x100000000ull, 0x1000ull);
    L("--- scan 0x100000000..0x400000000 step 0x100000 ---");
    Scan(0x100000000ull, 0x400000000ull, 0x100000ull);

    L("=== p45 done hits=%d ===", g_hits);
    if (g_log) fclose(g_log);
    return 0;
}