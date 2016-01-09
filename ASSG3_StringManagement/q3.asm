section .data
prompt1: db "Enter a string: ", 0Ah
size_prompt1: equ $-prompt1
prompt2: db "Enter a word: ", 0Ah
size_prompt2: equ $-prompt2
result: db "Total count: "
size_result: equ $-result
newline: db 0Ah

section .bss
array: resw 100
array2: resw 100
arr: resw 1000
l1: resw 1
temp: resw 1
length: resw 1
length2: resw 1
count: resw 1
nod: resb 1
num: resw 1

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
mov word[l1], 0

reading:
call input

cmp word[temp], 10
je end_input1

mov ax, word[temp]
mov word[arr+2*esi], ax
inc esi
inc word[l1]
jmp reading

end_input1:

;Printing the input prompt for word

mov eax, 4
mov ebx, 1
mov ecx, prompt2
mov edx, size_prompt2
int 80h

;Reading the word

mov esi, 0
mov word[length2], 0

reading8:
call input

cmp word[temp], 10
je end_input8

mov ax, word[temp]
mov word[array2+2*esi], ax
inc esi
inc word[length2]
jmp reading8

end_input8:

;Traversing through the first and increasing count if equal

mov ebx, 0
mov esi, 0
mov word[length], 0
mov word[count], 0

traversing:

cmp bx, word[l1]
je end_traversing

mov ax, word[arr+2*ebx]
mov word[temp], ax
;call old_print

cmp ax, 32
je comparing

mov word[array+2*esi], ax
mov word[temp], ax
;call old_print
inc word[length]
inc ebx
inc esi
cmp bx, word[l1]
je comparing
jmp traversing

comparing:
call compare
;call print

cmp bx, word[l1]
je end_traversing

inc ebx
mov word[length], 0
mov esi, 0
jmp traversing

end_traversing:

;Printing the result

mov eax, 4
mov ebx, 1
mov ecx, result
mov edx, size_result
int 80h

call print

mov eax, 4
mov ebx, 1
mov ecx, newline
mov edx, 1
int 80h





;System exit
exit:
mov eax, 1
mov ebx, 0
int 80h

old_print:

pusha

mov eax, 4
mov ebx, 1
mov ecx, temp
mov edx, 1
int 80h

popa

ret

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
mov ax, word[count]
mov word[num], ax

cmp word[num], 0
jne extract_no

add word[num], 30h

mov eax, 4
mov ebx, 1
mov ecx, num
mov edx, 1
int 80h

jmp end_print

extract_no:
cmp word[num], 0
je print_no
inc byte[nod]
mov dx, 0
mov ax, word[num]
mov bx, 10
div bx
push dx
mov word[num], ax

jmp extract_no

print_no:
cmp byte[nod], 0
je end_print
dec byte[nod]
pop dx
mov word[temp], dx
add word[temp], 30h

mov eax, 4
mov ebx, 1
mov ecx, temp
mov edx, 1
int 80h

jmp print_no

end_print:
popa

ret

;Alternate print function

next_print:

pusha

add word[count], 30h

mov eax, 4
mov ebx, 1
mov ecx, count
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
inc word[count]
 
end_compare:

popa

ret
