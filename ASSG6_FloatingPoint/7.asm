section .data
	format1: db "%lf", 0
	format2: db "%lf", 10, 0
	msg1: db "Enter x:", 0Ah
	len1: equ $-msg1
	msg2: db "Answer is: "
	len2: equ $-msg2

section .bss
	num: resd 1
	x: resq 1
	ans: resq 1

section .text
	global main
	extern scanf
	extern printf

	main:
;;Enter a floating point number
	mov eax, 4
	mov ebx, 1
	mov ecx, msg1
	mov edx, len1
	int 80h

	call read

	fst qword[x]
	fld qword[x]
	fmul ST1
	fmul ST1
	fstp qword[ans] ;x^3 done
	fld qword[x]
	fmul ST0 
	fld qword[ans] 
	fadd ST1
	fstp qword[ans] ;x^2 done
	fld qword[x]
	mov dword[num], 5
	fimul dword[num]
	fld qword[ans]
	fsub ST1
	fstp qword[ans] ;5x subtracted
	mov dword[num], 9
	fild dword[num]
	fld qword[ans]
	fadd ST1
	fstp qword[ans] ;9 added
	fld qword[ans]

	mov eax, 4
	mov ebx, 1
	mov ecx, msg2
	mov edx, len2
	int 80h

	call print

exit:
	mov eax, 1
	mov ebx, 0
	int 80h   

;;;;;;;;;;;;;;;;;;;;function to read floating point
read:
	push ebp
	mov ebp, esp
	sub esp, 8
	lea eax, [esp]
	push eax
	push format1
	call scanf
	fld qword[ebp - 8]
	mov esp, ebp
	pop ebp
	ret

;;;;;;;;;;;;;;;function to print floating point.........

print:
	push ebp
	mov ebp, esp
	sub esp, 8
	fst qword[ebp - 8]
	push format2
	call printf
	mov esp, ebp
	pop ebp
	ret
