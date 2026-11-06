  00000001412D7000: 48 89 5C 24 10     mov         qword ptr [rsp+10h],rbx
  00000001412D7005: 57                 push        rdi
  00000001412D7006: 48 81 EC 60 01 00  sub         rsp,160h
  00000001412D700D: 48 8B 05 FC 11 D3  mov         rax,qword ptr [0000000140008210h]
  00000001412D7014: 48 33 C4           xor         rax,rsp
  00000001412D7017: 48 89 84 24 50 01  mov         qword ptr [rsp+0000000000000150h],rax
  00000001412D701F: 48 8B D9           mov         rbx,rcx
  00000001412D7022: C7 44 24 30 14 01  mov         dword ptr [rsp+30h],114h
  00000001412D702A: 0F 57 C0           xorps       xmm0,xmm0
  00000001412D702D: 48 8D 4C 24 30     lea         rcx,[rsp+30h]
  00000001412D7032: 0F 11 44 24 20     movups      xmmword ptr [rsp+20h],xmm0
  00000001412D7037: FF 15 0B F2 D2 FE  call        qword ptr [0000000140006248h]
  00000001412D703D: 33 FF              xor         edi,edi
  00000001412D703F: 85 C0              test        eax,eax
  00000001412D7041: 78 24              js          00000001412D7067
  00000001412D7043: 83 7C 24 34 06     cmp         dword ptr [rsp+34h],6
  00000001412D7048: 77 09              ja          00000001412D7053
  00000001412D704A: 75 1B              jne         00000001412D7067
  00000001412D704C: 83 7C 24 38 02     cmp         dword ptr [rsp+38h],2
  00000001412D7051: 72 14              jb          00000001412D7067
  00000001412D7053: C7 05 C3 11 D3 FE  mov         dword ptr [0000000140008220h],200h
  00000001412D705D: C7 05 BD 11 D3 FE  mov         dword ptr [0000000140008224h],40000000h
  00000001412D7067: 4C 8D 05 B2 01 00  lea         r8,[00000001412D7220h]
  00000001412D706E: 48 8D 15 BB 01 00  lea         rdx,[00000001412D7230h]
  00000001412D7075: 48 8D 0D C4 01 00  lea         rcx,[00000001412D7240h]
  00000001412D707C: E8 F7 A4 D2 FE     call        0000000140001578
  00000001412D7081: 48 8D 05 18 72 D3  lea         rax,[000000014000E2A0h]
  00000001412D7088: 89 3D DA 11 D3 FE  mov         dword ptr [0000000140008268h],edi
  00000001412D708E: B9 00 01 00 00     mov         ecx,100h
  00000001412D7093: 40 88 B8 08 01 00  mov         byte ptr [rax+0000000000000108h],dil
  00000001412D709A: 48 89 38           mov         qword ptr [rax],rdi
  00000001412D709D: 48 8D 80 10 01 00  lea         rax,[rax+0000000000000110h]
  00000001412D70A4: 48 83 E9 01        sub         rcx,1
  00000001412D70A8: 75 E9              jne         00000001412D7093
  00000001412D70AA: 33 D2              xor         edx,edx
  00000001412D70AC: 48 8D 0D ED 11 D3  lea         rcx,[00000001400082A0h]
  00000001412D70B3: 41 B8 00 60 00 00  mov         r8d,6000h
  00000001412D70B9: E8 82 E0 D2 FE     call        0000000140005140
  00000001412D70BE: 89 3D A8 11 D3 FE  mov         dword ptr [000000014000826Ch],edi
  00000001412D70C4: E8 EB B7 D2 FE     call        00000001400028B4
  00000001412D70C9: E8 82 B6 D2 FE     call        0000000140002750
  00000001412D70CE: 48 8D 05 3B D6 D2  lea         rax,[0000000140004710h]
  00000001412D70D5: BA 50 C3 00 00     mov         edx,0C350h
  00000001412D70DA: 48 89 43 70        mov         qword ptr [rbx+70h],rax
  00000001412D70DE: 48 8D 05 DB D5 D2  lea         rax,[00000001400046C0h]
  00000001412D70E5: 48 89 83 80 00 00  mov         qword ptr [rbx+0000000000000080h],rax
  00000001412D70EC: 48 8D 05 6D D6 D2  lea         rax,[0000000140004760h]
  00000001412D70F3: 48 89 83 E0 00 00  mov         qword ptr [rbx+00000000000000E0h],rax
  00000001412D70FA: 48 8D 05 3F D7 D2  lea         rax,[0000000140004840h]
  00000001412D7101: 48 89 43 68        mov         qword ptr [rbx+68h],rax
  00000001412D7105: 48 8D 05 FC B9 C2  lea         rax,[0000000140F02B08h]
  00000001412D710C: 89 78 F8           mov         dword ptr [rax-8],edi
  00000001412D710F: 48 89 38           mov         qword ptr [rax],rdi
  00000001412D7112: 48 89 78 10        mov         qword ptr [rax+10h],rdi
  00000001412D7116: 48 89 78 08        mov         qword ptr [rax+8],rdi
  00000001412D711A: 48 89 78 20        mov         qword ptr [rax+20h],rdi
  00000001412D711E: 48 89 78 18        mov         qword ptr [rax+18h],rdi
  00000001412D7122: 48 89 78 28        mov         qword ptr [rax+28h],rdi
  00000001412D7126: 48 89 78 30        mov         qword ptr [rax+30h],rdi
  00000001412D712A: 48 89 78 38        mov         qword ptr [rax+38h],rdi
  00000001412D712E: 48 89 78 40        mov         qword ptr [rax+40h],rdi
  00000001412D7132: 48 8D 40 50        lea         rax,[rax+50h]
  00000001412D7136: 48 83 EA 01        sub         rdx,1
  00000001412D713A: 75 D0              jne         00000001412D710C
  00000001412D713C: 41 B8 80 09 EE 00  mov         r8d,0EE0980h
  00000001412D7142: 48 8D 0D 37 B0 D4  lea         rcx,[0000000140022180h]
  00000001412D7149: E8 F2 DF D2 FE     call        0000000140005140
  00000001412D714E: 33 D2              xor         edx,edx
  00000001412D7150: 48 8D 0D 49 81 D4  lea         rcx,[000000014001F2A0h]
  00000001412D7157: 41 B8 E0 2E 00 00  mov         r8d,2EE0h
  00000001412D715D: E8 DE DF D2 FE     call        0000000140005140
  00000001412D7162: 48 8B CB           mov         rcx,rbx
  00000001412D7165: E8 AA D7 D2 FE     call        0000000140004914
  00000001412D716A: 48 8D 15 FF 00 00  lea         rdx,[00000001412D7270h]
  00000001412D7171: 48 8D 4C 24 20     lea         rcx,[rsp+20h]
  00000001412D7176: FF 15 34 EF D2 FE  call        qword ptr [00000001400060B0h]
  00000001412D717C: 48 8D 4C 24 20     lea         rcx,[rsp+20h]
  00000001412D7181: FF 15 A9 EF D2 FE  call        qword ptr [0000000140006130h]
  00000001412D7187: 48 8D 0D 02 01 00  lea         rcx,[00000001412D7290h]
  00000001412D718E: 48 89 05 CB 10 D3  mov         qword ptr [0000000140008260h],rax
  00000001412D7195: E8 DE A3 D2 FE     call        0000000140001578
  00000001412D719A: 33 C0              xor         eax,eax
  00000001412D719C: 48 8B 8C 24 50 01  mov         rcx,qword ptr [rsp+0000000000000150h]
  00000001412D71A4: 48 33 CC           xor         rcx,rsp
  00000001412D71A7: E8 54 DC D2 FE     call        0000000140004E00
  00000001412D71AC: 48 8B 9C 24 78 01  mov         rbx,qword ptr [rsp+0000000000000178h]
  00000001412D71B4: 48 81 C4 60 01 00  add         rsp,160h
  00000001412D71BB: 5F                 pop         rdi
  00000001412D71BC: C3                 ret
  00000001412D71BD: CC                 int         3
  00000001412D71BE: CC                 int         3
  00000001412D71BF: CC                 int         3
  00000001412D71C0: 48 89 5C 24 08     mov         qword ptr [rsp+8],rbx
  00000001412D71C5: 57                 push        rdi
  00000001412D71C6: 48 83 EC 20        sub         rsp,20h
  00000001412D71CA: 48 8B DA           mov         rbx,rdx
  00000001412D71CD: 48 8B F9           mov         rdi,rcx
  00000001412D71D0: E8 17 00 00 00     call        00000001412D71EC
  00000001412D71D5: 48 8B D3           mov         rdx,rbx
  00000001412D71D8: 48 8B CF           mov         rcx,rdi
  00000001412D71DB: E8 20 FE FF FF     call        00000001412D7000
  00000001412D71E0: 48 8B 5C 24 30     mov         rbx,qword ptr [rsp+30h]
  00000001412D71E5: 48 83 C4 20        add         rsp,20h
  00000001412D71E9: 5F                 pop         rdi
  00000001412D71EA: C3                 ret
  00000001412D71EB: CC                 int         3
  00000001412D71EC: 48 8B 05 1D 10 D3  mov         rax,qword ptr [0000000140008210h]
  00000001412D71F3: 48 85 C0           test        rax,rax
  00000001412D71F6: 74 1B              je          00000001412D7213
  00000001412D71F8: 48 B9 32 A2 DF 2D  mov         rcx,2B992DDFA232h
