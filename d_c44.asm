  0000000140002C01: 74 0B              je          0000000140002C0E
  0000000140002C03: 33 D2              xor         edx,edx
  0000000140002C05: 49 8B CE           mov         rcx,r14
  0000000140002C08: FF 15 12 34 00 00  call        qword ptr [0000000140006020h]
  0000000140002C0E: 8B C3              mov         eax,ebx
  0000000140002C10: 48 8B 4D F0        mov         rcx,qword ptr [rbp-10h]
  0000000140002C14: 48 33 CC           xor         rcx,rsp
  0000000140002C17: E8 E4 21 00 00     call        0000000140004E00
  0000000140002C1C: 4C 8D 5C 24 40     lea         r11,[rsp+40h]
  0000000140002C21: 49 8B 5B 38        mov         rbx,qword ptr [r11+38h]
  0000000140002C25: 49 8B 73 40        mov         rsi,qword ptr [r11+40h]
  0000000140002C29: 49 8B E3           mov         rsp,r11
  0000000140002C2C: 41 5F              pop         r15
  0000000140002C2E: 41 5E              pop         r14
  0000000140002C30: 41 5C              pop         r12
  0000000140002C32: 5F                 pop         rdi
  0000000140002C33: 5D                 pop         rbp
  0000000140002C34: C3                 ret
  0000000140002C35: BB 09 40 6A C8     mov         ebx,0C86A4009h
  0000000140002C3A: EB C2              jmp         0000000140002BFE
  0000000140002C3C: BB 09 40 6A C8     mov         ebx,0C86A4009h
  0000000140002C41: EB C0              jmp         0000000140002C03
  0000000140002C43: CC                 int         3
  0000000140002C44: 40 53              push        rbx
  0000000140002C46: 48 83 EC 20        sub         rsp,20h
  0000000140002C4A: 48 8B D9           mov         rbx,rcx
  0000000140002C4D: E8 92 0F 00 00     call        0000000140003BE4
  0000000140002C52: 84 C0              test        al,al
  0000000140002C54: 75 07              jne         0000000140002C5D
  0000000140002C56: B8 29 80 6A C8     mov         eax,0C86A8029h
  0000000140002C5B: EB 25              jmp         0000000140002C82
  0000000140002C5D: 48 8B CB           mov         rcx,rbx
  0000000140002C60: E8 FB FD FF FF     call        0000000140002A60
  0000000140002C65: 85 C0              test        eax,eax
  0000000140002C67: 74 07              je          0000000140002C70
  0000000140002C69: B8 0E 80 6A C8     mov         eax,0C86A800Eh
  0000000140002C6E: EB 12              jmp         0000000140002C82
  0000000140002C70: 48 8B CB           mov         rcx,rbx
  0000000140002C73: E8 2C 18 00 00     call        00000001400044A4
  0000000140002C78: 85 C0              test        eax,eax
  0000000140002C7A: B9 09 40 6A C8     mov         ecx,0C86A4009h
  0000000140002C7F: 0F 45 C1           cmovne      eax,ecx
  0000000140002C82: 48 83 C4 20        add         rsp,20h
  0000000140002C86: 5B                 pop         rbx
  0000000140002C87: C3                 ret
  0000000140002C88: 48 8B C4           mov         rax,rsp
  0000000140002C8B: 48 89 58 10        mov         qword ptr [rax+10h],rbx
  0000000140002C8F: 48 89 70 18        mov         qword ptr [rax+18h],rsi
  0000000140002C93: 48 89 78 20        mov         qword ptr [rax+20h],rdi
  0000000140002C97: 55                 push        rbp
  0000000140002C98: 41 54              push        r12
  0000000140002C9A: 41 55              push        r13
  0000000140002C9C: 41 56              push        r14
  0000000140002C9E: 41 57              push        r15
  0000000140002CA0: 48 8D A8 18 FF FF  lea         rbp,[rax+FFFFFFFFFFFFFF18h]
  0000000140002CA7: 48 81 EC C0 01 00  sub         rsp,1C0h
  0000000140002CAE: 48 8B 05 5B 55 00  mov         rax,qword ptr [0000000140008210h]
  0000000140002CB5: 48 33 C4           xor         rax,rsp
  0000000140002CB8: 48 89 85 B0 00 00  mov         qword ptr [rbp+00000000000000B0h],rax
  0000000140002CBF: 45 33 E4           xor         r12d,r12d
  0000000140002CC2: 48 8D 55 B0        lea         rdx,[rbp-50h]
  0000000140002CC6: 44 21 64 24 30     and         dword ptr [rsp+30h],r12d
  0000000140002CCB: 4C 8B E9           mov         r13,rcx
  0000000140002CCE: 48 8B 49 38        mov         rcx,qword ptr [rcx+38h]
  0000000140002CD2: 0F 57 C0           xorps       xmm0,xmm0
  0000000140002CD5: 44 21 65 C0        and         dword ptr [rbp-40h],r12d
  0000000140002CD9: 45 33 C9           xor         r9d,r9d
  0000000140002CDC: 41 8D 7C 24 40     lea         edi,[r12+40h]
  0000000140002CE1: 41 B0 0F           mov         r8b,0Fh
  0000000140002CE4: 89 7C 24 20        mov         dword ptr [rsp+20h],edi
  0000000140002CE8: 32 DB              xor         bl,bl
  0000000140002CEA: 0F 11 45 80        movups      xmmword ptr [rbp-80h],xmm0
  0000000140002CEE: E8 55 10 00 00     call        0000000140003D48
  0000000140002CF3: 48 8D 15 E6 29 00  lea         rdx,[00000001400056E0h]
  0000000140002CFA: 48 8D 4D 90        lea         rcx,[rbp-70h]
  0000000140002CFE: FF 15 AC 33 00 00  call        qword ptr [00000001400060B0h]
  0000000140002D04: 4C 21 64 24 58     and         qword ptr [rsp+58h],r12
  0000000140002D09: 48 8D 45 90        lea         rax,[rbp-70h]
  0000000140002D0D: 0F 57 C0           xorps       xmm0,xmm0
  0000000140002D10: 48 89 44 24 60     mov         qword ptr [rsp+60h],rax
  0000000140002D15: 4C 8D 44 24 50     lea         r8,[rsp+50h]
  0000000140002D1A: C7 44 24 50 30 00  mov         dword ptr [rsp+50h],30h
  0000000140002D22: BA 19 00 02 00     mov         edx,20019h
  0000000140002D27: 89 7C 24 68        mov         dword ptr [rsp+68h],edi
  0000000140002D2B: 48 8D 4C 24 38     lea         rcx,[rsp+38h]
  0000000140002D30: F3 0F 7F 44 24 70  movdqu      xmmword ptr [rsp+70h],xmm0
  0000000140002D36: FF 15 D4 33 00 00  call        qword ptr [0000000140006110h]
  0000000140002D3C: 44 8B F8           mov         r15d,eax
  0000000140002D3F: 85 C0              test        eax,eax
  0000000140002D41: 0F 88 E8 01 00 00  js          0000000140002F2F
  0000000140002D47: 48 8B 4C 24 38     mov         rcx,qword ptr [rsp+38h]
  0000000140002D4C: 48 8D 44 24 30     lea         rax,[rsp+30h]
  0000000140002D51: 45 33 C9           xor         r9d,r9d
  0000000140002D54: 48 89 44 24 28     mov         qword ptr [rsp+28h],rax
  0000000140002D59: 83 64 24 20 00     and         dword ptr [rsp+20h],0
  0000000140002D5E: 40 8A FB           mov         dil,bl
  0000000140002D61: 41 8B D4           mov         edx,r12d
  0000000140002D64: 45 32 F6           xor         r14b,r14b
  0000000140002D67: 41 8D 59 01        lea         ebx,[r9+1]
  0000000140002D6B: 44 8B C3           mov         r8d,ebx
  0000000140002D6E: FF 15 A4 33 00 00  call        qword ptr [0000000140006118h]
  0000000140002D74: 48 8B 45 80        mov         rax,qword ptr [rbp-80h]
  0000000140002D78: 41 B8 39 30 76 71  mov         r8d,71763039h
  0000000140002D7E: 8B 54 24 30        mov         edx,dword ptr [rsp+30h]
  0000000140002D82: 48 25 01 FF FF FF  and         rax,0FFFFFFFFFFFFFF01h
  0000000140002D88: 48 0B C3           or          rax,rbx
  0000000140002D8B: C7 45 88 10 00 00  mov         dword ptr [rbp-78h],10h
  0000000140002D92: 48 89 45 80        mov         qword ptr [rbp-80h],rax
  0000000140002D96: 48 83 C2 08        add         rdx,8
  0000000140002D9A: 48 8B 05 BF 54 00  mov         rax,qword ptr [0000000140008260h]
  0000000140002DA1: 48 85 C0           test        rax,rax
  0000000140002DA4: 74 15              je          0000000140002DBB
  0000000140002DA6: 4C 8D 4D 80        lea         r9,[rbp-80h]
  0000000140002DAA: 89 5C 24 20        mov         dword ptr [rsp+20h],ebx
  0000000140002DAE: B9 00 01 00 00     mov         ecx,100h
  0000000140002DB3: FF 15 AF 34 00 00  call        qword ptr [0000000140006268h]
  0000000140002DB9: EB 11              jmp         0000000140002DCC
  0000000140002DBB: B9 01 04 00 00     mov         ecx,401h
  0000000140002DC0: 41 B9 10 00 00 00  mov         r9d,10h
  0000000140002DC6: FF 15 4C 32 00 00  call        qword ptr [0000000140006018h]
  0000000140002DCC: 48 8B 4C 24 38     mov         rcx,qword ptr [rsp+38h]
  0000000140002DD1: 48 8B F0           mov         rsi,rax
  0000000140002DD4: 48 8D 44 24 30     lea         rax,[rsp+30h]
  0000000140002DD9: 4C 8B CE           mov         r9,rsi
  0000000140002DDC: 48 89 44 24 28     mov         qword ptr [rsp+28h],rax
  0000000140002DE1: 44 8B C3           mov         r8d,ebx
  0000000140002DE4: 8B 44 24 30        mov         eax,dword ptr [rsp+30h]
  0000000140002DE8: 41 8B D4           mov         edx,r12d
  0000000140002DEB: 89 44 24 20        mov         dword ptr [rsp+20h],eax
  0000000140002DEF: FF 15 23 33 00 00  call        qword ptr [0000000140006118h]
  0000000140002DF5: 44 8B F8           mov         r15d,eax
  0000000140002DF8: 85 C0              test        eax,eax
  0000000140002DFA: 0F 88 17 01 00 00  js          0000000140002F17
  0000000140002E00: 40 8A DF           mov         bl,dil
  0000000140002E03: 40 84 FF           test        dil,dil
  0000000140002E06: 0F 85 0B 01 00 00  jne         0000000140002F17
  0000000140002E0C: 83 7E 04 08        cmp         dword ptr [rsi+4],8
  0000000140002E10: 0F 85 01 01 00 00  jne         0000000140002F17
  0000000140002E16: 48 8D 56 14        lea         rdx,[rsi+14h]
  0000000140002E1A: 48 8D 4D A0        lea         rcx,[rbp-60h]
  0000000140002E1E: FF 15 8C 32 00 00  call        qword ptr [00000001400060B0h]
  0000000140002E24: 41 B8 01 00 00 00  mov         r8d,1
  0000000140002E2A: 48 8D 55 A0        lea         rdx,[rbp-60h]
  0000000140002E2E: 48 8D 4C 24 40     lea         rcx,[rsp+40h]
  0000000140002E33: FF 15 7F 32 00 00  call        qword ptr [00000001400060B8h]
  0000000140002E39: 48 8B 4C 24 48     mov         rcx,qword ptr [rsp+48h]
  0000000140002E3E: 48 8D 15 3B 29 00  lea         rdx,[0000000140005780h]
  0000000140002E45: E8 56 1E 00 00     call        0000000140004CA0
  0000000140002E4A: 48 85 C0           test        rax,rax
  0000000140002E4D: 0F 84 B6 00 00 00  je          0000000140002F09
  0000000140002E53: 48 8B 4C 24 48     mov         rcx,qword ptr [rsp+48h]
  0000000140002E58: 48 8D 15 31 29 00  lea         rdx,[0000000140005790h]
  0000000140002E5F: E8 3C 1E 00 00     call        0000000140004CA0
  0000000140002E64: 48 85 C0           test        rax,rax
  0000000140002E67: 0F 84 9C 00 00 00  je          0000000140002F09
  0000000140002E6D: 8B 4E 08           mov         ecx,dword ptr [rsi+8]
  0000000140002E70: 48 03 CE           add         rcx,rsi
  0000000140002E73: 83 79 04 05        cmp         dword ptr [rcx+4],5
  0000000140002E77: 0F 85 8C 00 00 00  jne         0000000140002F09
  0000000140002E7D: 8B 41 10           mov         eax,dword ptr [rcx+10h]
  0000000140002E80: 85 C0              test        eax,eax
  0000000140002E82: 0F 84 81 00 00 00  je          0000000140002F09
  0000000140002E88: 44 8B 4D C0        mov         r9d,dword ptr [rbp-40h]
  0000000140002E8C: 48 8D 51 14        lea         rdx,[rcx+14h]
  0000000140002E90: 44 8B C0           mov         r8d,eax
  0000000140002E93: B8 01 00 00 00     mov         eax,1
  0000000140002E98: 80 3A 03           cmp         byte ptr [rdx],3
  0000000140002E9B: 75 1D              jne         0000000140002EBA
  0000000140002E9D: 44 39 4A 04        cmp         dword ptr [rdx+4],r9d
  0000000140002EA1: 75 17              jne         0000000140002EBA
  0000000140002EA3: 41 0F B6 C6        movzx       eax,r14b
  0000000140002EA7: 45 84 F6           test        r14b,r14b
  0000000140002EAA: 41 BA 01 00 00 00  mov         r10d,1
  0000000140002EB0: 41 0F 44 C2        cmove       eax,r10d
  0000000140002EB4: 44 8A F0           mov         r14b,al
  0000000140002EB7: 41 8B C2           mov         eax,r10d
  0000000140002EBA: 48 83 C2 14        add         rdx,14h
  0000000140002EBE: 4C 2B C0           sub         r8,rax
  0000000140002EC1: 75 D5              jne         0000000140002E98
  0000000140002EC3: 45 8D 48 01        lea         r9d,[r8+1]
  0000000140002EC7: 45 3A F1           cmp         r14b,r9b
  0000000140002ECA: 75 3D              jne         0000000140002F09
  0000000140002ECC: 33 D2              xor         edx,edx
  0000000140002ECE: 8B C2              mov         eax,edx
  0000000140002ED0: 49 03 C1           add         rax,r9
  0000000140002ED3: 4C 8D 04 80        lea         r8,[rax+rax*4]
  0000000140002ED7: 42 80 3C 81 02     cmp         byte ptr [rcx+r8*4],2
  0000000140002EDC: 75 20              jne         0000000140002EFE
  0000000140002EDE: 42 8B 44 81 08     mov         eax,dword ptr [rcx+r8*4+8]
  0000000140002EE3: 41 89 45 0C        mov         dword ptr [r13+0Ch],eax
  0000000140002EE7: 42 8A 44 81 04     mov         al,byte ptr [rcx+r8*4+4]
  0000000140002EEC: 41 88 45 08        mov         byte ptr [r13+8],al
  0000000140002EF0: 4A 8B 44 81 0C     mov         rax,qword ptr [rcx+r8*4+0Ch]
  0000000140002EF5: 41 83 65 18 00     and         dword ptr [r13+18h],0
  0000000140002EFA: 49 89 45 10        mov         qword ptr [r13+10h],rax
  0000000140002EFE: 41 03 D1           add         edx,r9d
