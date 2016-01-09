section .data
prompt1: db "Enter a string: ", 0Ah
size_prompt1: equ $-prompt1
prompt2: db "Enter another string: ", 0Ah
size_prompt2: equ $-prompt2
yes: db "The second string is a circular permutation"
size_yes: equ $-yes
no: db "The second string is not a circular permutation"
size_no: equ $-no
newline: db 0Ah

section .bss
array: resw 100
array2: resw 100
l1: resw 1
temp: resw 1
length2: resw 1
count: resw 1
nod: resb 1
num: resw 1
flag: resw 1

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
mov word[array+2*esi], ax
inc esi
inc word[l1]
jmp reading

end_input1:

call concatenate

;Printing the string

;mov edx, 0

;printing:
;mov ax, word[array+2*edx]
;mov word[temp], ax
;call print_character
;inc edx
;cmp dx, word[l1]
;jne printing

;Printing the input prompt for second string

mov eax, 4
mov ebx, 1
mov ecx, prompt2
mov edx, size_prompt2
int 80h

;Reading the second string

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

;Finding the first element

mov eax, 0
mov ebx, 0

looping:
mov cx, word[array+2*eax]
cmp word[array2+2*ebx], cx
jne nexty

call compare
cmp word[flag], 1
je printing_yes

nexty:
inc eax
mov ebx, 0
cmp ax, word[l1]
jle looping

jmp printing_no

looping2:
mov cx, word[array+2*eax]
cmp word[array2+2*ebx], cx
jne printing_no
inc eax
inc ebx
cmp ax, word[l1]
jne afterChange_eax

mov eax, 0

afterChange_eax:
cmp bx, word[length2]
jge printing_yes
jmp looping2

printing_yes:

mov eax, 4
mov ebx, 1
mov ecx, yes
mov edx, size_yes
int 80h

jmp exit

printing_no:

mov eax, 4
mov ebx, 1
mov ecx, no
mov edx, size_no
int 80h

jmp exit


;System exit
exit:

mov eax, 4
mov ebx, 1
mov ecx, newline
mov edx, 1
int 80h

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

;Function to print a character

print_character:

pusha

mov eax, 4
mov ebx, 1
mov ecx, temp
mov edx, 1
int 80h

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

concatenate:

pusha

movzx esi, word[l1]
shl word[l1], 1
mov edx, 0

loop_concatenate:
mov ax, word[array+2*edx]
mov word[array+2*esi], ax
inc esi
inc edx
cmp si, word[l1]
jne loop_concatenate

popa

ret

;Compare Function
compare:

mov edx, 0
mov ebx, eax
mov word[flag], 0

compare_here:
cmp dx, word[length2]
je end_compare
mov cx, word[array+2*ebx]
cmp word[array2+2*edx], cx
jne exit_compare

inc ebx
inc edx
jmp compare_here

end_compare:
mov word[flag], 1

exit_compare:

ret