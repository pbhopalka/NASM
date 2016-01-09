section .data
prompt1: db "Enter a string: ", 0Ah
size_prompt1: equ $-prompt1
prompt2: db "Enter another string ", 0Ah
size_prompt2: equ $-prompt2
prompt3: db "Enter the word to replace with: ", 0Ah
size_prompt3: equ $-prompt3
result: db "The result is:", 0Ah
size_result: equ $-result
newline: db 0Ah

section .bss
array: resw 2000
array2: resw 2000
array3: resw 2000
temp: resw 1
length: resw 1
length2: resw 1
length3: resw 1
length4: resw 1
start1: resd 1
end1: resd 1
nol1: resw 1
nol2: resw 1
count: resw 1
num: resw 1
nod: resw 1

section .text
global _start

_start:

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;Printing the input prompt for string

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
mov word[length], 0

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
mov ecx, ebx
shl ecx, 5
mov edx, 0
add edx, ecx
inc word[length]
jmp reading

after_make_change:

mov ax, word[temp]
mov word[array+2*edx], ax
inc edx
inc word[length]
jmp reading

end_input1:

mov word[array+2*edx], 32

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;Test

;mov word[length3], 0
;mov ebx, 0
;mov ecx, ebx
;shl ecx, 5
;mov esi, array
;add esi, ecx
;mov dword[start1], esi
;mov edi, array3
;mov dword[end1], edi
;call stringCopy

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;Printing the string to see everything entered correctly

mov edx, 0
mov ebx, 0 
mov ecx, ebx
shl ecx, 5
add edx, ecx
mov word[count], 0

printing1:
mov ax, word[array+2*edx]
mov word[temp], ax
call print
inc word[count]
cmp word[temp], 32
jne nexting1

inc ebx
mov ecx, ebx
shl ecx, 5
mov edx, 0
add edx, ecx
dec edx

nexting1:
mov ax, word[length]
cmp ax, word[count]
je exit_printing1
inc edx
jmp printing1

exit_printing1:
;jmp exit

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;Printing the input prompt for second string

mov eax, 4
mov ebx, 1
mov ecx, prompt2
mov edx, size_prompt2
int 80h

;Reading the string

mov word[nol2], 0
mov edx, 0
mov ebx, 0 
mov ecx, ebx
shl ecx, 5
add edx, ecx
mov word[length2], 0

reading2:
call input

cmp word[temp], 10
je end_input2

cmp word[temp], 32
jne after_make_change2

inc word[nol2]
mov ax, word[temp]
mov word[array2+2*edx], ax
inc ebx
mov ecx, ebx
shl ecx, 5
mov edx, 0
add edx, ecx
inc word[length2]
jmp reading2

after_make_change2:

mov ax, word[temp]
mov word[array2+2*edx], ax
inc edx
inc word[length2]
jmp reading2

end_input2:

mov word[array2+2*edx], 32

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;Test

;mov ebx, 0
;mov ecx, ebx
;shl ecx, 5
;mov esi, array2
;add esi, ecx
;mov dword[start1], esi
;mov eax, dword[start1]

;call stringCopy




call one_more_compare

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;Printing the string to see everything entered correctly

mov edx, 0
mov ebx, 0 
mov word[count], 0
;mov ax, word[length3]
;mov word[num], ax
;call print_num

printing2:
mov ax, word[array3+2*edx]
mov word[temp], ax
call print
inc word[count]
;mov ax, word[count]
;mov word[num], ax
;call print_num
;call print_newline
;cmp word[temp], 32
;je exit_printing2

mov ax, word[length3]
cmp ax, word[count]
je exit_printing2
inc edx
jmp printing2

exit_printing2:
jmp exit

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;Printing the string to see everything entered correctly

mov eax, 4
mov ebx, 1
mov ecx, result
mov edx, size_result
int 80h

mov edx, 0
mov ebx, 0 
mov ecx, ebx
shl ecx, 5
add edx, ecx
mov word[count], 0

printing:
mov ax, word[array+2*edx]
mov word[temp], ax
call print
inc word[count]
cmp word[temp], 32
jne nexting

inc ebx
mov ecx, ebx
shl ecx, 5
mov edx, 0
add edx, ecx
dec edx

nexting:
mov ax, word[length]
cmp ax, word[count]
je exit_printing
inc edx
jmp printing

exit_printing:
jmp exit

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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;Function to input a string

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


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;Function to print a number

print:

pusha

mov eax, 4
mov ebx, 1
mov ecx, temp
mov edx, 1
int 80h

popa

ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;One more change to make compare
one_more_compare:

pusha

mov word[count], 0
mov dword[end1], array3
mov edi, array2
mov esi, array

mov edx, 0 
mov ecx, edx
shl ecx, 5
add edi, ecx

mov ebx, 0 
mov ecx, ebx
shl ecx, 5
add esi, ecx

traversing_one_more:
mov ax, word[edi]
cmp word[esi], ax
je next1
jl strcpyFirst
jg strcpySecond

next1:

cmp word[esi], 10
je strcpyFirst

cmp word[edi], 10
je strcpySecond

cmp word[esi], 32
je strcpyFirst

cmp word[edi], 32
je strcpySecond

jmp traversing_one_more

strcpyFirst:
mov esi, array
mov ecx, ebx
shl ecx, 5
add esi, ecx
mov dword[start1], esi
call stringCopy
inc ebx
mov esi, array
mov ecx, ebx
shl ecx, 5
add esi, ecx
jmp here

strcpySecond:
mov edi, array2
mov ecx, edx
shl ecx, 5
add edi, ecx
mov dword[start1], edi
call stringCopy
inc edx
mov edi, array2
mov ecx, edx
shl ecx, 5
add edi, ecx
jmp here

here:
cmp dx, word[nol2]
jne next_check

repeating:
cmp bx, word[nol1]
je exit_one_more_compare

mov dword[start1], esi
call stringCopy

mov 

inc ebx
mov esi, array
mov ecx, ebx
shl ecx, 5
add esi, ecx
jmp repeating

next_check:

cmp bx, word[nol1]
jne traversing_one_more

repeating2:
cmp dx, word[nol2]
je exit_one_more_compare

mov dword[start1], edi
call stringCopy
inc edx
mov edi, array2
mov ecx, edx
shl ecx, 5
add edi, ecx
jmp repeating2

exit_one_more_compare:

popa

ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;Function to replace the word
stringCopy:

pusha

mov esi, dword[start1] ;for array3
mov edi, dword[end1]
;mov ax, word[length3]
;mov word[num], ax
;call print_num

repeatingReplace:
mov ax, word[esi]
mov word[edi], ax
;mov word[temp], ax
;call print
;mov cx, word[edi]
;mov word[temp], cx
;call print
add esi, 2
add edi, 2
inc word[length3]
mov ax, word[length3]

cmp word[esi], 32
jne repeatingReplace

next_one:
mov word[edi], 32
inc word[length3]
;mov ax, word[length3]
;mov word[num], ax
;call print_num
add edi, 2
mov dword[end1], edi
;mov word[num], di
;call print_num

popa

ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;Function to print a number

print_num:

pusha

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