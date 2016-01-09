section .data
prompt1: db "Enter the size of array: "
size_prompt1: equ $-prompt1
prompt2: db "Enter the element: "
size_prompt2: equ $-prompt2
result_odd: db "The count of odd numbers is: "
size_result_odd: equ $-result_odd
result_even: db "The count of even numbers is: "
size_result_even: equ $-result_even 
newline: db 0Ah

section .bss
array: resb 100
temp: resb 1
temp1: resb 1
nod: resb 1
num: resb 1
max: resb 1
sMax: resb 1
noe: resb 1
counter: resb 1
oddCount: resb 1
evenCount: resb 1

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
mov byte[noe], al
mov byte[counter], al

;Reading elements for the array
mov ebx, array

read:
push ebx

;Printing the message to print each element
mov eax, 4
mov ebx, 1
mov ecx, prompt2
mov edx, size_prompt2
int 80h

call input
mov ax, word[num]

;Adding the number to the array
pop ebx
mov byte[ebx], al
add ebx, 1
dec byte[counter]

cmp byte[counter], 0
jg read

;Traversing through the array
movzx ecx, byte[noe]
mov ebx, array

mov byte[oddCount], 0
mov byte[evenCount], 0

traverse:
mov ah, 0
mov al, byte[ebx]
mov dl, 2
div dl
cmp ah, 0
je end_traverse

inc byte[oddCount]

end_traverse:
add ebx, 1
loop traverse

mov al, byte[oddCount]
mov bl, byte[noe]
sub bl, al
mov byte[evenCount], bl

;Printing count of even numbers

mov eax, 4
mov ebx, 1
mov ecx, result_even
mov edx, size_result_even
int 80h

mov al, byte[evenCount]
mov byte[num], al
call print

;Printing count of odd numbers

mov eax, 4
mov ebx, 1
mov ecx, result_odd
mov edx, size_result_odd
int 80h

mov al, byte[oddCount]
mov byte[num], al
call print









;System exit
mov eax, 1
mov ebx, 0
int 80h


;;;;;;;;; Function to read a number

input:

pusha

mov word[num], 0

readloop:
mov eax, 3
mov ebx, 0
mov ecx, temp
mov edx, 1
int 80h

cmp byte[temp], 10
je end_input

mov ax, word[num]
mov bl, 10
mul bl
sub byte[temp], 30h
mov bx, 0
mov bl, byte[temp]
add ax, bx
mov word[num], ax
jmp readloop

end_input:
popa

ret

;;;;;;;;;;;;;;;;Function to print a number

print:

pusha

mov byte[nod], 0

extract:
cmp word[num], 0
je print_number
inc byte[nod]
mov dx, 0
mov ax, word[num]
mov bx, 10
div bx
push dx
mov word[num], ax
jmp extract

print_number:
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

jmp print_number

end_print:

mov eax, 4
mov ebx, 1
mov ecx, newline
mov edx, 1
int 80h

popa

ret
