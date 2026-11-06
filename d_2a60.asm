  0000000140002A60: 48 89 5C 24 10     mov         qword ptr [rsp+10h],rbx
  0000000140002A65: 48 89 74 24 18     mov         qword ptr [rsp+18h],rsi
  0000000140002A6A: 55                 push        rbp
  0000000140002A6B: 57                 push        rdi
  0000000140002A6C: 41 54              push        r12
  0000000140002A6E: 41 56              push        r14
  0000000140002A70: 41 57              push        r15
  0000000140002A72: 48 8B EC           mov         rbp,rsp
  0000000140002A75: 48 83 EC 40        sub         rsp,40h
  0000000140002A79: 48 8B 05 90 57 00  mov         rax,qword ptr [0000000140008210h]
  0000000140002A80: 48 33 C4           xor         rax,rsp
  0000000140002A83: 48 89 45 F0        mov         qword ptr [rbp-10h],rax
  0000000140002A87: 45 33 F6           xor         r14d,r14d
  0000000140002A8A: 45 33 E4           xor         r12d,r12d
  0000000140002A8D: 44 21 75 E0        and         dword ptr [rbp-20h],r14d
  0000000140002A91: 48 8B F1           mov         rsi,rcx
  0000000140002A94: 44 21 75 E4        and         dword ptr [rbp-1Ch],r14d
  0000000140002A98: 44 21 75 E8        and         dword ptr [rbp-18h],r14d
  0000000140002A9C: 41 8D 5E 01        lea         ebx,[r14+1]
  0000000140002AA0: 48 85 C9           test        rcx,rcx
  0000000140002AA3: 0F 84 65 01 00 00  je          0000000140002C0E
  0000000140002AA9: 48 8D 55 E0        lea         rdx,[rbp-20h]
  0000000140002AAD: E8 C6 05 00 00     call        0000000140003078
  0000000140002AB2: 8B D8              mov         ebx,eax
  0000000140002AB4: 85 C0              test        eax,eax
  0000000140002AB6: 0F 85 52 01 00 00  jne         0000000140002C0E
  0000000140002ABC: F6 45 E0 04        test        byte ptr [rbp-20h],4
  0000000140002AC0: 0F 85 48 01 00 00  jne         0000000140002C0E
  0000000140002AC6: 33 D2              xor         edx,edx
  0000000140002AC8: 48 8B CE           mov         rcx,rsi
  0000000140002ACB: E8 5C 06 00 00     call        000000014000312C
  0000000140002AD0: 48 85 C0           test        rax,rax
  0000000140002AD3: 74 1A              je          0000000140002AEF
  0000000140002AD5: 48 8B C8           mov         rcx,rax
  0000000140002AD8: E8 93 0D 00 00     call        0000000140003870
  0000000140002ADD: 4C 8B F0           mov         r14,rax
  0000000140002AE0: 48 85 C0           test        rax,rax
  0000000140002AE3: 75 0A              jne         0000000140002AEF
  0000000140002AE5: BB 09 40 6A C8     mov         ebx,0C86A4009h
  0000000140002AEA: E9 1F 01 00 00     jmp         0000000140002C0E
  0000000140002AEF: BF 04 00 00 00     mov         edi,4
  0000000140002AF4: 4C 8D 45 E4        lea         r8,[rbp-1Ch]
  0000000140002AF8: 8B D7              mov         edx,edi
  0000000140002AFA: 48 8B CE           mov         rcx,rsi
  0000000140002AFD: E8 3E 15 00 00     call        0000000140004040
