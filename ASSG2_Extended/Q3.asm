section .data
prompt1: db "Enter the size of array: "
size_prompt1: equ $-prompt1
prompt2: db "Enter the element: "
size_prompt2: equ $-prompt2
result: db "The mode of the elements is: "
size_result: equ $-result
newline: db 0Ah

section .bss
array: resb 100
array2: resb 100
temp: resb 1
temp1: resb 1
nod: resb 1
num: resb 1
max: resb 1
cmax: resb 1
sMax: resb 1
noe: resb 1
counter: resb 1

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
mov ax, word[num]
mov byte[noe], al
mov byte[counter], al

;Reading elements for the array
mov ebx, array

read:
push ebx

;Printing the message to print each element
mov eax, 4
mov ebx, 1
mov ecx, prompt2
mov edx, size_prompt2
int 80h

call input
mov ax, word[num]

;Adding the number to the array
pop ebx
mov byte[ebx], al
add ebx, 1
dec byte[counter]

cmp byte[counter], 0
jg read

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;Traversing through the elements of array to find the largest number
movzx ecx, byte[noe]
mov byte[cmax], 0
mov ebx, array

traverse:
mov al, byte[ebx]
cmp byte[cmax], al
jnl end_traverse
mov byte[cmax], al

end_traverse:
add ebx, 1
loop traverse

add byte[cmax], 1

;Printing the largest element cmax
;mov al, byte[cmax]
;mov byte[num], al
;call print 


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;Reading elements for the array
mov ebx, array2
mov ecx, array
mov al, byte[noe]
mov byte[counter], al

puttingZero:
mov byte[ebx], 0
add ebx, 1
dec byte[counter]

cmp byte[counter], 0
jg puttingZero

mov ebx, array2
mov ecx, array
mov al, byte[noe]
mov byte[counter], al

traversing:
mov eax, 0
mov al, byte[ecx]
inc byte[array2 + eax]
dec byte[counter]
add ecx, 1
cmp byte[counter], 0
jg traversing

;Printing the array

;mov ebx, array2
;mov al, byte[cmax]
;mov byte[counter], al

;go:
;mov al, byte[ebx]
;mov byte[num], al
;call print

;add ebx, 1
;dec byte[counter]

;cmp byte[counter], 0
;jg go

;Traversing to find the largest number in array2
movzx ecx, byte[cmax]
mov byte[sMax], 0
mov ebx, array2

traverse1:
mov al, byte[ebx]
cmp byte[sMax], al
jnl end_traverse1
mov byte[sMax], al

end_traverse1:
add ebx, 1
loop traverse1

;Printing sMax
;mov al, byte[sMax]
;mov byte[num], al
;call print

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;Printing the result

mov eax, 4
mov ebx, 1
mov ecx, result
mov edx, size_result
int 80h

mov edx, 0

repeating:
mov cl, byte[sMax]
cmp byte[array2 + edx], cl
jne next

mov byte[num], dl
call print
jmp exit

next:
add edx, 1
dec byte[cmax]

cmp byte[cmax], 0
jg repeating

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;System Exit
exit:
mov eax, 1
mov ebx, 0
int 80h


;Function to read a number
input:

pusha

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
popa

ret

;Function to print a number
print:

pusha

cmp byte[num], 0
jne extract

add byte[num], 30h

mov eax, 4
mov ebx, 1
mov ecx, num
mov edx, 1
int 80h

jmp end_print

extract:
cmp word[num], 0
je print_no
inc byte[nod]
mov dx, 0
mov ax, word[num]
mov bx, 10
div bx
push dx
mov word[num], ax
jmp extract

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

mov eax, 4
mov ebx, 1
mov ecx, newline
mov edx, 1
int 80h

popa

ret
