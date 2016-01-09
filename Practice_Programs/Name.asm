Section .data
name: db "Piyush Bhopalka ", 0Ah
length: equ $-name
address: db "Kathmandu, Nepal", 0Ah
aLength: equ $-address

Section .bss

Section .text
global _start

_start:
;Printing the name
mov eax, 4
mov ebx, 1
mov ecx, name
mov edx, length
int 80h

;Printing the address
mov eax, 4
mov ebx, 1
mov ecx, address
mov edx, aLength
int 80h

;System Exit Call
mov eax, 1
mov ebx, 0
int 80h
