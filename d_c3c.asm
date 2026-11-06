  0000000140003C01: E8 72 F4 FF FF     call        0000000140003078
  0000000140003C06: 85 C0              test        eax,eax
  0000000140003C08: 75 49              jne         0000000140003C53
  0000000140003C0A: 8B 44 24 30        mov         eax,dword ptr [rsp+30h]
  0000000140003C0E: A8 02              test        al,2
  0000000140003C10: 74 06              je          0000000140003C18
  0000000140003C12: 24 01              and         al,1
  0000000140003C14: 8A D8              mov         bl,al
  0000000140003C16: EB 3B              jmp         0000000140003C53
  0000000140003C18: 33 D2              xor         edx,edx
  0000000140003C1A: 48 8B CF           mov         rcx,rdi
  0000000140003C1D: E8 0A F5 FF FF     call        000000014000312C
  0000000140003C22: 48 85 C0           test        rax,rax
  0000000140003C25: 74 0A              je          0000000140003C31
  0000000140003C27: 48 8B C8           mov         rcx,rax
  0000000140003C2A: E8 E9 E9 FF FF     call        0000000140002618
  0000000140003C2F: EB 08              jmp         0000000140003C39
  0000000140003C31: 48 8B CF           mov         rcx,rdi
  0000000140003C34: E8 8F EA FF FF     call        00000001400026C8
  0000000140003C39: 8A D8              mov         bl,al
  0000000140003C3B: BA 03 00 00 00     mov         edx,3
  0000000140003C40: 48 8B CF           mov         rcx,rdi
  0000000140003C43: 8D 43 FF           lea         eax,[rbx-1]
  0000000140003C46: F6 D8              neg         al
  0000000140003C48: 45 1B C0           sbb         r8d,r8d
  0000000140003C4B: 44 03 C2           add         r8d,edx
  0000000140003C4E: E8 C1 07 00 00     call        0000000140004414
  0000000140003C53: 8A C3              mov         al,bl
  0000000140003C55: 48 8B 5C 24 38     mov         rbx,qword ptr [rsp+38h]
  0000000140003C5A: 48 83 C4 20        add         rsp,20h
  0000000140003C5E: 5F                 pop         rdi
  0000000140003C5F: C3                 ret
  0000000140003C60: 48 89 5C 24 08     mov         qword ptr [rsp+8],rbx
  0000000140003C65: 48 89 74 24 10     mov         qword ptr [rsp+10h],rsi
  0000000140003C6A: 57                 push        rdi
  0000000140003C6B: 48 83 EC 20        sub         rsp,20h
  0000000140003C6F: 49 8B F8           mov         rdi,r8
  0000000140003C72: 8B F2              mov         esi,edx
  0000000140003C74: 48 8B D9           mov         rbx,rcx
  0000000140003C77: B8 01 00 00 00     mov         eax,1
  0000000140003C7C: 48 85 C9           test        rcx,rcx
  0000000140003C7F: 74 1D              je          0000000140003C9E
  0000000140003C81: E8 5E FF FF FF     call        0000000140003BE4
  0000000140003C86: 84 C0              test        al,al
  0000000140003C88: 75 07              jne         0000000140003C91
  0000000140003C8A: B8 29 80 6A C8     mov         eax,0C86A8029h
  0000000140003C8F: EB 0D              jmp         0000000140003C9E
  0000000140003C91: 4C 8B C7           mov         r8,rdi
  0000000140003C94: 8B D6              mov         edx,esi
  0000000140003C96: 48 8B CB           mov         rcx,rbx
  0000000140003C99: E8 A2 03 00 00     call        0000000140004040
  0000000140003C9E: 48 8B 5C 24 30     mov         rbx,qword ptr [rsp+30h]
  0000000140003CA3: 48 8B 74 24 38     mov         rsi,qword ptr [rsp+38h]
  0000000140003CA8: 48 83 C4 20        add         rsp,20h
  0000000140003CAC: 5F                 pop         rdi
  0000000140003CAD: C3                 ret
  0000000140003CAE: CC                 int         3
  0000000140003CAF: CC                 int         3
  0000000140003CB0: 48 89 5C 24 20     mov         qword ptr [rsp+20h],rbx
  0000000140003CB5: 55                 push        rbp
  0000000140003CB6: 56                 push        rsi
  0000000140003CB7: 57                 push        rdi
  0000000140003CB8: 48 83 EC 30        sub         rsp,30h
  0000000140003CBC: 48 8B 05 4D 45 00  mov         rax,qword ptr [0000000140008210h]
  0000000140003CC3: 48 33 C4           xor         rax,rsp
  0000000140003CC6: 48 89 44 24 28     mov         qword ptr [rsp+28h],rax
  0000000140003CCB: 83 64 24 20 00     and         dword ptr [rsp+20h],0
  0000000140003CD0: 41 8B E8           mov         ebp,r8d
  0000000140003CD3: 8B FA              mov         edi,edx
  0000000140003CD5: 48 8B D9           mov         rbx,rcx
  0000000140003CD8: E8 07 FF FF FF     call        0000000140003BE4
  0000000140003CDD: 84 C0              test        al,al
  0000000140003CDF: 75 07              jne         0000000140003CE8
  0000000140003CE1: B8 29 80 6A C8     mov         eax,0C86A8029h
  0000000140003CE6: EB 44              jmp         0000000140003D2C
  0000000140003CE8: 8B D7              mov         edx,edi
  0000000140003CEA: 48 8B CB           mov         rcx,rbx
  0000000140003CED: E8 3A F8 FF FF     call        000000014000352C
  0000000140003CF2: 8B F0              mov         esi,eax
  0000000140003CF4: 85 C0              test        eax,eax
  0000000140003CF6: 75 07              jne         0000000140003CFF
  0000000140003CF8: B8 09 40 6A C8     mov         eax,0C86A4009h
  0000000140003CFD: EB 2D              jmp         0000000140003D2C
  0000000140003CFF: 4C 8D 44 24 20     lea         r8,[rsp+20h]
  0000000140003D04: 8B D7              mov         edx,edi
  0000000140003D06: 48 8B CB           mov         rcx,rbx
  0000000140003D09: E8 32 03 00 00     call        0000000140004040
  0000000140003D0E: 85 C0              test        eax,eax
  0000000140003D10: 75 E6              jne         0000000140003CF8
  0000000140003D12: 44 8B C6           mov         r8d,esi
  0000000140003D15: 23 EE              and         ebp,esi
  0000000140003D17: 41 F7 D0           not         r8d
  0000000140003D1A: 8B D7              mov         edx,edi
  0000000140003D1C: 44 23 44 24 20     and         r8d,dword ptr [rsp+20h]
  0000000140003D21: 48 8B CB           mov         rcx,rbx
  0000000140003D24: 44 0B C5           or          r8d,ebp
  0000000140003D27: E8 E0 07 00 00     call        000000014000450C
  0000000140003D2C: 48 8B 4C 24 28     mov         rcx,qword ptr [rsp+28h]
  0000000140003D31: 48 33 CC           xor         rcx,rsp
  0000000140003D34: E8 C7 10 00 00     call        0000000140004E00
  0000000140003D39: 48 8B 5C 24 68     mov         rbx,qword ptr [rsp+68h]
  0000000140003D3E: 48 83 C4 30        add         rsp,30h
  0000000140003D42: 5F                 pop         rdi
  0000000140003D43: 5E                 pop         rsi
  0000000140003D44: 5D                 pop         rbp
  0000000140003D45: C3                 ret
  0000000140003D46: CC                 int         3
  0000000140003D47: CC                 int         3
  0000000140003D48: 48 89 5C 24 10     mov         qword ptr [rsp+10h],rbx
  0000000140003D4D: 48 89 6C 24 18     mov         qword ptr [rsp+18h],rbp
  0000000140003D52: 56                 push        rsi
  0000000140003D53: 57                 push        rdi
  0000000140003D54: 41 56              push        r14
  0000000140003D56: 48 83 EC 70        sub         rsp,70h
  0000000140003D5A: 48 8B 05 AF 44 00  mov         rax,qword ptr [0000000140008210h]
  0000000140003D61: 48 33 C4           xor         rax,rsp
  0000000140003D64: 48 89 44 24 68     mov         qword ptr [rsp+68h],rax
  0000000140003D69: 41 8A E8           mov         bpl,r8b
  0000000140003D6C: 4C 8B F2           mov         r14,rdx
  0000000140003D6F: 48 8B F9           mov         rdi,rcx
  0000000140003D72: 45 33 C0           xor         r8d,r8d
  0000000140003D75: 33 D2              xor         edx,edx
  0000000140003D77: 48 8D 4C 24 50     lea         rcx,[rsp+50h]
  0000000140003D7C: 41 8B F1           mov         esi,r9d
  0000000140003D7F: BB 10 00 00 C0     mov         ebx,0C0000010h
  0000000140003D84: FF 15 3E 23 00 00  call        qword ptr [00000001400060C8h]
  0000000140003D8A: 48 8D 44 24 40     lea         rax,[rsp+40h]
  0000000140003D8F: 45 33 C9           xor         r9d,r9d
  0000000140003D92: 48 89 44 24 30     mov         qword ptr [rsp+30h],rax
  0000000140003D97: 45 33 C0           xor         r8d,r8d
  0000000140003D9A: 48 8D 44 24 50     lea         rax,[rsp+50h]
  0000000140003D9F: 48 8B D7           mov         rdx,rdi
  0000000140003DA2: 48 89 44 24 28     mov         qword ptr [rsp+28h],rax
  0000000140003DA7: 48 83 64 24 20 00  and         qword ptr [rsp+20h],0
  0000000140003DAD: 41 8D 49 1B        lea         ecx,[r9+1Bh]
  0000000140003DB1: FF 15 21 23 00 00  call        qword ptr [00000001400060D8h]
  0000000140003DB7: 4C 8B C0           mov         r8,rax
  0000000140003DBA: 48 85 C0           test        rax,rax
  0000000140003DBD: 74 62              je          0000000140003E21
  0000000140003DBF: 48 8B 90 B8 00 00  mov         rdx,qword ptr [rax+00000000000000B8h]
  0000000140003DC6: 48 83 EA 48        sub         rdx,48h
  0000000140003DCA: 74 55              je          0000000140003E21
  0000000140003DCC: C7 40 30 BB 00 00  mov         dword ptr [rax+30h],0C00000BBh
  0000000140003DD3: 48 8B CF           mov         rcx,rdi
  0000000140003DD6: 8B 84 24 B0 00 00  mov         eax,dword ptr [rsp+00000000000000B0h]
  0000000140003DDD: 83 62 08 00        and         dword ptr [rdx+8],0
  0000000140003DE1: 89 42 20           mov         dword ptr [rdx+20h],eax
  0000000140003DE4: C6 02 1B           mov         byte ptr [rdx],1Bh
  0000000140003DE7: 40 88 6A 01        mov         byte ptr [rdx+1],bpl
  0000000140003DEB: 4C 89 72 10        mov         qword ptr [rdx+10h],r14
  0000000140003DEF: 89 72 18           mov         dword ptr [rdx+18h],esi
  0000000140003DF2: 49 8B D0           mov         rdx,r8
  0000000140003DF5: FF 15 E5 22 00 00  call        qword ptr [00000001400060E0h]
  0000000140003DFB: 8B D8              mov         ebx,eax
  0000000140003DFD: 3D 03 01 00 00     cmp         eax,103h
