; Âàðèàíò 18
; Ðàçðàáîòàòü ïðîãðàììó, ôîðìèðóþùóþ ìàññèâ A[N] è íîâûé ìàññèâ B  óìåíüøåíèåì âñåõ
; ýëåìåíòîâ äî ïåðâîãî ïîëîæèòåëüíîãî íà 5

format PE console

entry start

include 'win32a.inc'

section '.data' data readable writable

        enterN db 'Enter N:', 10, 13, '>> ', 0
        info db "Now we'll change the array.", 10, 13, '>>', 0
        endl db 10, 13, 0
        repEnter db 'N must be from 1 to 10^6. Enter the size of array again', 0
        enterStart db 'Enter the ', 0
        enterEnd db '-st elemet', 10, 13, '>> ', 0
        outStart db '[ ', 0
        outEnd db ' ]', 10, 13, 0
        tmpStack dd ?
        newStr db '', 10, 13, 0
        outMiddle db ', ', 0, 10, 13, 0
        lastMessage db 'Rogramm has been finished',10, 13, 0
        hheap dd ?
        mas dd ?
        i dd ?
        null dd 0
        digit db '%d', 0
        N dd ?

section '.code' code readable executable

start:

        call vectorInput
        call vectorOutput
        call changeVector
        call changedVectorOutput

        call [getch]
        push [null]
        call [ExitProcess]

;-------------------------------first act - creating array--------------------------
vectorInput:

                push enterN
                call [printf]
                push N
                push digit
                call [scanf]
                cmp [N], 1
                jl repeatInput
                cmp [N], 1000000
                jg repeatInput
                invoke HeapCreate,HEAP_NO_SERIALIZE,0,0
                mov [hheap],eax

                invoke HeapAlloc,[hheap],HEAP_NO_SERIALIZE,N*8

                mov [mas],eax
                mov [i], -1
                cinvoke printf, newStr
                jmp loop2

        repeatInput:

                cinvoke printf,newStr
                cinvoke printf,repEnter
                jmp start

        loop2:

                add [i], 1

                cinvoke printf,enterStart
                cinvoke printf,digit,[i]
                cinvoke printf,enterEnd

                mov ecx, [i]
                imul ecx, dword 4
                mov eax, [mas]
                add eax, ecx

                cinvoke scanf, digit, eax
                mov ecx, [i]
                add ecx, 1
                cmp ecx, [N]
                jne loop2
                jmp end2

        end2:

                cinvoke printf, newStr
                cinvoke printf, outStart
                mov [i], -1
                jmp loop3

;-------------------------------second act - showing original vector--------------------------

vectorOutput:

                loop3:
                        add [i], 1
                        mov ecx, [i]
                        imul ecx, dword 4
                        mov eax, [mas]
                        add eax, ecx
                        cinvoke printf, digit, dword [eax]
                        mov ecx, [i]
                        add ecx, 1
                        cmp ecx, [N]
                        jne printDot
                        jmp loop3cont

        printDot:

                cinvoke printf,outMiddle

        loop3cont:

                mov ecx, [i]
                add ecx, 1
                cmp ecx, [N]
                jne loop3
                jmp end3

        end3:

                cinvoke printf,outEnd
                cinvoke printf,newStr
                cinvoke printf,info
                mov [i], -1
                jmp loop4

;-------------------------------forth act - changing vector--------------------------

changeVector:

            loop4:

                add [i], 1
                mov ecx, [i]
                imul ecx, dword 4
                mov eax, [mas]
                add eax, ecx
                mov ebx, [eax]

                cmp ebx, 0
                jl lessThan0

        continueLoop4:

                mov [eax], ebx
                mov ecx, [i]
                inc ecx
                cmp ecx, [N]
                jne loop4
                jmp end4

        lessThan0:

                add ebx, -5
                mov [eax], ebx
                mov ecx, [i]
                inc ecx
                cmp ecx, [N]
                jne loop4
                jmp end4

        end4:

                cinvoke printf, endl
                mov [i], -1
                cinvoke printf, outStart
                jmp loop5

;-------------------------------fifth act - showing new vector--------------------------

changedVectorOutput:

                loop5:

                        add [i], 1
                        mov ecx, [i]
                        imul ecx, dword 4
                        mov eax, [mas]
                        add eax, ecx
                        cinvoke printf, digit, dword [eax]
                        mov ecx, [i]
                        add ecx, 1
                        cmp ecx, [N]
                        jne printDot5
                        jmp loop5cont

                printDot5:

                        cinvoke printf, outMiddle

                loop5cont:

                        mov ecx, [i]
                        add ecx, 1
                        cmp ecx, [N]
                        jne loop5
                        jmp end5

                end5:

                        cinvoke printf, outEnd
                        cinvoke printf, newStr
                        cinvoke printf, lastMessage

;-------------------------------sixth act - including HeapApi--------------------------

section '.idata' import data readable

library kernel, 'kernel32.dll',\
        msvcrt, 'msvcrt.dll',\
        user32,'USER32.DLL'
        include 'api\user32.inc'
        include 'api\kernel32.inc'

import kernel,\
       ExitProcess, 'ExitProcess',\
       HeapCreate,'HeapCreate',\
       HeapAlloc,'HeapAlloc'
       include 'api\kernel32.inc'

import msvcrt,\
       printf, 'printf',\
       scanf, 'scanf',\
       getch, '_getch'                
