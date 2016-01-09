Section .data
prompt: db 'Enter a single digit: '
lPrompt: equ $-prompt
ast: db ' * '
lAst: equ $-ast
equal: db ' = '
lEqual: equ $-equal
new: db 0Ah
lNew: equ $-new

Section .bss
digit: resb 1
answer: resw 1
digit1: resb 1
digit2: resb 1
temp: resb 1
ldigit1: resb 1
ldigit2: resb 1

Section .text
global _start

_start:
;Printing the prompt
mov eax, 4
mov ebx, 1
mov ecx, prompt
mov edx, lPrompt
int 80h

;Reading the number
mov eax, 3
mov ebx, 0
mov ecx, digit
mov edx, 1
int 80h

sub byte[digit], 30h

call multiply

;System Exit
mov eax, 1
mov ebx, 0
int 80h

multiply:

mov eax, 0
mov ebx, 0
mov byte[temp], 0

for:
mov ax, word[answer]
add al, byte[digit]
inc ebx

pusha

mov word[answer], ax
mov ax, word[answer]
mov bl, 10
div bl

mov byte[digit1], al
mov byte[digit2], ah

pusha

;Printing the result

;Printing the digit
add byte[digit], 30h
mov eax, 4
mov ebx, 1
mov ecx, digit
mov edx, 1
int 80h

sub byte[digit], 30h

mov eax, 4
mov ebx, 1
mov ecx, ast
mov edx, lAst
int 80h

inc byte[temp]
movzx ax, byte[temp]
mov bl, 10
div bl
mov byte[ldigit1], al
mov byte[ldigit2], ah

cmp byte[ldigit1], 0
je print_sec

add byte[ldigit1], 30h
mov eax, 4
mov ebx, 1
mov ecx, ldigit1
mov edx, 1
int 80h

print_sec:
add byte[ldigit2], 30h
mov eax, 4
mov ebx, 1
mov ecx, ldigit2
mov edx, 1
int 80h

popa

mov eax, 4
mov ebx, 1
mov ecx, equal
mov edx, lEqual
int 80h

cmp byte[digit1], 0
je print_second

add byte[digit1], 30h
mov eax, 4
mov ebx, 1
mov ecx, digit1
mov edx, 1
int 80h

print_second:
add byte[digit2], 30h
mov eax, 4
mov ebx, 1
mov ecx, digit2
mov edx, 1
int 80h

mov eax, 4
mov ebx, 1
mov ecx, new
mov edx, lNew
int 80h

popa
cmp ebx, 10
jne for



ret
