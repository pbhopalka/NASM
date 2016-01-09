section .data
p1: db "Enter a number: "
size_p1: equ $-p1
Prime: db "The number is prime", 0Ah
size_Prime: equ $-Prime
notPrime: db "The number is not prime", 0Ah
size_notPrime: equ $-notPrime
result: db "The number is: "
size_result: equ $-result
newline: db 0Ah
dash: db "-"

section .bss
nod: resb 1
num: resw 1
temp: resb 1
n: resw 1
array: resw 100
count: resw 1
t: resw 1
noe: resb 1

section .text
global _start

_start:

;Printing the prompt

mov eax, 4
mov ebx, 1
mov ecx, p1
mov edx, size_p1
int 80h

call input
mov ax, word[num]
mov word[n], ax

;Putting prime numbers in the array

mov word[t], 2
mov ecx, 0
mov byte[noe], 0
;push ecx

primekeeper:
mov ax, word[t]
cmp ax, word[n]
jg end_primekeeper
mov bx, 2
mov word[count], 0

primeloop:
mov ax, word[t]
mov dx, 0
cmp bx, ax 
jg nextthing  
div bx
cmp dx, 0
je increment
back:
inc bx
jmp primeloop

increment:
inc word[count]
jmp back

nextthing:
cmp word[count], 1
je prime

notprime:

inc word[t]
jmp primekeeper

prime:

mov ax, word[t]
;call print
mov word[array + 2*ecx], ax
inc byte[noe]
inc ecx
inc word[t]

jmp primekeeper

end_primekeeper:
;Printing the array
mov edx, 1

loopy:
cmp dl, byte[noe]
jg exit
mov ax, word[array + 2*edx]
mov bx, word[array + 2*(edx-1)]
sub ax, bx
cmp ax, 2
je print_number
ba:
inc edx
jmp loopy

jmp exit

print_number:
mov ax, word[array + 2*edx]
mov word[num], ax
call print 

pusha

mov eax, 4
mov ebx, 1
mov ecx, dash
mov edx, 1
int 80h

popa

mov word[num], bx
call print

pusha

mov eax, 4
mov ebx, 1
mov ecx, newline
mov edx, 1
int 80h

popa

jmp ba

;System Exit
exit:
mov eax, 1
mov ebx, 0
int 80h


;Function to input a number

input:

pusha

mov word[num], 0

reading:
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
movzx bx, byte[temp]
add ax, bx
mov word[num], ax

jmp reading

end_input:

popa

ret

;Function to print a number

print:

pusha

mov byte[nod], 0

printloop:
mov dx, 0
mov ax, word[num]
mov bx, 10
div bx
push dx
inc byte[nod]
cmp ax, 0
je print_no
mov word[num], ax
jmp printloop

print_no:
cmp byte[nod], 0
je end_print
pop dx
mov byte[temp], dl
add byte[temp], 30h

mov eax, 4
mov ebx, 1
mov ecx, temp
mov edx, 1
int 80h

dec byte[nod]
jmp print_no

end_print:


popa

ret
