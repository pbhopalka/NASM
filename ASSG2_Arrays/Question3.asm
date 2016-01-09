section .data
prompt1: db 0Ah, "Enter the size of array: "
size_prompt1: equ $-prompt1
prompt2: db 0Ah, "Enter the element: "
size_prompt2: equ $-prompt2
result: db 0Ah, "The number divisible by 7 are: ", 0Ah
size_result: equ $-result
newline: db 0Ah

section .bss
array: resb 100
digit0: resb 1
digit1: resb 1
num: resw 1
noe: resw 1
nod: resb 1
counter: resb 1
temp: resb 1
enter: resb 1

section .text
global _start

_start:

;Printing the first prompt
mov eax, 4
mov ebx, 1
mov ecx, prompt1
mov edx, size_prompt1
int 80h

call input
mov ax, word[num]
mov word[noe], ax
mov byte[counter], al

mov ebx, array

read:
push ebx

;Printing the message to print each element
mov eax, 4
mov ebx, 1
mov ecx, prompt2
mov edx, size_prompt2
int 80h

pop ebx

call input
mov ax, word[num]
mov byte[ebx], al
add ebx, 1
dec byte[counter]
cmp byte[counter], 0
jg read

;Printing the result prompt
pusha

mov eax, 4
mov ebx, 1
mov ecx, result
mov edx, size_result
int 80h 

popa

mov ax, word[noe]
mov byte[counter], al
mov ebx, array

traverse:
movzx ax, byte[ebx]
mov dl, 7
div dl
cmp ah, 0
jne leave

;Printing the number
movzx ax, byte[ebx]
mov word[num], ax
call print

pusha
mov eax, 4
mov ebx, 1
mov ecx, newline
mov edx, 1
int 80h
popa

leave:
add ebx, 1
dec byte[counter]
cmp byte[counter], 0
jne traverse

;System Exit
mov eax, 1
mov ebx, 0
int 80h

;Function to read a number
input:

pusha

mov word[num], 0

loopadd:
mov eax, 3
mov ebx, 0
mov ecx, temp
mov edx, 1
int 80h

cmp byte[temp], 10
je end_read

mov ax, word[num]
mov bx, 10
mul bx
sub byte[temp], 30h
mov bl, byte[temp]
mov bh, 0
add ax, bx
mov word[num], ax
jmp loopadd

end_read:
popa

ret

;Function to print a number
print:

pusha

extract:
cmp word[num], 0
je print_no
inc byte[nod]
mov dx, 0
mov ax, word[num]
mov bx, 10
div bx
push dx
mov word[num], ax
jmp extract

print_no:
cmp byte[nod], 0
je end_print
dec byte[nod]
pop dx
mov byte[temp], dl
add byte[temp], 30h

mov eax, 4
mov ebx, 1
mov ecx, temp
mov edx, 1
int 80h

jmp print_no

end_print:


popa

ret
