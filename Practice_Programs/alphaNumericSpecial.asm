Section .data
prompt: db 'Enter a keystroke '
length: equ $-prompt
alpha: db 'Alphabet', 0Ah
lAlpha: equ $-alpha
num: db 'Number', 0Ah
lNum: equ $-num
special: db 'Special Character', 0Ah
lSpecial: equ $-special
  
Section .bss
data: resb 1

Section .text
global _start

_start:

;Printing the prompt
mov eax, 4
mov ebx, 1
mov ecx, prompt
mov edx, length
int 80h

;Reading the input
mov eax, 3
mov ebx, 0
mov ecx, data
mov edx, 1
int 80h

cmp byte[data], 'A'-1
jng next_alpha
cmp byte[data], 'Z'+1
jnl next_alpha
jmp print

next_alpha:
cmp byte[data], 'a'-1
jng next_check
cmp byte[data], 'z'+1
jnl next_check
jmp print

print:
mov eax, 4
mov ebx, 1
mov ecx, alpha
mov edx, lAlpha
int 80h
jmp system_exit

next_check:
cmp byte[data], '0'-1
jng print_special
cmp byte[data], '9'+1
jnl print_special
jmp print_no

print_no:
mov eax, 4
mov ebx, 1
mov ecx, num
mov edx, lNum
int 80h
jmp system_exit

print_special:
mov eax, 4
mov ebx, 1
mov ecx, special
mov edx, lSpecial
int 80h
jmp system_exit

;Exit System Call
system_exit:
mov eax, 1
mov ebx, 0
int 80h
