  0000000140004303: 48 8B D3           mov         rdx,rbx
  0000000140004306: 48 89 5D B0        mov         qword ptr [rbp-50h],rbx
  000000014000430A: 48 8D 4D D0        lea         rcx,[rbp-30h]
  000000014000430E: FF 15 9C 1D 00 00  call        qword ptr [00000001400060B0h]
  0000000140004314: 0F B7 55 D0        movzx       edx,word ptr [rbp-30h]
  0000000140004318: 66 85 D2           test        dx,dx
  000000014000431B: 0F 85 3F FF FF FF  jne         0000000140004260
  0000000140004321: 48 8B 4D C0        mov         rcx,qword ptr [rbp-40h]
  0000000140004325: 33 D2              xor         edx,edx
  0000000140004327: FF 15 F3 1C 00 00  call        qword ptr [0000000140006020h]
  000000014000432D: 48 8B 4D F0        mov         rcx,qword ptr [rbp-10h]
  0000000140004331: 48 33 CC           xor         rcx,rsp
  0000000140004334: E8 C7 0A 00 00     call        0000000140004E00
  0000000140004339: 4C 8D 5C 24 70     lea         r11,[rsp+70h]
  000000014000433E: 49 8B 5B 28        mov         rbx,qword ptr [r11+28h]
  0000000140004342: 49 8B 73 30        mov         rsi,qword ptr [r11+30h]
  0000000140004346: 49 8B E3           mov         rsp,r11
  0000000140004349: 41 5E              pop         r14
  000000014000434B: 5F                 pop         rdi
  000000014000434C: 5D                 pop         rbp
  000000014000434D: C3                 ret
  000000014000434E: CC                 int         3
  000000014000434F: CC                 int         3
  0000000140004350: 48 89 5C 24 08     mov         qword ptr [rsp+8],rbx
  0000000140004355: 48 89 6C 24 10     mov         qword ptr [rsp+10h],rbp
  000000014000435A: 48 89 74 24 18     mov         qword ptr [rsp+18h],rsi
  000000014000435F: 57                 push        rdi
  0000000140004360: 41 56              push        r14
  0000000140004362: 41 57              push        r15
  0000000140004364: 48 83 EC 20        sub         rsp,20h
  0000000140004368: 33 FF              xor         edi,edi
  000000014000436A: 41 8B E8           mov         ebp,r8d
  000000014000436D: 48 83 CB FF        or          rbx,0FFFFFFFFFFFFFFFFh
  0000000140004371: 4C 8B FA           mov         r15,rdx
  0000000140004374: 48 8B F1           mov         rsi,rcx
  0000000140004377: 48 FF C3           inc         rbx
  000000014000437A: 66 39 3C 5A        cmp         word ptr [rdx+rbx*2],di
  000000014000437E: 75 F7              jne         0000000140004377
  0000000140004380: 41 3B D8           cmp         ebx,r8d
  0000000140004383: 77 27              ja          00000001400043AC
  0000000140004385: 0F AE E8           lfence
  0000000140004388: 44 8B F3           mov         r14d,ebx
  000000014000438B: 4D 8B C6           mov         r8,r14
  000000014000438E: 49 8B D7           mov         rdx,r15
  0000000140004391: 48 8B CE           mov         rcx,rsi
  0000000140004394: E8 0D 09 00 00     call        0000000140004CA6
  0000000140004399: 85 C0              test        eax,eax
  000000014000439B: 74 0C              je          00000001400043A9
  000000014000439D: 48 83 C6 02        add         rsi,2
  00000001400043A1: FF CD              dec         ebp
  00000001400043A3: 3B DD              cmp         ebx,ebp
  00000001400043A5: 76 E4              jbe         000000014000438B
  00000001400043A7: EB 03              jmp         00000001400043AC
  00000001400043A9: 48 8B FE           mov         rdi,rsi
  00000001400043AC: 48 8B 5C 24 40     mov         rbx,qword ptr [rsp+40h]
  00000001400043B1: 48 8B C7           mov         rax,rdi
  00000001400043B4: 48 8B 6C 24 48     mov         rbp,qword ptr [rsp+48h]
  00000001400043B9: 48 8B 74 24 50     mov         rsi,qword ptr [rsp+50h]
  00000001400043BE: 48 83 C4 20        add         rsp,20h
  00000001400043C2: 41 5F              pop         r15
  00000001400043C4: 41 5E              pop         r14
  00000001400043C6: 5F                 pop         rdi
  00000001400043C7: C3                 ret
  00000001400043C8: 8B 01              mov         eax,dword ptr [rcx]
  00000001400043CA: 45 33 C0           xor         r8d,r8d
  00000001400043CD: 4C 8B DA           mov         r11,rdx
  00000001400043D0: 85 C0              test        eax,eax
  00000001400043D2: 74 3A              je          000000014000440E
  00000001400043D4: 48 83 C1 14        add         rcx,14h
  00000001400043D8: 44 8B C8           mov         r9d,eax
  00000001400043DB: 44 8B 51 FC        mov         r10d,dword ptr [rcx-4]
  00000001400043DF: 33 D2              xor         edx,edx
  00000001400043E1: 45 85 D2           test        r10d,r10d
  00000001400043E4: 74 1E              je          0000000140004404
  00000001400043E6: 48 8B C1           mov         rax,rcx
  00000001400043E9: 80 38 03           cmp         byte ptr [rax],3
  00000001400043EC: 75 06              jne         00000001400043F4
  00000001400043EE: 4C 39 58 04        cmp         qword ptr [rax+4],r11
  00000001400043F2: 74 0D              je          0000000140004401
  00000001400043F4: FF C2              inc         edx
  00000001400043F6: 48 83 C0 14        add         rax,14h
  00000001400043FA: 41 3B D2           cmp         edx,r10d
  00000001400043FD: 73 05              jae         0000000140004404
  00000001400043FF: EB E8              jmp         00000001400043E9
