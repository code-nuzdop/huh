  0000000140002A02: 48 85 C9           test        rcx,rcx
  0000000140002A05: 74 10              je          0000000140002A17
  0000000140002A07: 33 D2              xor         edx,edx
  0000000140002A09: FF 15 11 36 00 00  call        qword ptr [0000000140006020h]
  0000000140002A0F: 48 83 25 39 58 00  and         qword ptr [0000000140008250h],0
  0000000140002A17: 48 8B 0D 3A 58 00  mov         rcx,qword ptr [0000000140008258h]
  0000000140002A1E: 48 85 C9           test        rcx,rcx
  0000000140002A21: 74 10              je          0000000140002A33
  0000000140002A23: 33 D2              xor         edx,edx
  0000000140002A25: FF 15 F5 35 00 00  call        qword ptr [0000000140006020h]
  0000000140002A2B: 48 83 25 25 58 00  and         qword ptr [0000000140008258h],0
  0000000140002A33: 48 83 C4 28        add         rsp,28h
  0000000140002A37: C3                 ret
  0000000140002A38: 48 83 EC 28        sub         rsp,28h
  0000000140002A3C: 48 8B 0D FD 57 00  mov         rcx,qword ptr [0000000140008240h]
  0000000140002A43: 48 85 C9           test        rcx,rcx
  0000000140002A46: 74 10              je          0000000140002A58
  0000000140002A48: 33 D2              xor         edx,edx
  0000000140002A4A: FF 15 D0 35 00 00  call        qword ptr [0000000140006020h]
  0000000140002A50: 48 83 25 E8 57 00  and         qword ptr [0000000140008240h],0
  0000000140002A58: 48 83 C4 28        add         rsp,28h
  0000000140002A5C: C3                 ret
  0000000140002A5D: CC                 int         3
  0000000140002A5E: CC                 int         3
  0000000140002A5F: CC                 int         3
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
  0000000140002B02: 8B D8              mov         ebx,eax
  0000000140002B04: 85 C0              test        eax,eax
  0000000140002B06: 0F 85 F2 00 00 00  jne         0000000140002BFE
  0000000140002B0C: 8B 45 E4           mov         eax,dword ptr [rbp-1Ch]
  0000000140002B0F: 85 C0              test        eax,eax
  0000000140002B11: 0F 84 CA 00 00 00  je          0000000140002BE1
  0000000140002B17: A8 01              test        al,1
  0000000140002B19: 0F 85 C2 00 00 00  jne         0000000140002BE1
  0000000140002B1F: 4D 85 F6           test        r14,r14
  0000000140002B22: 75 5C              jne         0000000140002B80
  0000000140002B24: 41 83 C8 FF        or          r8d,0FFFFFFFFh
  0000000140002B28: 8B D7              mov         edx,edi
  0000000140002B2A: 48 8B CE           mov         rcx,rsi
  0000000140002B2D: E8 DA 19 00 00     call        000000014000450C
  0000000140002B32: 8B D8              mov         ebx,eax
  0000000140002B34: 85 C0              test        eax,eax
  0000000140002B36: 0F 85 D2 00 00 00  jne         0000000140002C0E
  0000000140002B3C: 4C 8D 45 E8        lea         r8,[rbp-18h]
  0000000140002B40: 8B D7              mov         edx,edi
  0000000140002B42: 48 8B CE           mov         rcx,rsi
  0000000140002B45: E8 F6 14 00 00     call        0000000140004040
  0000000140002B4A: 8B D8              mov         ebx,eax
  0000000140002B4C: 85 C0              test        eax,eax
  0000000140002B4E: 0F 85 BA 00 00 00  jne         0000000140002C0E
  0000000140002B54: 44 8B 45 E4        mov         r8d,dword ptr [rbp-1Ch]
  0000000140002B58: 8B D7              mov         edx,edi
  0000000140002B5A: 48 8B CE           mov         rcx,rsi
  0000000140002B5D: E8 AA 19 00 00     call        000000014000450C
  0000000140002B62: 8B D8              mov         ebx,eax
  0000000140002B64: 85 C0              test        eax,eax
  0000000140002B66: 0F 85 A2 00 00 00  jne         0000000140002C0E
  0000000140002B6C: 8B 45 E8           mov         eax,dword ptr [rbp-18h]
  0000000140002B6F: 45 8D 66 10        lea         r12d,[r14+10h]
  0000000140002B73: 44 85 E0           test        eax,r12d
  0000000140002B76: 75 05              jne         0000000140002B7D
  0000000140002B78: 45 03 E4           add         r12d,r12d
  0000000140002B7B: 75 F6              jne         0000000140002B73
  0000000140002B7D: 8B 45 E4           mov         eax,dword ptr [rbp-1Ch]
  0000000140002B80: 44 8B F8           mov         r15d,eax
  0000000140002B83: B9 F0 FF FF FF     mov         ecx,0FFFFFFF0h
  0000000140002B88: 4C 23 F9           and         r15,rcx
  0000000140002B8B: 24 06              and         al,6
  0000000140002B8D: 3C 04              cmp         al,4
  0000000140002B8F: 75 2C              jne         0000000140002BBD
  0000000140002B91: FF C7              inc         edi
  0000000140002B93: 83 FF 0A           cmp         edi,0Ah
  0000000140002B96: 0F 83 99 00 00 00  jae         0000000140002C35
  0000000140002B9C: 0F AE E8           lfence
  0000000140002B9F: 4C 8D 45 E4        lea         r8,[rbp-1Ch]
  0000000140002BA3: 8B D7              mov         edx,edi
  0000000140002BA5: 48 8B CE           mov         rcx,rsi
  0000000140002BA8: E8 93 14 00 00     call        0000000140004040
  0000000140002BAD: 8B D8              mov         ebx,eax
  0000000140002BAF: 85 C0              test        eax,eax
  0000000140002BB1: 75 4B              jne         0000000140002BFE
  0000000140002BB3: 8B 45 E4           mov         eax,dword ptr [rbp-1Ch]
  0000000140002BB6: 48 C1 E0 20        shl         rax,20h
  0000000140002BBA: 4C 0B F8           or          r15,rax
  0000000140002BBD: 4D 85 F6           test        r14,r14
  0000000140002BC0: 74 14              je          0000000140002BD6
  0000000140002BC2: 49 8B D7           mov         rdx,r15
  0000000140002BC5: 49 8B CE           mov         rcx,r14
  0000000140002BC8: E8 FB 17 00 00     call        00000001400043C8
  0000000140002BCD: 48 85 C0           test        rax,rax
  0000000140002BD0: 74 6A              je          0000000140002C3C
  0000000140002BD2: 44 8B 60 0C        mov         r12d,dword ptr [rax+0Ch]
  0000000140002BD6: 41 8B D4           mov         edx,r12d
  0000000140002BD9: 49 8B CF           mov         rcx,r15
  0000000140002BDC: E8 E7 1C 00 00     call        00000001400048C8
  0000000140002BE1: FF C7              inc         edi
  0000000140002BE3: 83 FF 0A           cmp         edi,0Ah
  0000000140002BE6: 0F 82 08 FF FF FF  jb          0000000140002AF4
  0000000140002BEC: B8 04 00 00 00     mov         eax,4
  0000000140002BF1: 48 8B CE           mov         rcx,rsi
  0000000140002BF4: 44 8B C0           mov         r8d,eax
  0000000140002BF7: 8B D0              mov         edx,eax
  0000000140002BF9: E8 16 18 00 00     call        0000000140004414
  0000000140002BFE: 4D 85 F6           test        r14,r14
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
