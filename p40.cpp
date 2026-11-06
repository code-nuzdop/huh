// p40.cpp - drive 0x8086200B registration, then map + slot read
#define WIN32_LEAN_AND_MEAN
#define _CRT_SECURE_NO_WARNINGS
#include <windows.h>
#include <psapi.h>
#include <stdio.h>
#include <stdint.h>
#include <stdarg.h>
#include <string.h>
#pragma comment(lib, "psapi.lib")
typedef uint64_t u64; typedef uint32_t u32; typedef uint8_t u8;

static HANDLE g_h = INVALID_HANDLE_VALUE;
static FILE*  g_log = nullptr;
static u8     g_big[0x1400];
static u32    g_size;

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
    BOOL ok = DeviceIoControl(g_h, ioctl, b, len, b, len, &br, nullptr);
    return ok ? 0 : GetLastError();
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

static void ProbeB(u32 cas, u32 tag) {
    const DWORD lens[] = { 0x130, 0x200, 0x400, 0x800, 0x1000 };
    for (DWORD len : lens) {
        memset(g_big, 0, len);
        Q(g_big, 0x00, cas); Q(g_big, 0x08, tag);
        D(g_big, 0x120, 0x1000); D(g_big, 0x124, 0x1000);
        DWORD e = Call(0x8086200B, g_big, len);
        u64 slot = 0;
        u32 st = TryMap(0x1000, 0x1000, &slot);
        L("B cas=%02X tag=%03X len=%u err=%lu r10=%016llX r18=%016llX r20=%016llX "
          "r120=%08X r124=%08X | map=%08X slot=%llu %s",
          cas, tag, len, e, Gq(g_big, 0x10), Gq(g_big, 0x18), Gq(g_big, 0x20),
          Gd(g_big, 0x120), Gd(g_big, 0x124), st, slot,
          (e == 0 && st == 0) ? "*** REGISTERED ***" : "");
    }
}

int main() {
    g_log = fopen("C:\\r6esp\\p40.log", "w");
    const wchar_t* paths[] = { L"\\\\.\\NAL_1_5", L"\\\\.\\Nal", L"\\\\.\\NAL" };
    for (const wchar_t* p : paths) {
        g_h = CreateFileW(p, GENERIC_READ | GENERIC_WRITE,
                          FILE_SHARE_READ | FILE_SHARE_WRITE, nullptr, OPEN_EXISTING, 0, nullptr);
        if (g_h != INVALID_HANDLE_VALUE) { L("open %ls ok", p); break; }
    }
    if (g_h == INVALID_HANDLE_VALUE) { L("no device"); return 1; }

    L("--- A. 0x8086200B case 7 (tag 110) ---");
    ProbeB(7, 0x110);
    L("--- B. 0x8086200B case 4 (tag 118) ---");
    ProbeB(4, 0x118);
    L("--- C. 0x8086200B case 5 (tag 118) ---");
    ProbeB(5, 0x118);

    L("--- D. 0x80862007 case 00 (tag 8), length sensitivity ---");
    const DWORD cl[] = { 0x1C, 0x20, 0x40, 0x100, 0x400 };
    for (DWORD len : cl) {
        memset(g_big, 0, len);
        Q(g_big, 0x00, 0x00); Q(g_big, 0x08, 8);
        DWORD e = Call(0x80862007, g_big, len);
        L("D len=%u err=%lu r10=%016llX", len, e, Gq(g_big, 0x10));
    }

    L("--- E. final map + slot read of phys 0x100000 ---");
    u64 slot = 0;
    u32 st = TryMap(0x100000, 0x1000, &slot);
    L("E map status=%08X slot=%llu", st, slot);
    if (st == 0) {
        for (u32 off = 0; off < 0x20; off += 4)
            L("E slot[%llu]+%02X = %08X", slot, off, SlotRd(slot, off));
        TryUnmap(slot, 0x100000, 0x1000);
    }
    L("=== p40 done ===");
    if (g_log) fclose(g_log);
    return 0;
}