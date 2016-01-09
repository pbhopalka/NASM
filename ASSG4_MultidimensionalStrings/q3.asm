section .data
prompt1: db "Enter a string: ", 0Ah
size_prompt1: equ $-prompt1
prompt2: db "Enter the word to be searched: ", 0Ah
size_prompt2: equ $-prompt2
prompt3: db "Enter the word to replace with: ", 0Ah
size_prompt3: equ $-prompt3
result: db "The result is:", 0Ah
size_result: equ $-result
newline: db 0Ah

section .bss
array: resw 2000
array2: resw 100
array3: resw 100
array4: resw 1000
array5: resw 100
temp: resw 1
length: resw 1
length2: resw 1
length3: resw 1
length5: resw 1
nol: resw 1
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

mov word[nol], 0
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

inc word[nol]
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

mov word[array+2*edx], 10

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;Printing the input prompt for word to search

mov eax, 4
mov ebx, 1
mov ecx, prompt2
mov edx, size_prompt2
int 80h

;Reading the string

mov esi, 0
mov word[length2], 0

reading2:
call input

cmp word[temp], 10
je end_input2

mov ax, word[temp]
mov word[array2+2*esi], ax
inc esi
inc word[length2]
jmp reading2

end_input2:

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;Printing the input prompt for word to replace

mov eax, 4
mov ebx, 1
mov ecx, prompt3
mov edx, size_prompt3
int 80h

;Reading the word

mov esi, 0
mov word[length3], 0

reading3:
call input

cmp word[temp], 10
je end_input3

mov ax, word[temp]
mov word[array3+2*esi], ax
inc esi
inc word[length3]
jmp reading3

end_input3:


call one_more_compare


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
mov edx, 0
mov esi, 0
mov ebx, 0 
mov ecx, ebx
shl ecx, 5
add edx, ecx

traversing_one_more:
mov ax, word[array+2*edx]
;mov word[temp], ax
;call print
cmp word[array2+2*esi], ax
jne here

inc edx
inc esi


cmp word[array+2*edx], 32
je here_another

cmp word[array+2*edx], 10
jne traversing_one_more

here_another:
cmp si, word[length2]
jne here


;mov edx, 0

;printing2:
;mov ax, word[array+2*edx]
;mov word[temp], ax
;call print
;inc edx
;cmp dx, word[length]
;jne printing2

mov edx, 0
call replaceHere
mov ax, word[length2]
sub word[length], ax
mov ax, word[length3]
add word[length], ax
jmp exit_one_more_compare

here:
inc ebx
mov ecx, ebx
shl ecx, 5
mov edx, 0
add edx, ecx
mov esi, 0

cmp bx, word[nol]
jng traversing_one_more

exit_one_more_compare:

popa

ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;Function to replace the word
replaceHere:

mov esi, 0
add edx, ecx
mov word[count], 0

repeatingReplace:
mov ax, word[array3+2*esi]
mov word[array+2*edx], ax
;mov word[temp], ax
;call print
inc esi
inc edx
inc word[count]
mov ax, word[length3]
cmp ax, word[count]
jne repeatingReplace

mov word[array+2*edx], 32
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