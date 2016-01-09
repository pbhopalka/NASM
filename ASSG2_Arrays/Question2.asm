section .data
prompt1: db "Enter the size of array: "
size_prompt1: equ $-prompt1
prompt2: db 0Ah, "Enter the element: "
size_prompt2: equ $-prompt2
result: db 0Ah, "After sorting the array is:", 0Ah
size_result: equ $-result
newline: db 0Ah
space: db 32

section .bss
temp: resb 1
temp1: resb 1
nod: resb 1
noe: resb 1
counter: resb 1
num:	resw 1
array: 	resw 50
temparray: 	resw 50
left:	resw 50
right:	resw 50
pos:	resw 1
low: 	resw 1
mid: 	resw 1
high:	resw 1

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
mov ebx, 0

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
mov word[array + 2 * ebx], ax
add ebx, 1
dec byte[counter]

cmp byte[counter], 0
jg read

;Calling mergesort
mov word[pos], 0
mov word[left], 0
movzx ax, byte[noe]
dec ax
mov word[right], ax
call mergeSort

;Printing the result

pusha
mov eax, 4
mov ebx, 1
mov ecx, result
mov edx, size_result
int 80h
popa

movzx ax, byte[noe]
mov byte[counter], al
mov ebx, 0

traverse:

;Printing the number
mov ax, word[array + 2 * ebx]
mov word[num], ax
call print

push ebx

mov eax, 4
mov ebx, 1
mov ecx, space
mov edx, 1
int 80h

pop ebx

add ebx, 1
dec byte[counter]
cmp byte[counter], 0
jne traverse


;System Exit
mov eax, 1
mov ebx, 0
int 80h


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;Functions

mergeSort:

	
movzx ecx, word[pos]
mov ax, word[left+2*ecx]
mov bx, word[right+2*ecx]
cmp bx, ax
jna return
	
mov word[mid], ax
add word[mid], bx
shr word[mid], 1
inc	word[pos]
inc ecx
mov word[left+2*ecx], ax
mov dx, word[mid]
mov word[right+2*ecx], dx
call mergeSort
	
dec word[pos]
movzx ecx, word[pos]
mov ax, word[left+2*ecx]
mov bx, word[right+2*ecx]
mov word[mid], bx
add word[mid], ax
shr word[mid], 1
inc word[mid]
inc	word[pos]
inc ecx
mov dx, word[mid]
mov word[left+2*ecx], dx
mov word[right+2*ecx], bx
call mergeSort

dec word[pos]
movzx ecx, word[pos]
mov ax, word[left+2*ecx]
mov bx, word[right+2*ecx]
mov word[mid], bx
add word[mid], ax
shr word[mid], 1
	
call merge
	
return:

ret
	
merge:

movzx ecx, word[pos]
mov ax, word[left+2*ecx]
mov bx, word[right+2*ecx]
mov word[low], ax 
mov word[high], bx
mov word[num], bx
inc word[num]
movzx edx, ax

cop:
cmp dx, word[num]
je endCop
mov cx, word[array+2*edx]
mov word[temparray+2*edx], cx
inc edx
jmp cop
endCop:
	
movzx ecx, word[pos]
movzx eax, word[left+2*ecx]
movzx ebx, word[right+2*ecx]
mov edx, eax
add ebx, eax
shr ebx, 1
mov word[mid], bx
inc ebx

merging:
cmp dx, word[num]
je end_merge
cmp ax, word[mid]
jna else1
			
mov cx, word[temparray+2*ebx]
mov word[array+2*edx], cx
inc ebx
jmp next

else1:
cmp bx, word[high]
jna else2
	
mov cx, word[temparray+2*eax]
mov word[array+2*edx], cx
inc eax
jmp next

else2:
mov cx, word[temparray+2*eax]
cmp word[temparray+2*ebx], cx
jnb else3
			
mov cx, word[temparray+2*ebx]
mov word[array+2*edx], cx
inc ebx
jmp next

else3:
		
mov cx, word[temparray+2*eax]
mov word[array+2*edx], cx
inc eax
jmp next

next:
	
inc edx
jmp merging

end_merge:

ret

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

popa

ret
