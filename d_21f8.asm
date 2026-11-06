  0000000140002183: 48 83 C4 30        add         rsp,30h
  0000000140002187: 41 5F              pop         r15
  0000000140002189: 41 5E              pop         r14
  000000014000218B: 41 5D              pop         r13
  000000014000218D: 41 5C              pop         r12
  000000014000218F: 5F                 pop         rdi
  0000000140002190: C3                 ret
  0000000140002191: CC                 int         3
  0000000140002192: CC                 int         3
  0000000140002193: CC                 int         3
  0000000140002194: 48 85 C9           test        rcx,rcx
  0000000140002197: 74 5B              je          00000001400021F4
  0000000140002199: 48 89 5C 24 08     mov         qword ptr [rsp+8],rbx
  000000014000219E: 48 89 74 24 10     mov         qword ptr [rsp+10h],rsi
  00000001400021A3: 57                 push        rdi
  00000001400021A4: 48 83 EC 30        sub         rsp,30h
  00000001400021A8: 49 8B D9           mov         rbx,r9
  00000001400021AB: 49 8B F8           mov         rdi,r8
  00000001400021AE: 8B F2              mov         esi,edx
  00000001400021B0: E8 4B 02 00 00     call        0000000140002400
  00000001400021B5: 48 85 C0           test        rax,rax
  00000001400021B8: 74 2B              je          00000001400021E5
  00000001400021BA: 48 8B 48 08        mov         rcx,qword ptr [rax+8]
  00000001400021BE: 48 85 C9           test        rcx,rcx
  00000001400021C1: 74 22              je          00000001400021E5
  00000001400021C3: 4C 8B 51 18        mov         r10,qword ptr [rcx+18h]
  00000001400021C7: 4D 85 D2           test        r10,r10
  00000001400021CA: 74 19              je          00000001400021E5
  00000001400021CC: 48 8B C8           mov         rcx,rax
  00000001400021CF: C6 44 24 20 00     mov         byte ptr [rsp+20h],0
  00000001400021D4: 49 8B C2           mov         rax,r10
  00000001400021D7: 4C 8B CB           mov         r9,rbx
  00000001400021DA: 4C 8B C7           mov         r8,rdi
  00000001400021DD: 8B D6              mov         edx,esi
  00000001400021DF: FF 15 83 40 00 00  call        qword ptr [0000000140006268h]
  00000001400021E5: 48 8B 5C 24 40     mov         rbx,qword ptr [rsp+40h]
  00000001400021EA: 48 8B 74 24 48     mov         rsi,qword ptr [rsp+48h]
  00000001400021EF: 48 83 C4 30        add         rsp,30h
  00000001400021F3: 5F                 pop         rdi
  00000001400021F4: C3                 ret
  00000001400021F5: CC                 int         3
  00000001400021F6: CC                 int         3
  00000001400021F7: CC                 int         3
  00000001400021F8: 48 89 5C 24 08     mov         qword ptr [rsp+8],rbx
  00000001400021FD: 48 89 6C 24 10     mov         qword ptr [rsp+10h],rbp
