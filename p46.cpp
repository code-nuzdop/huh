// p46.cpp - registrar with r120/r124 set, targeted MMIO probes, then scan
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
static int    g_hits = 0;

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
static void One(u64 p) {
    u64 slot = 0;
    u32 st = TryMap(p, 0x1000, &slot);
    if (st != 0) { L("  probe %09llX -> %08X", p, st); return; }
    L("HIT phys=%09llX slot=%llu dword=%08X", p, slot, SlotRd(slot, 0));
    g_hits++;
    TryUnmap(slot, p, 0x1000);
}
static void Scan(u64 lo, u64 hi, u64 step) {
    for (u64 p = lo; p < hi; p += step) {
        u64 slot = 0;
        u32 st = TryMap(p, 0x1000, &slot);
        if (st != 0) continue;
        if (g_hits < 60) L("HIT phys=%09llX slot=%llu dword=%08X", p, slot, SlotRd(slot, 0));
        g_hits++;
        TryUnmap(slot, p, 0x1000);
    }
    L("  scan %09llX..%09llX step %llX done hits=%d", lo, hi, step, g_hits);
}

int main() {
    g_log = fopen("C:\\r6esp\\p46.log", "w");
    const wchar_t* paths[] = { L"\\\\.\\NAL_1_5", L"\\\\.\\Nal", L"\\\\.\\NAL" };
    for (const wchar_t* p : paths) {
        g_h = CreateFileW(p, GENERIC_READ | GENERIC_WRITE,
                          FILE_SHARE_READ | FILE_SHARE_WRITE, nullptr, OPEN_EXISTING, 0, nullptr);
        if (g_h != INVALID_HANDLE_VALUE) break;
    }
    if (g_h == INVALID_HANDLE_VALUE) { L("no device - start r6espNal_316_1"); return 1; }

    L("--- registrar: case 7 tag 110, r120/r124 = 1000 ---");
    memset(g_big, 0, 0x130);
    Q(g_big, 0x00, 7); Q(g_big, 0x08, 0x110);
    D(g_big, 0x120, 0x1000); D(g_big, 0x124, 0x1000);
    DWORD e = Call(0x8086200B, g_big, 0x130);
    L("case7 err=%lu r10=%08X r18=%016llX r20=%016llX", e, Gd(g_big, 0x10), Gq(g_big, 0x18), Gq(g_big, 0x20));
    for (u32 o = 0; o < 0x40; o += 0x20)
        L("  +%02X %016llX %016llX %016llX %016llX", o,
          Gq(g_big, o), Gq(g_big, o + 8), Gq(g_big, o + 16), Gq(g_big, o + 24));

    L("--- targeted MMIO probes ---");
    One(0xFEE00000ull); One(0xFED00000ull); One(0xFEBF0000ull); One(0xFE000000ull);
    One(0xF0000000ull); One(0xE0000000ull); One(0xD0000000ull); One(0xC0000000ull);

    L("--- scan 0xFE000000..0xFFF00000 step 0x1000 ---");
    Scan(0xFE000000ull, 0xFFF00000ull, 0x1000ull);
    L("--- scan 0x100000..0x80000000 step 0x100000 ---");
    Scan(0x100000ull, 0x80000000ull, 0x100000ull);
    L("--- scan 0x80000000..0x100000000 step 0x1000 ---");
    Scan(0x80000000ull, 0x100000000ull, 0x1000ull);

    L("=== p46 done hits=%d ===", g_hits);
    if (g_log) fclose(g_log);
    return 0;
}