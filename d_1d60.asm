  0000000140001D60: 48 8B C4           mov         rax,rsp
  0000000140001D63: 48 89 58 08        mov         qword ptr [rax+8],rbx
  0000000140001D67: 48 89 68 10        mov         qword ptr [rax+10h],rbp
  0000000140001D6B: 48 89 70 20        mov         qword ptr [rax+20h],rsi
  0000000140001D6F: 4C 89 40 18        mov         qword ptr [rax+18h],r8
  0000000140001D73: 57                 push        rdi
  0000000140001D74: 41 54              push        r12
  0000000140001D76: 41 55              push        r13
  0000000140001D78: 41 56              push        r14
  0000000140001D7A: 41 57              push        r15
  0000000140001D7C: 48 83 EC 30        sub         rsp,30h
  0000000140001D80: 8B F2              mov         esi,edx
  0000000140001D82: 33 DB              xor         ebx,ebx
  0000000140001D84: 8B C6              mov         eax,esi
  0000000140001D86: 4D 8B E1           mov         r12,r9
  0000000140001D89: F7 D0              not         eax
  0000000140001D8B: 44 8B F1           mov         r14d,ecx
  0000000140001D8E: BA FF FF FF FF     mov         edx,0FFFFFFFFh
  0000000140001D93: 3B C8              cmp         ecx,eax
  0000000140001D95: 0F 87 CB 01 00 00  ja          0000000140001F66
  0000000140001D9B: 8D 2C 31           lea         ebp,[rcx+rsi]
  0000000140001D9E: 8D 45 FF           lea         eax,[rbp-1]
  0000000140001DA1: 3D FF FF 01 00     cmp         eax,1FFFFh
  0000000140001DA6: 0F 87 BA 01 00 00  ja          0000000140001F66
  0000000140001DAC: 8B FB              mov         edi,ebx
  0000000140001DAE: 4C 8D 05 4B 0D F0  lea         r8,[0000000140F02B00h]
  0000000140001DB5: 44 8D 4B 01        lea         r9d,[rbx+1]
  0000000140001DB9: 41 BA 50 C3 00 00  mov         r10d,0C350h
  0000000140001DBF: 8B C7              mov         eax,edi
  0000000140001DC1: 48 8D 0C 80        lea         rcx,[rax+rax*4]
  0000000140001DC5: 48 03 C9           add         rcx,rcx
  0000000140001DC8: 33 C0              xor         eax,eax
  0000000140001DCA: F0 45 0F B1 0C C8  lock cmpxchg dword ptr [r8+rcx*8],r9d
  0000000140001DD0: 74 13              je          0000000140001DE5
  0000000140001DD2: 41 03 F9           add         edi,r9d
  0000000140001DD5: 8B C7              mov         eax,edi
  0000000140001DD7: 41 3B FA           cmp         edi,r10d
  0000000140001DDA: 72 E3              jb          0000000140001DBF
  0000000140001DDC: 41 3B C2           cmp         eax,r10d
  0000000140001DDF: 0F 84 81 01 00 00  je          0000000140001F66
  0000000140001DE5: 0F AE E8           lfence
  0000000140001DE8: 8B CD              mov         ecx,ebp
  0000000140001DEA: 44 8B ED           mov         r13d,ebp
  0000000140001DED: FF 15 5D 42 00 00  call        qword ptr [0000000140006050h]
  0000000140001DF3: 4C 8B F8           mov         r15,rax
  0000000140001DF6: 8B C7              mov         eax,edi
  0000000140001DF8: 48 8D 3C 80        lea         rdi,[rax+rax*4]
  0000000140001DFC: 48 03 FF           add         rdi,rdi
  0000000140001DFF: 4D 85 FF           test        r15,r15
