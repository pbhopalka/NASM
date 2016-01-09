section .data
p1a: db "Enter the number of rows in the matrix A: "
size_p1a: equ $-p1a
p2a: db "Enter the number of columns in the matrix A: "
size_p2a: equ $-p2a
p1b: db "Enter the number of rows in the matrix B: "
size_p1b: equ $-p1b
p2b: db "Enter the number of columns in the matrix B: "
size_p2b: equ $-p2b
p3: db "Enter the elements with an enter after each element(row by row):", 0Ah
size_p3: equ $-p3
p4: db 0Ah, "The matrix that you entered is:", 0Ah
size_p4: equ $-p4
result: db 0Ah, "After multiplication, your matrix is:", 0Ah
size_result: equ $-result
error: db 0Ah, "These two matrices canot be multiplied."
size_error: equ $-error
newline: db 0Ah
space: db 32

section .bss
num: resw 1
nod: resb 1
temp: resb 1
temp1: resw 1
matrixA: resw 200
matrixB: resw 200
matrixC: resw 200
m1: resw 1
n1: resw 1
m2: resw 1
n2: resw 1
i: resw 1
j: resw 1
k: resw 1
i1: resw 1
j1: resw 1
t1: resw 1
t2: resw 1
t: resw 1

section .text
global _start

_start:

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;For Matix A

;Printing the prompt for asking rows of matrix A

mov eax, 4
mov ebx, 1
mov ecx, p1a
mov edx, size_p1a
int 80h

call input
mov ax, word[num]
mov word[m1], ax

;Priniting the prompt for asking columns of matrix A

mov eax, 4
mov ebx, 1
mov ecx, p2a
mov edx, size_p2a
int 80h

call input
mov ax, word[num]
mov word[n1], ax

;Printing the prompt for getting the elements of matrix A

mov eax, 4
mov ebx, 1
mov ecx, p3
mov edx, size_p3
int 80h

mov edx, 0
mov ebx, matrixA
mov ax, word[m1]
mov word[i1], ax

mov ax, word[n1]
mov word[j1], ax

repeat:
call input
mov ax, word[num]
mov word[ebx + 2 * edx], ax
inc edx
dec word[j1]
cmp word[j1], 0
je dec_i
back:
cmp word[i1], 0
jne repeat
jmp next

;Decrementing the value of i
dec_i:

dec word[i1];
mov ax, word[n1]
mov word[j1], ax
jmp back

;Printing the matrix A
next:
mov edx, 0
mov ebx, matrixA
mov ax, word[m1]
mov word[i], ax

mov ax, word[n1]
mov word[j], ax
mov word[temp1], ax
call input_print


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;For Matrix B

;Printing the prompt for asking rows of matrix B

mov eax, 4
mov ebx, 1
mov ecx, p1b
mov edx, size_p1b
int 80h

call input
mov ax, word[num]
mov word[m2], ax

;Priniting the prompt for asking columns of matrix B

mov eax, 4
mov ebx, 1
mov ecx, p2b
mov edx, size_p2b
int 80h

call input
mov ax, word[num]
mov word[n2], ax

;Printing the prompt for getting the elements of matrix B

mov eax, 4
mov ebx, 1
mov ecx, p3
mov edx, size_p3
int 80h

mov edx, 0
mov ebx, matrixB
mov ax, word[m2]
mov word[i1], ax

mov ax, word[n2]
mov word[j1], ax

repeatB:
call input
mov ax, word[num]
mov word[ebx + 2 * edx], ax
inc edx
dec word[j1]
cmp word[j1], 0
je dec_i_b
backB:
cmp word[i1], 0
jne repeatB
jmp nextB

;Decrementing the value of i
dec_i_b:

dec word[i1];
mov ax, word[n2]
mov word[j1], ax
jmp backB

;Printing the matrix B
nextB:
mov edx, 0
mov ebx, matrixB
mov ax, word[m2]
mov word[i], ax

mov ax, word[n2]
mov word[j], ax
mov word[temp1], ax
call input_print

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;Error checking
mov ax, word[m2]
cmp word[n1], ax
je ok

mov eax, 4
mov ebx, 1
mov ecx, error
mov edx, size_error
int 80h
jmp exit

ok:

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;Multiplying two matrices

mov word[i], 0
mov word[j], 0
mov word[k], 0

i_loop:
mov word[j], 0

j_loop:
mov word[k], 0

k_loop:

;Getting a[i][k]
pusha
mov ax, word[i]
mov cx, word[n1]
mul cl
add ax, word[k]
mov bx, word[matrixA + 2 * eax]
mov word[t1], bx
popa

;Getting b[k][j]
pusha
mov ax, word[k]
mov cx, word[n2]
mul cl
add ax, word[j]
mov bx, word[matrixB + 2 * eax]
mov word[t2], bx
popa

;Multiplying a[i][k] * b[k][j]
mov ax, word[t1]
mov cx, word[t2]
mul cl
mov word[t], ax

;Getting c[i][j]
mov ax, word[i]
mov cx, word[n2]
mul cl
add ax, word[j]
mov cx, word[t]
add word[matrixC + 2 * eax], cx
inc word[k]
mov cx, word[k]
cmp word[n1], cx
jne k_loop

inc word[j]
mov dx, word[j]
cmp word[n2], dx
jne j_loop

inc word[i]
mov ax, word[i]
cmp word[m1], ax
jne i_loop

;Printing the matrix C
mov edx, 0
mov ebx, matrixC
mov ax, word[m1]
mov word[i], ax

mov ax, word[n2]
mov word[j], ax
mov word[temp1], ax

;Printing the prompt for result
pusha
mov eax, 4
mov ebx, 1
mov ecx, result
mov edx, size_result
int 80h
popa


repeat2:
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
je dec_i_again2
back3:
cmp word[i], 0
jne repeat2
jmp exit

dec_i_again2:

dec word[i];
mov ax, word[temp1]
mov word[j], ax

pusha
mov eax, 4
mov ebx, 1
mov ecx, newline
mov edx, 1
int 80h
popa

jmp back3

;System Exit
exit:
mov eax, 1
mov ebx, 0
int 80h

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;Function to print the inputted array
dec_i_again:

dec word[i];
mov ax, word[temp1]
mov word[j], ax

pusha
mov eax, 4
mov ebx, 1
mov ecx, newline
mov edx, 1
int 80h
popa

jmp back2

input_print:

;Printing the prompt for saying the input array is:
pusha
mov eax, 4
mov ebx, 1
mov ecx, p4
mov edx, size_p4
int 80h
popa


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

ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;Function to take the input
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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;Function to print a number
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

