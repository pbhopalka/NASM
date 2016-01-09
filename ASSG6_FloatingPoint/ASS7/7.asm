section .data
mes1: db "Enter x :", 0Ah
len1: equ $-mes1
mes2: db "f(x) = "
len2: equ $-mes2
format1: db "%lf", 0
format2: db "%lf", 10

section .bss
num: resd 1
x: resq 1
ans: resq 1
tmp: resb 1

section .text
global main:
extern scanf
extern printf

main:

;;Enter a floating point number
mov eax, 4
mov ebx, 1
mov ecx, mes1
mov edx, len1
int 80h

call read_float

fst qword[x]

fld qword[x]

fmul ST1
fmul ST1

fstp qword[ans] 
fld qword[x]

fmul ST0

fld qword[ans]
fadd ST1

fstp qword[ans]
fld qword[x]

mov dword[num], 5
fimul dword[num]

fld qword[ans]
fsub ST1

fstp qword[ans]

mov dword[num], 9
fild dword[num]

fld qword[ans]
fadd ST1

fstp qword[ans]

fld qword[ans]

mov eax, 4
mov ebx, 1
mov ecx, mes2
mov edx, len2
int 80h

call print_float

EXIT:
mov eax, 1
mov ebx, 0
int 80h   

;;;;;;;;;;;;;;;;;;;;function to read floating point

read_float:
push ebp
mov ebp, esp
sub esp, 8

lea eax, [esp]
push eax
push format1
call scanf
fld qword[ebp - 8]

mov esp, ebp
pop ebp
ret

;;;;;;;;;;;;;;;function to print floating point

print_float:
push ebp
mov ebp, esp
sub esp, 8

fst qword[ebp - 8]
push format2
call printf
mov esp, ebp
pop ebp
ret
