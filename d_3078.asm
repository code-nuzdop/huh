  0000000140003072: 48 83 C4 60        add         rsp,60h
  0000000140003076: 5F                 pop         rdi
  0000000140003077: C3                 ret
  0000000140003078: 48 89 5C 24 08     mov         qword ptr [rsp+8],rbx
  000000014000307D: 48 89 74 24 10     mov         qword ptr [rsp+10h],rsi
  0000000140003082: 57                 push        rdi
  0000000140003083: 48 83 EC 20        sub         rsp,20h
  0000000140003087: 48 8B F2           mov         rsi,rdx
  000000014000308A: 48 8B D9           mov         rbx,rcx
  000000014000308D: BF 01 00 00 00     mov         edi,1
  0000000140003092: 48 85 C9           test        rcx,rcx
  0000000140003095: 74 41              je          00000001400030D8
  0000000140003097: 48 85 D2           test        rdx,rdx
  000000014000309A: 74 3C              je          00000001400030D8
  000000014000309C: 0F B6 49 03        movzx       ecx,byte ptr [rcx+3]
  00000001400030A0: E8 47 00 00 00     call        00000001400030EC
  00000001400030A5: 4C 8B C0           mov         r8,rax
  00000001400030A8: 48 85 C0           test        rax,rax
  00000001400030AB: 74 2B              je          00000001400030D8
  00000001400030AD: 8B 0B              mov         ecx,dword ptr [rbx]
  00000001400030AF: 8B D1              mov         edx,ecx
  00000001400030B1: 0F B6 C1           movzx       eax,cl
  00000001400030B4: 48 C1 E0 05        shl         rax,5
  00000001400030B8: 48 C1 EA 08        shr         rdx,8
  00000001400030BC: C1 E9 0D           shr         ecx,0Dh
  00000001400030BF: 83 E2 1F           and         edx,1Fh
  00000001400030C2: 48 03 D0           add         rdx,rax
  00000001400030C5: 83 E1 07           and         ecx,7
  00000001400030C8: C1 E1 02           shl         ecx,2
  00000001400030CB: 41 8B 04 90        mov         eax,dword ptr [r8+rdx*4]
  00000001400030CF: D3 E8              shr         eax,cl
  00000001400030D1: 83 E0 0F           and         eax,0Fh
  00000001400030D4: 89 06              mov         dword ptr [rsi],eax
  00000001400030D6: 33 FF              xor         edi,edi
  00000001400030D8: 48 8B 5C 24 30     mov         rbx,qword ptr [rsp+30h]
  00000001400030DD: 8B C7              mov         eax,edi
  00000001400030DF: 48 8B 74 24 38     mov         rsi,qword ptr [rsp+38h]
  00000001400030E4: 48 83 C4 20        add         rsp,20h
  00000001400030E8: 5F                 pop         rdi
  00000001400030E9: C3                 ret
  00000001400030EA: CC                 int         3
  00000001400030EB: CC                 int         3
  00000001400030EC: 44 8B 15 55 51 00  mov         r10d,dword ptr [0000000140008248h]
  00000001400030F3: 33 D2              xor         edx,edx
  00000001400030F5: 44 8B C2           mov         r8d,edx
  00000001400030F8: 45 85 D2           test        r10d,r10d
  00000001400030FB: 74 2B              je          0000000140003128
  00000001400030FD: 4C 8B 1D 4C 51 00  mov         r11,qword ptr [0000000140008250h]
