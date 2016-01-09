section .data
prompt1: db "Enter a number: "
size_prompt1: equ $-prompt1
prompt2: db "Enter another number: "
size_prompt2: equ $-prompt2
result: db 0Ah, "The difference of second from first number is: "
size_result: equ $-result
result_negative: db 0Ah, "The difference of second from first number is: -"
size_result_negative: equ $-result_negative
newline: db 0Ah

section .bss
number1: resd 1
number2: resd 1
num: resd 1
temp: resb 1
nod: resd 1

section .text
global _start

_start:

;Printing the first prompt
mov eax, 4
mov ebx, 1
mov ecx, prompt1
mov edx, size_prompt1
int 80h

call input
mov eax, dword[num]
mov dword[number1], eax ;Storing the first number in number1

;Printing the second prompt
mov eax, 4
mov ebx, 1
mov ecx, prompt2
mov edx, size_prompt2
int 80h

call input
mov eax, dword[num]
mov dword[number2], eax ;Storing the second number in number2

mov ebx, dword[number1]

cmp eax, ebx
jg negative

sub ebx, eax
mov dword[num], ebx

;Printing the result prompt
mov eax, 4
mov ebx, 1
mov ecx, result
mov edx, size_result
int 80h

call print
jmp exit

negative:
sub eax, ebx
mov dword[num], eax

;Printing the result prompt
mov eax, 4
mov ebx, 1
mov ecx, result_negative
mov edx, size_result_negative
int 80h

call print
jmp exit


;System Exit
exit:
mov eax, 1
mov ebx, 0
int 80h

;;;;;;;;;;;;;;;;; Function to input a number

input:

pusha

mov dword[num], 0

loopadd: 
mov eax, 3
mov ebx, 0
mov ecx, temp
mov edx, 1
int 80h

cmp byte[temp], 10
je end_input


mov eax, dword[num]
mov ebx, 10
mul ebx
sub byte[temp], 30h
mov ebx, 0
mov bl, byte[temp]
add eax, ebx
mov dword[num], eax
jmp loopadd

end_input:
popa

ret


;;;;;;;;;;;;;;;;; Function to print a number

print:

pusha

extract:
cmp dword[num], 0
je print_number
inc dword[nod]
mov edx, 0
mov eax, dword[num]
mov ebx, 10
div ebx
push edx
mov dword[num], eax
jmp extract

print_number:
cmp dword[nod], 0
je end_print
dec dword[nod]
pop edx
mov byte[temp], dl
add byte[temp], 30h

mov eax, 4
mov ebx, 1
mov ecx, temp
mov edx, 1
int 80h

jmp print_number

end_print:

mov eax, 4
mov ebx, 1
mov ecx, newline
mov edx, 1
int 80h

popa

ret
