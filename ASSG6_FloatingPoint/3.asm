section .data
	format1: db "%lf", 0
	format2: db "%lf", 10
	msg1: db "Enter a: ", 0
	len1: equ $-msg1
	msg2: db "Enter b: ",0
	len2: equ $-msg2
	msg3: db "Enter c: ",0
	len3: equ $-msg3
	res1: db "The root1 is: ",0
	reslen1: equ $-res1
	res2: db "The root2 is: ", 0
	reslen2: equ $-res2
	res3: db "It has imaginary part", 0
	reslen3: equ $-res3

section .bss
	num: resd 1
	temp: resb 1
	a: resq 1
	b: resq 1
	c: resq 1
	root1: resq 1
	root2: resq 1
	temp1: resq 1


section .text
	global main
	extern scanf
	extern printf

	main:
	mov eax, 4
	mov ebx, 1
	mov ecx, msg1
	mov edx, len1
	int 80h

	call read

	fstp qword[a]

	mov eax, 4
	mov ebx, 1
	mov ecx, msg2
	mov edx, len2
	int 80h

	call read

	fstp qword[b]

	mov eax, 4
	mov ebx, 1
	mov ecx, msg3
	mov edx, len3
	int 80h

	call read

	fstp qword[c]
	

;;;;;;;;;;;;;;;;;;;;;;;;Subtracting;;;;;;;;;;;;;;;;;;;;;;;;

	fld qword[b]
	fmul ST0					;;;b^2
	fstp qword[temp1]
	fld qword[a]
	fld qword[c]
	mov dword[num], 4
	fimul dword[num]
	fmul ST1
	fld qword[temp1]
	fsub ST1
	fstp qword[temp1]
	ffree ST0
	ffree ST1

	fldz 
	fcomp qword[temp1]

	fstsw ax
	sahf

	jna continue
	mov eax, 4
	mov ebx, 1
	mov ecx, res3
	mov edx, reslen3
	int 80h
	jmp exit

	continue:
		fld qword[temp1]
		fsqrt
		fstp qword[temp1]
		fld qword[b] 
		fchs ;;;;;;;;;;;;Making b negative

		fld qword[temp1]   ;;
		fadd ST1

		mov dword[num], 2
		fidiv dword[num]
		fdiv qword[a]	
		fstp qword[root1]
		ffree ST0

		fld qword[b]       ;;;;;
		fchs
		fld qword[temp1]   ;;
		fchs
		fadd ST1
		mov dword[num], 2
		fidiv dword[num]
		fdiv qword[a]
		fstp qword[root2]
		ffree ST0
		fld qword[root1]

	mov eax, 4
	mov ebx, 1
	mov ecx, res1
	mov edx, reslen1	
	int 80h

	call print

	fld qword[root2]

	mov eax, 4
	mov ebx, 1
	mov ecx, res2
	mov edx, reslen2
	int 80h

	call print

	exit:
	mov eax, 1
	mov ebx, 0
	int 80h   

;;;;;;;;;;;;;;;;;;;;;;;;;;Functions;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

print:
	push ebp
	mov ebp, esp
	sub esp, 8
	fst qword[ebp-8]
	push format2
	call printf
	mov esp, ebp
	pop ebp
	ret

read:
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

input:
	pusha
	mov byte[num], 0
	loopadd:
		mov eax, 3
		mov ebx, 0
		mov ecx, temp
		mov edx, 1
		int 80h
		cmp byte[temp], 10
		je end_read
		mov ax, 0
		mov al, byte[num]
		mov bx, 10
		mul bx
		sub byte[temp], 30h
		mov bl, byte[temp]
		mov bh, 0
		add ax, bx
		mov byte[num], al
	jmp loopadd
	end_read:
	popa
	ret
