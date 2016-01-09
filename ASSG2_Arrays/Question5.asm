section .data
p1: db "Enter the number of rows in the matrix: "
size_p1: equ $-p1
p2: db "Enter the number of columns in the matrix: "
size_p2: equ $-p2
p3: db "Enter the elements with an enter after each element(row by row):", 0Ah
size_p3: equ $-p3
p4: db 0Ah, "The matrix that you entered is:", 0Ah
size_p4: equ $-p4
p5: db 0Ah, "The transposed matrix is:", 0Ah
size_p5: equ $-p5
newline: db 0Ah
space: db 32

section .bss
num: resw 1
nod: resb 1
temp: resb 1
matrix1: resw 200
m: resw 1
n: resw 1
i: resw 1
j: resw 1

section .text
global _start

_start:

;Printing the prompt for entering rows
mov eax, 4
mov ebx, 1
mov ecx, p1
mov edx, size_p1
int 80h

call input
mov ax, word[num]
mov word[m], ax

;Printing the prompt for entering columns
mov eax, 4
mov ebx, 1
mov ecx, p2
mov edx, size_p2
int 80h

call input
mov ax, word[num]
mov word[n], ax

;Printing the prompt for getting elements to the matrix
mov eax, 4
mov ebx, 1
mov ecx, p3
mov edx, size_p3
int 80h

mov edx, 0
mov ebx, matrix1
mov ax, word[m]
mov word[i], ax

mov ax, word[n]
mov word[j], ax


repeat:
call input
mov ax, word[num]
mov word[ebx + 2 * edx], ax
inc edx
dec word[j]
cmp word[j], 0
je dec_i
back:
cmp word[i], 0
jne repeat
jmp input_print

;Decrementing the value of i
dec_i:

dec word[i];
mov ax, word[n]
mov word[j], ax
jmp back

dec_i_again:

dec word[i];
mov ax, word[n]
mov word[j], ax

pusha
mov eax, 4
mov ebx, 1
mov ecx, newline
mov edx, 1
int 80h
popa

jmp back2

;Printing the inputted array
input_print:

;Printing the prompt for saying the input array is:
mov eax, 4
mov ebx, 1
mov ecx, p4
mov edx, size_p4
int 80h

mov edx, 0
mov ebx, matrix1
mov ax, word[m]
mov word[i], ax

mov ax, word[n]
mov word[j], ax

repeat1:
mov ax, word[ebx + 2 * edx]
mov word[num], ax
call print

pusha
mov eax, 4
mov ebx, 1
mov ecx, space
mov edx, 1
int 80h
popa

inc edx
dec word[j]
cmp word[j], 0
je dec_i_again
back2:
cmp word[i], 0
jne repeat1
jmp transpose

;Getting the transpose and printing it
transpose:

;Printing the prompt to print "The transposed matrix is:"
mov eax, 4
mov ebx, 1
mov ecx, p5
mov edx, size_p5
int 80h

mov word[i], 0
mov word[j], 0
movzx ecx, word[n]


i_loop:
mov word[j], 0

;Printing a newline
pusha
mov eax, 4
mov ebx, 1
mov ecx, newline
mov edx, 1
int 80h
popa

j_loop:
mov edx, 0
movzx eax, word[j]
mul ecx
movzx ebx, word[i]
add eax, ebx
mov dx, word[matrix1 + 2 * eax]
mov word[num], dx
call print

;Printing a space
pusha
mov eax, 4
mov ebx, 1
mov ecx, space
mov edx, 1
int 80h
popa

inc word[j]

mov dx, word[j]
cmp word[m], dx
jne j_loop


inc word[i]
mov dx, word[i]
cmp word[n], dx
jne i_loop


exit:
;System Exit
mov eax, 1
mov ebx, 0
int 80h

;Function to take the input
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

