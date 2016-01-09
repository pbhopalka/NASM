Section .text
global _start:

_start:
;Printing the prompt
mov eax, 4
mov ebx, 1
mov ecx, prompt
mov edx, length
int 80h

;Taking the input (1 digit)
mov eax, 3
mov ebx, 1
mov ecx, digit
mov edx, 1
int 80h

;Converting the digit number into ASCII and saving in digit
sub byte[digit], 30h

;System call to exit
mov eax, 1
mov ebx, 0
int 80h

;Initialized Variables
Section .data
prompt: db 'Enter a digit:'
length: equ $-prompt

;Uninitialized Variable
Section .bss
digit: resb 1
