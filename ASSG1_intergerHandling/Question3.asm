Section .data
prompt: db "Enter a number beween 0 and 9: "
length: equ $-prompt
newLine: db 0Ah
lNewLine: equ $-newLine
zero: db '0'

Section .bss
digit: resb 1 
print: resb 1

Section .text
global _start:

_start:

;Printing the prompt
mov eax, 4
mov ebx, 1
mov ecx, prompt
mov edx, length
int 80h

;Reading a digit
mov eax, 3
mov ebx, 0
mov ecx, digit
mov edx, 1
int 80h

;Converting from ASCII to Number
sub byte[digit], 30h

;Calculating even or odd
mov ecx, 0
movzx cx, byte[digit]

repeat:
pusha
mov ax, cx
mov bl, 2
div bl
cmp ah, 0

jne print_odd

;Printing the number if even
mov byte[print], cl
add byte[print], 30h

mov eax, 4
mov ebx, 1
mov ecx, print
mov edx, 1
int 80h

;Printing the newline
mov eax, 4
mov ebx, 1
mov ecx, newLine
mov edx, lNewLine
int 80h

print_odd:

popa
loop repeat

;Printing zero as one of the outputs
mov eax, 4
mov ebx, 1
mov ecx, zero
mov edx, 1
int 80h

;Printing the last newline
mov eax, 4
mov ebx, 1
mov ecx, newLine
mov edx, lNewLine
int 80h


;Exit call
mov eax, 1
mov ebx, 0
int 80h
