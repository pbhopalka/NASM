section .data
prompt1: db "Enter a string: ", 0Ah
size_prompt1: equ $-prompt1
prompt2: db "Enter a word: ", 0Ah
size_prompt2: equ $-prompt2
largest: db "The largest word is: "
size_largest: equ $-largest
smallest: db "The smallest word is: "
size_smallest: equ $-smallest
newline: db 0Ah

section .bss
array: resw 2000
array2: resw 100
arr: resw 1000
l1: resw 1
temp: resw 1
length: resw 100
length2: resw 1
count: resw 1
nol1: resw 1
nod: resb 1
num: resw 1
min: resw 1
max: resw 1
maxpos: resd 1
minpos: resd 1

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

mov word[nol1], 0
mov edx, 0
mov ebx, 0 
mov ecx, ebx
shl ecx, 5
add edx, ecx
mov word[length+2*ebx], 0

reading:
call input

cmp word[temp], 10
je end_input1

cmp word[temp], 32
jne after_make_change

inc word[nol1]
mov ax, word[temp]
mov word[array+2*edx], ax
inc ebx
mov word[length+2*ebx], 0
mov ecx, ebx
shl ecx, 5
mov edx, 0
add edx, ecx
jmp reading

after_make_change:

mov ax, word[temp]
mov word[array+2*edx], ax
inc word[length+2*ebx]
inc edx
jmp reading
 
end_input1:

mov word[array+2*edx], 32

;;;;;;;;;;;;;;;;;;;;;;;Printing the length array

;mov eax, 0

;again_print:
;mov bx, word[length+2*eax]
;mov word[count], bx
;call print
;inc eax
;cmp ax, word[nol1]
;jng again_print
;call print_newline

call find_maximum

call find_minimum

;call print_newline

;Printing the largest word

mov eax, 4
mov ebx, 1
mov ecx, largest
mov edx, size_largest
int 80h

mov ebx, dword[maxpos]
shl ebx, 5

repeat_print:
mov ax, word[array+2*ebx]
mov word[temp], ax
call old_print
inc ebx
cmp word[array+2*ebx], 32
jne repeat_print

call print_newline

;Printing the smallest word

mov eax, 4
mov ebx, 1
mov ecx, smallest
mov edx, size_smallest
int 80h

mov ebx, dword[minpos]
shl ebx, 5

repeat_print2:
mov ax, word[array+2*ebx]
mov word[temp], ax
call old_print
inc ebx
cmp word[array+2*ebx], 32
jne repeat_print2

call print_newline


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

;Function to print newline

print_newline:

pusha

mov eax, 4
mov ebx, 1
mov ecx, newline
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

;;;;;;;;;;;;;;;;Getting the maximum in an array

find_maximum:

pusha

mov word[max], 0
mov ebx, 0
movzx ecx, word[nol1]
inc ecx
mov dword[maxpos], array

traverse:
;mov al, byte[max]
;cmp byte[ebx], al
;je end_traverse
mov ax, word[length+2*ebx]
cmp word[max], ax
jnl end_traverse
jne check_lexical

push ecx
mov ecx, ebx
shl ecx, 5
mov di, word[array+2*ecx]
movzx ecx, word[maxpos]
shl ecx, 5
mov si, word[array+2*ecx]
cmp si, di
jnl end_traverse
pop ecx

check_lexical:
mov word[max], ax
mov dword[maxpos], ebx

end_traverse:
inc ebx
loop traverse

popa

ret

;;;;;;;;;;;;;;;;Getting the minimum in an array

find_minimum:

pusha

mov word[min], 100
mov ebx, 0
movzx ecx, word[nol1]
inc ecx
mov dword[minpos], array

traverse1:
;mov al, byte[max]
;cmp byte[ebx], al
;je end_traverse
mov ax, word[length+2*ebx]
cmp word[min], ax
jng end_traverse1
jne check_lexical2

push ecx
mov ecx, ebx
shl ecx, 5
mov di, word[array+2*ecx]
movzx ecx, word[minpos]
shl ecx, 5
mov si, word[array+2*ecx]
cmp si, di
jnl end_traverse
pop ecx

check_lexical2:
mov word[min], ax
mov dword[minpos], ebx 

end_traverse1:
inc ebx
loop traverse1

popa

ret