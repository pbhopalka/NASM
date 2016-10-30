Section .data
prompt: db "Enter a number: "
length: equ $-prompt
even: db 'Even', 0Ah
lEven: equ $-even
odd: db 'Odd', 0Ah
lOdd: equ $-odd

Section .bss
num: resw 1
temp: resb 2

Section .text
global _start:

_start:
;Printing the prompt
mov eax, 4
mov ebx, 1
mov ecx, prompt
mov edx, length
int 80h

call read_num
call print


;Exit call
mov eax, 1
mov ebx, 0
int 80h

;Function for reading input as number
read_num:
pusha  ;pushes the values of all registers to stack

mov word[num], 0

loopadd:
mov eax, 3
mov ebx, 0
mov ecx, temp
mov edx, 1
int 80h

cmp byte[temp], 10
je end_read

mov ax, word[num]
mov bx, 10
mul bx
sub byte[temp], 30h
mov bl, byte[temp]
mov bh, 0
add ax, bx
mov word[num], ax
jmp loopadd

end_read:
popa   ;restores the values of all registers from stack pushed earlier

ret

;Function to print
print:
pusha

mov dx, 0
mov ax, word[num]
mov bx, 2
div bx
cmp dx, 0
jz print_even

mov eax, 4
mov ebx, 1
mov ecx, odd
mov edx, lOdd
int 80h

jmp end_print

print_even:
mov eax, 4
mov ebx, 1
mov ecx, even
mov edx, lEven
int 80h

jmp end_print

end_print:
popa

ret



