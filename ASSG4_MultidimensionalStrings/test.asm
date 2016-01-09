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
array3: resw 100
temp: resw 1
length: resw 1
length2: resw 1
length3: resw 1
length4: resw 1
start1: resd 1
end1: resd 1
nol1: resw 1
count: resw 1

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

mov word[array+2*edx], 10

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;Test

mov esi, array
mov dword[start1], esi
mov edi, array2
mov dword[end1], edi
call stringCopy

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;Printing the string to see everything entered correctly

mov edx, 0
mov ebx, 0 
mov ecx, ebx
shl ecx, 5
add edx, ecx
mov word[count], 0

printing1:
mov ax, word[array2+2*edx]
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


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;Function to replace the word
stringCopy:

pusha



mov esi, dword[start1] ;for array3
mov edi, dword[end1]
movzx eax, word[esi]
mov word[temp], ax
call print

CLD



repeatingReplace:
MOVSW

cmp word[esi], 32
je next_one

cmp word[esi], 10
jne repeatingReplace

next_one:
mov word[edi], 32
inc edi
mov word[end1], di



popa

ret