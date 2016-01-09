section .data
	p1: db "Enter x, y: "
	size_p1: equ $-p1
	result: db "The distance is: "
	size_result: equ $-result
	format1: db "%lf", 0
	format2: db "%lf", 10, 0

section .bss
	temp: resb 1
	nod: resb 1
	x1: resq 1
	y1: resq 1
	x2: resq 1
	y2: resq 1
	distance: resq 1	



section .text

global main
extern scanf
extern printf
fldz

main:
	mov eax, 4
	mov ebx, 1
	mov ecx, p1
	mov edx, size_p1
	int 80h

	call input_floating
	fstp qword[x1]
	
	call input_floating
	fstp qword[y1]

	mov eax, 4
	mov ebx, 1
	mov ecx, p1
	mov edx, size_p1
	int 80h
	
	call input_floating
	fstp qword[x2]

	call input_floating
	fstp qword[y2]

	fldpi
	call print_floating

	ffree ST0
	call distance1
	
	mov eax, 4
	mov ebx, 1
	mov ecx, result
	mov edx, size_result
	int 80h
	

	fld qword[distance]
	call print_floating
	
	




exit:
	mov eax, 1
	mov ebx, 0
	int 80h


distance1:
	pusha
	fld qword[x2]
	fsub qword[x1]
	fmul ST0
	fstp qword[x1]
	fld qword[y2]
	fsub qword[y1]
	fmul ST0
	fadd qword[x1]
	fsqrt 
	fstp qword[distance]
	popa
	ret

input_floating:
	push ebp
	mov ebp, esp
	sub esp, 8
	lea eax, [esp]
	push eax
	push format1
	call scanf
	fld qword[ebp-8]
	mov esp, ebp
	pop ebp
	ret


print_floating:
	push ebp
	mov ebp, esp
	sub esp, 8
	fst qword[ebp-8]
	push format2
	call printf
	mov esp, ebp
	pop ebp
	ret


