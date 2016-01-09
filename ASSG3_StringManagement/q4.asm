section .data
prompt1: db "Enter a string: ", 0Ah
size_prompt1: equ $-prompt1
prompt2: db "Enter another string: ", 0Ah
size_prompt2: equ $-prompt2
yes: db "The strings are identical", 0Ah
size_yes: equ $-yes
no: db "The strings are not identical", 0Ah
size_no: equ $-no
newline: db 0Ah

section .bss
array: resw 100
array2: resw 100
temp: resw 1
length: resw 1
length2: resw 1

section .text
global _start

_start:

;Printing the first input prompt for string

mov eax, 4
mov ebx, 1
mov ecx, prompt1
mov edx, size_prompt1
int 80h

;Reading the string

mov esi, 0
mov word[length], 0

reading:
call input

cmp word[temp], 10
je end_input1

mov ax, word[temp]
mov word[array+2*esi], ax
inc esi
inc word[length]
jmp reading

end_input1:

;Printing the second input prompt for string

mov eax, 4
mov ebx, 1
mov ecx, prompt2
mov edx, size_prompt2
int 80h

;Reading the string

mov esi, 0
mov word[length2], 0

reading2:
call input

cmp word[temp], 10
je end_input2

mov ax, word[temp]
mov word[array2+2*esi], ax
inc esi
inc word[length2]
jmp reading2

end_input2:

call compare



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


mov eax, 3
mov ebx, 0
mov ecx, temp
mov edx, 1
int 80h



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

;Function to compare the strings

compare:

pusha

mov ax, word[length]
cmp ax, word[length2]
jne end_compare

mov ebx, 0

loop:
mov ax, word[array+2*ebx]
cmp ax, word[array2+2*ebx]
jne end_compare

inc ebx
cmp bx, word[length]
je end_printing

jmp loop

end_printing:

mov eax, 4
mov ebx, 1
mov ecx, yes
mov edx, size_yes
int 80h

jmp exit_compare
 
end_compare:

mov eax, 4
mov ebx, 1
mov ecx, no
mov edx, size_no
int 80h

exit_compare:

popa

ret
