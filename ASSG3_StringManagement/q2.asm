section .data
prompt: db "Enter a string: ", 0Ah
size_prompt: equ $-prompt
result: db "The result without spaces:", 0Ah
size_result: equ $-result
newline: db 0Ah

section .bss
array: resw 100
temp: resw 1
length: resw 1

section .text
global _start

_start:

;Printing the input prompt

mov eax, 4
mov ebx, 1
mov ecx, prompt
mov edx, size_prompt
int 80h

call input

;Traversing through the array and printing the output

mov eax, 4
mov ebx, 1
mov ecx, result
mov edx, size_result
int 80h

mov eax, 0

going:
cmp ax, word[length]
je exit

mov bx, word[array+2*eax]
mov word[temp], bx
call print

inc eax
jmp going



exit:

mov eax, 4
mov ebx, 1
mov ecx, newline
mov edx, 1
int 80h

;System exit

mov eax, 1
mov ebx, 0
int 80h

;Function to input a string

input:

pusha

mov esi, 0
mov word[length], 0

reading:
mov eax, 3
mov ebx, 0
mov ecx, temp
mov edx, 1
int 80h

cmp word[temp], 10
je end_input

cmp word[temp], 32
je reading

mov ax, word[temp]
mov word[array+2*esi], ax
inc esi
inc word[length]
jmp reading

end_input:

popa

ret


;Function to print a number

print:

pusha

mov eax, 4
mov ebx, 1
mov ecx, temp
mov edx, 1
int 80h

popa

ret
