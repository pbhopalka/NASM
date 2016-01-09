section .data
prompt1: db 0Ah, "Enter the size of array: "
size_prompt1: equ $-prompt1
prompt2: db 0Ah, "Enter the element: "
size_prompt2: equ $-prompt2
arA: db 0Ah, "For First Array A", 0Ah
size_arA: equ $-arA
arB: db 0Ah, "For Second Array B", 0Ah
size_arB: equ $-arB
result: db 0Ah, "Elements of Array C are: ", 0Ah
size_result: equ $-result
newline: db 0Ah

section .bss
arrayA: resb 100
arrayB: resb 100
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

;Printing the first prompt for asking n
mov eax, 4
mov ebx, 1
mov ecx, prompt1
mov edx, size_prompt1
int 80h

call input
mov ax, word[num]
mov word[noe], ax
mov byte[counter], al

;For the first array A

;Printing prompt "For First Array A"
mov eax, 4
mov ebx, 1
mov ecx, arA
mov edx, size_arA
int 80h

mov ebx, arrayA

read1:
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
jg read1


;For the second array B

;Printing prompt "For First Array A"
mov eax, 4
mov ebx, 1
mov ecx, arB
mov edx, size_arB
int 80h

mov ebx, arrayB
mov edx, arrayA
mov ax, word[noe]
mov byte[counter], al

read2:
push ebx
push edx

;Printing the message to print each element
mov eax, 4
mov ebx, 1
mov ecx, prompt2
mov edx, size_prompt2
int 80h

pop edx
pop ebx

call input
mov ax, word[num]
cmp byte[edx], al
jng next

mov al, byte[edx]
mov byte[ebx], al
jmp leave

next:
mov byte[ebx], al

leave:
add ebx, 1
add edx, 1
dec byte[counter]
cmp byte[counter], 0
jg read2

;Printing the elements of the array C while storing it
mov eax, 4
mov ebx, 1
mov ecx, result
mov edx, size_result
int 80h

mov ax, word[noe]
mov byte[counter], al
mov ebx, arrayB

traverse:

;Printing the number
movzx ax, byte[ebx]
mov word[num], ax
call print

push ebx

mov eax, 4
mov ebx, 1
mov ecx, newline
mov edx, 1
int 80h

pop ebx

add ebx, 1
dec byte[counter]
cmp byte[counter], 0
jne traverse

;System exit
mov eax, 1
mov ebx, 0
int 80h

;Taking input
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
