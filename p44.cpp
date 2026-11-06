// p44.cpp - 0x80862013 read addressing mode + case 0x37 buffer
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

static void R13v(u32 cas, u32 tag, u64 p18, u32 p20, const char* nm) {
    memset(g_big, 0, 0x48);
    Q(g_big, 0x00, cas); Q(g_big, 0x08, tag);
    Q(g_big, 0x18, p18); D(g_big, 0x20, p20);
    DWORD e = Call(0x80862013, g_big, 0x48);
    L("R13 %-16s cas=%02X tag=%02X err=%lu r10=%08X", nm, cas, tag, e, Gd(g_big, 0x10));
}
static void C37(u32 a18, u32 a1C, u64 a28, u32 a20, const char* nm) {
    memset(g_big, 0, 0x60);
    Q(g_big, 0x00, 0x37); Q(g_big, 0x08, 0x20);
    D(g_big, 0x18, a18); D(g_big, 0x1C, a1C);
    Q(g_big, 0x28, a28); D(g_big, 0x20, a20);
    DWORD e = Call(0x80862007, g_big, 0x60);
    L("C37 %-16s err=%lu r10=%016llX r18=%08X r1C=%08X r20=%08X r28=%016llX",
      nm, e, Gq(g_big, 0x10), Gd(g_big, 0x18), Gd(g_big, 0x1C), Gd(g_big, 0x20), Gq(g_big, 0x28));
}

int main() {
    g_log = fopen("C:\\r6esp\\p44.log", "w");
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

    L("--- reads with +18 = kernel VA ---");
    R13v(0x0B, 0x18, g_nt, 0,      "VA off0 byte");
    R13v(0x0B, 0x18, g_nt, 0x1000, "VA off1000 byte");
    R13v(0x0D, 0x18, g_nt, 0,      "VA off0 dword");
    R13v(0x0D, 0x18, g_nt, 0x1000, "VA off1000 dword");

    L("--- reads with +18 = small slot, +20 = offset ---");
    R13v(0x0B, 0x18, 0, 0,         "slot0 off0");
    R13v(0x0D, 0x18, 0, 0x1000,    "slot0 off1000");

    L("--- case 0x37 buffer ---");
    C37(1, 0, 0x1000, 0,           "1,0,1000,0");
    C37(0x1000, 0, 0x1000, 0,      "1000,0,1000,0");
    C37(1, 0, g_nt, 0,             "1,0,nt,0");
    C37(0x1000, 0x1000, 0x1000, 0x1000, "all1000");

    L("=== p44 done ===");
    if (g_log) fclose(g_log);
    return 0;
}