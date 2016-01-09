section .data
prompt2: db 0Ah, "Enter the element: "
size_prompt2: equ $-prompt2
result: db "The numbers divisible by 7 are:", 0Ah
size_result: equ $-result
newline: db 0Ah

section .bss
array: resb 100
digit0: resb 1
digit1: resb 1
num: resb 1
max: resb 1
sMax: resb 1
noe: resb 1
counter: resb 1

section .text
global _start

_start:

;Printing the message to print each element
mov eax, 4
mov ebx, 1
mov ecx, prompt2
mov edx, size_prompt2
int 80h

;Reading the digits for the number
mov eax, 3
mov ebx, 0
mov ecx, digit1
mov edx, 1
int 80h

mov eax, 3
mov ebx, 0
mov ecx, digit0
mov edx, 1
int 80h



sub byte[digit0], 30h
sub byte[digit1], 30h

;Making the number
movzx ax, byte[digit1]
mov bl, 10
mul bl
add al, byte[digit0] 
mov byte[num], al

movzx ax, byte[num]
mov bl, 7
div bl
cmp ah, 0
jne back

;Printing the result
movzx ax, byte[num]
mov bl, 10
div bl
mov byte[digit1], al
mov byte[digit0], ah

add byte[digit1], 30h
add byte[digit0], 30h

mov eax, 4
mov ebx, 1
mov ecx, digit1
mov edx, 1
int 80h

mov eax, 4
mov ebx, 1
mov ecx, digit0
mov edx, 1
int 80h

mov eax, 4
mov ebx, 1
mov ecx, newline
mov edx, 1
int 80h

back:

;System exit

mov eax, 1
mov ebx, 0
int 80h
