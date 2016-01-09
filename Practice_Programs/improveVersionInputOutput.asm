Section .data

Section .bss
num: resw 1
nod: resb 1
temp: resb 2

Section .data
global _start:

_start:

call read_num
call print_num

;Exit call
mov eax, 1
mov ebx, 0
int 80h

;Function to read the number
read_num:

pusha
mov word[num], 0

loop_read:
mov eax, 3
mov ebx, 0
mov ecx, temp
mov edx, 1
int 80h

cmp byte[temp], 10 ;10 is the ASCII for new line
je end_read

mov ax, word[num]
mov bl, 10
mul bl

sub byte[temp], 30h

movzx bx, byte[temp]
add ax, bx
mov word[num], ax
jmp loop_read

end_read:
popa

ret

;Function to print the stored number
print_num:
pusha

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
mov byte[temp], dl
add byte[temp], 30h

mov eax, 4
mov ebx, 1
mov ecx, temp
mov edx, 1
int 80h

jmp print_no

end_print:
popa

ret
