  0000000140004040: 48 89 5C 24 08     mov         qword ptr [rsp+8],rbx
  0000000140004045: 48 89 6C 24 10     mov         qword ptr [rsp+10h],rbp
  000000014000404A: 48 89 74 24 18     mov         qword ptr [rsp+18h],rsi
  000000014000404F: 57                 push        rdi
  0000000140004050: 48 83 EC 30        sub         rsp,30h
  0000000140004054: 33 ED              xor         ebp,ebp
  0000000140004056: 49 8B F8           mov         rdi,r8
  0000000140004059: 8B F2              mov         esi,edx
  000000014000405B: 48 8B D9           mov         rbx,rcx
  000000014000405E: 48 85 C9           test        rcx,rcx
  0000000140004061: 74 62              je          00000001400040C5
  0000000140004063: 4D 85 C0           test        r8,r8
  0000000140004066: 74 5D              je          00000001400040C5
  0000000140004068: 33 D2              xor         edx,edx
  000000014000406A: E8 BD F0 FF FF     call        000000014000312C
  000000014000406F: 48 85 C0           test        rax,rax
  0000000140004072: 74 2A              je          000000014000409E
  0000000140004074: 44 8D 0C B5 00 00  lea         r9d,[rsi*4+0000000000000000h]
  000000014000407C: C7 44 24 20 04 00  mov         dword ptr [rsp+20h],4
  0000000140004084: 41 B0 0F           mov         r8b,0Fh
  0000000140004087: 48 8B D7           mov         rdx,rdi
  000000014000408A: 48 8B C8           mov         rcx,rax
  000000014000408D: E8 B6 FC FF FF     call        0000000140003D48
  0000000140004092: 85 C0              test        eax,eax
  0000000140004094: B9 09 40 6A C8     mov         ecx,0C86A4009h
  0000000140004099: 0F 49 CD           cmovns      ecx,ebp
  000000014000409C: EB 2C              jmp         00000001400040CA
  000000014000409E: 4C 8B C7           mov         r8,rdi
  00000001400040A1: 8B D6              mov         edx,esi
  00000001400040A3: 48 8B CB           mov         rcx,rbx
  00000001400040A6: E8 39 00 00 00     call        00000001400040E4
  00000001400040AB: 8B C8              mov         ecx,eax
  00000001400040AD: 3D 02 10 6A C8     cmp         eax,0C86A1002h
  00000001400040B2: 75 16              jne         00000001400040CA
  00000001400040B4: 4C 8B C7           mov         r8,rdi
  00000001400040B7: 8B D6              mov         edx,esi
  00000001400040B9: 48 8B CB           mov         rcx,rbx
  00000001400040BC: E8 AF 00 00 00     call        0000000140004170
  00000001400040C1: 8B C8              mov         ecx,eax
  00000001400040C3: EB 05              jmp         00000001400040CA
  00000001400040C5: B9 01 00 00 00     mov         ecx,1
  00000001400040CA: 48 8B 5C 24 40     mov         rbx,qword ptr [rsp+40h]
  00000001400040CF: 8B C1              mov         eax,ecx
  00000001400040D1: 48 8B 6C 24 48     mov         rbp,qword ptr [rsp+48h]
  00000001400040D6: 48 8B 74 24 50     mov         rsi,qword ptr [rsp+50h]
  00000001400040DB: 48 83 C4 30        add         rsp,30h
  00000001400040DF: 5F                 pop         rdi
  00000001400040E0: C3                 ret
  00000001400040E1: CC                 int         3
  00000001400040E2: CC                 int         3
  00000001400040E3: CC                 int         3
  00000001400040E4: 48 8B C4           mov         rax,rsp
  00000001400040E7: 48 89 58 10        mov         qword ptr [rax+10h],rbx
  00000001400040EB: 48 89 70 18        mov         qword ptr [rax+18h],rsi
  00000001400040EF: 57                 push        rdi
  00000001400040F0: 48 83 EC 20        sub         rsp,20h
  00000001400040F4: 48 83 60 08 00     and         qword ptr [rax+8],0
  00000001400040F9: 49 8B F8           mov         rdi,r8
  00000001400040FC: 8B F2              mov         esi,edx
  00000001400040FE: BB 01 00 00 00     mov         ebx,1
