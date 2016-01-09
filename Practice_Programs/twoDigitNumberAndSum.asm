Section .data
prompt: db 'Enter two digit number:'
length: equ $-prompt

Section .bss
digit1: resb 1
digit2: resb 1
digit3: resb 1
digit4: resb 1
num: resb 1
num1: resb 1
num2: resb 1
sum: resw 1

Section .text
global _start:

_start:

; Printing the prompt
mov eax, 4
mov ebx, 1
mov ecx, prompt
mov edx, length
int 80h

;Taking first digit as input
mov eax, 3
mov ebx, 0
mov ecx, digit1
mov edx, 1
int 80h

;Taking second digit as input
mov eax, 3
mov ebx, 0
mov ecx, digit2
mov edx, 2
int 80h

sub byte[digit1], 30h
sub byte[digit2], 30h

;Forming the two digit number
movzx ax, byte[digit1]
mov bl, 10
mul bl
movzx bx, byte[digit2]
add ax, bx
mov byte[num], al

;Calculating the sum
mov word[sum], 0
movzx cx, byte[num]

adding: 
add word[sum], cx

LOOP adding

;Assumung sum is a four-digit number
;Breaking it first into two 2-digit number
mov ax, word[sum]
mov bl, 100
div bl
mov byte[num1], al
mov byte[num2], ah

;Breaking the first 2-digit number
movzx ax, byte[num1]
mov bl, 10
div bl
mov byte[digit4], al
mov byte[digit3], ah

;Breaking the second 2- digit number
movzx ax, byte[num2]
mov bl, 10
div bl
mov byte[digit1], ah
mov byte[digit2], al

;Converting to ASCII

add byte[digit1], 30h
add byte[digit2], 30h
add byte[digit3], 30h
add byte[digit4], 30h

;Printing the first digit
mov eax, 4
mov ebx, 1
mov ecx, digit4
mov edx, 1
int 80h

;Printing the second digit
mov eax, 4
mov ebx, 1
mov ecx, digit3
mov edx, 1
int 80h

;Printing the third digit
mov eax, 4
mov ebx, 1
mov ecx, digit2
mov edx, 1
int 80h


;Printing the fourth digit
mov eax, 4
mov ebx, 1
mov ecx, digit1
mov edx, 1
int 80h

;Exit call
mov eax, 1
mov ebx, 0
int 80h

