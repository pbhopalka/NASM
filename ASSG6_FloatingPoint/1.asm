section .data
	format1: db "%lf", 0
	format2: db "%lf", 10
	msg1: db "Enter a number: ", 0
	len1: equ $-msg1
	msg2: db "The sum is: ",0
	len2: equ $-msg2
	msg3: db "The difference is: ",0
	len3: equ $-msg3
	msg4: db "The product is: ",0
	len4: equ $-msg4

section .bss
	num: resb 1
	temp: resb 1
	float1: resq 1
	float2: resq 1
	float3: resq 1


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

	fstp qword[float1]

	mov eax, 4
	mov ebx, 1
	mov ecx, msg1
	mov edx, len1
	int 80h

	call read

	fstp qword[float2]

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;Adding;;;;;;;;;;;;;;;;;
	fld qword[float2]
	fld qword[float1]

	fadd ST1

	mov eax, 4
	mov ebx, 1
	mov ecx, msg2
	mov edx, len2
	int 80h

	call print
	ffree ST0
	ffree ST1

;;;;;;;;;;;;;;;;;;;;;;;;Subtracting;;;;;;;;;;;;;;;;;;;;;;;;

	fld qword[float2]
	fld qword[float1]

	fsub ST1

	mov eax, 4
	mov ebx, 1
	mov ecx, msg3
	mov edx, len3
	int 80h

	call print
	ffree ST0
	ffree ST1

;;;;;;;;;;;;;;;;;Multiplying;;;;;;;;;;;;;;;;;;;;;;;;;;;

	fld qword[float2]
	fld qword[float1]

	fmul ST1

	mov eax, 4
	mov ebx, 1
	mov ecx, msg4
	mov edx, len4
	int 80h

	call print
	ffree ST0
	ffree ST1

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

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
