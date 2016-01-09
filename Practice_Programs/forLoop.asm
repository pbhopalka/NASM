Section .data

Section .bss
ans: resw 1
digit: resb 1
digit1: resb 1
digit2: resb 1

Section .text
global _start

_start:

mov word[ans], 0
mov byte[digit], 10

movzx cx, byte[digit]

adding:
add word[ans], cx
inc byte[digit]
cmp byte[digit], 10
loop adding

mov ax, word[ans]
mov bl, 10
div bl
mov byte[digit1], al
mov byte[digit2], ah

add byte[digit1], 30h
add byte[digit2], 30h

;add word[ans], 30h

mov eax, 4
mov ebx, 1
mov ecx, digit2
mov edx, 1
int 80h

mov eax, 4
mov ebx, 1
mov ecx, digit1
mov edx, 1
int 80h

mov eax, 1
mov ebx, 0
int 80h


