  0000000140003B00: 49 89 43 C8        mov         qword ptr [r11-38h],rax
  0000000140003B04: 21 5C 24 30        and         dword ptr [rsp+30h],ebx
  0000000140003B08: 45 33 C9           xor         r9d,r9d
  0000000140003B0B: 45 33 C0           xor         r8d,r8d
  0000000140003B0E: 8B F2              mov         esi,edx
  0000000140003B10: 0F 11 44 24 38     movups      xmmword ptr [rsp+38h],xmm0
  0000000140003B15: 48 8B F9           mov         rdi,rcx
  0000000140003B18: FF 15 D2 25 00 00  call        qword ptr [00000001400060F0h]
  0000000140003B1E: 3D 23 00 00 C0     cmp         eax,0C0000023h
  0000000140003B23: 0F 85 98 00 00 00  jne         0000000140003BC1
  0000000140003B29: 8B 4C 24 30        mov         ecx,dword ptr [rsp+30h]
  0000000140003B2D: 85 C9              test        ecx,ecx
  0000000140003B2F: 0F 84 8C 00 00 00  je          0000000140003BC1
  0000000140003B35: 48 8B 44 24 38     mov         rax,qword ptr [rsp+38h]
  0000000140003B3A: 44 8D 4B 10        lea         r9d,[rbx+10h]
  0000000140003B3E: 48 25 01 FF FF FF  and         rax,0FFFFFFFFFFFFFF01h
  0000000140003B44: 44 89 4C 24 40     mov         dword ptr [rsp+40h],r9d
  0000000140003B49: 48 83 C8 01        or          rax,1
  0000000140003B4D: 8B D1              mov         edx,ecx
  0000000140003B4F: 48 89 44 24 38     mov         qword ptr [rsp+38h],rax
  0000000140003B54: 41 B8 30 31 76 71  mov         r8d,71763130h
  0000000140003B5A: 48 8B 05 FF 46 00  mov         rax,qword ptr [0000000140008260h]
  0000000140003B61: 48 85 C0           test        rax,rax
  0000000140003B64: 74 1A              je          0000000140003B80
  0000000140003B66: 4C 8D 4C 24 38     lea         r9,[rsp+38h]
  0000000140003B6B: C7 44 24 20 01 00  mov         dword ptr [rsp+20h],1
  0000000140003B73: B9 00 01 00 00     mov         ecx,100h
  0000000140003B78: FF 15 EA 26 00 00  call        qword ptr [0000000140006268h]
  0000000140003B7E: EB 0B              jmp         0000000140003B8B
  0000000140003B80: B9 01 04 00 00     mov         ecx,401h
  0000000140003B85: FF 15 8D 24 00 00  call        qword ptr [0000000140006018h]
  0000000140003B8B: 48 8B D8           mov         rbx,rax
  0000000140003B8E: 48 85 C0           test        rax,rax
  0000000140003B91: 74 2E              je          0000000140003BC1
  0000000140003B93: 44 8B 44 24 30     mov         r8d,dword ptr [rsp+30h]
  0000000140003B98: 48 8D 44 24 30     lea         rax,[rsp+30h]
  0000000140003B9D: 4C 8B CB           mov         r9,rbx
  0000000140003BA0: 48 89 44 24 20     mov         qword ptr [rsp+20h],rax
  0000000140003BA5: 8B D6              mov         edx,esi
  0000000140003BA7: 48 8B CF           mov         rcx,rdi
  0000000140003BAA: FF 15 40 25 00 00  call        qword ptr [00000001400060F0h]
  0000000140003BB0: 85 C0              test        eax,eax
  0000000140003BB2: 74 0D              je          0000000140003BC1
  0000000140003BB4: 33 D2              xor         edx,edx
  0000000140003BB6: 48 8B CB           mov         rcx,rbx
  0000000140003BB9: FF 15 61 24 00 00  call        qword ptr [0000000140006020h]
  0000000140003BBF: 33 DB              xor         ebx,ebx
  0000000140003BC1: 48 8B C3           mov         rax,rbx
  0000000140003BC4: 48 8B 4C 24 48     mov         rcx,qword ptr [rsp+48h]
  0000000140003BC9: 48 33 CC           xor         rcx,rsp
  0000000140003BCC: E8 2F 12 00 00     call        0000000140004E00
  0000000140003BD1: 48 8B 5C 24 70     mov         rbx,qword ptr [rsp+70h]
  0000000140003BD6: 48 8B 74 24 78     mov         rsi,qword ptr [rsp+78h]
  0000000140003BDB: 48 83 C4 50        add         rsp,50h
  0000000140003BDF: 5F                 pop         rdi
  0000000140003BE0: C3                 ret
  0000000140003BE1: CC                 int         3
  0000000140003BE2: CC                 int         3
  0000000140003BE3: CC                 int         3
  0000000140003BE4: 48 89 5C 24 10     mov         qword ptr [rsp+10h],rbx
  0000000140003BE9: 57                 push        rdi
  0000000140003BEA: 48 83 EC 20        sub         rsp,20h
  0000000140003BEE: 33 DB              xor         ebx,ebx
  0000000140003BF0: 48 8B F9           mov         rdi,rcx
  0000000140003BF3: 89 5C 24 30        mov         dword ptr [rsp+30h],ebx
  0000000140003BF7: 48 85 C9           test        rcx,rcx
  0000000140003BFA: 74 57              je          0000000140003C53
  0000000140003BFC: 48 8D 54 24 30     lea         rdx,[rsp+30h]
