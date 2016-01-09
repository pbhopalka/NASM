section .data
	format1: db "%lf", 0
	format2: db "%lf", 10
	msg1: db "Enter a radius: ", 0
	len1: equ $-msg1
	msg2: db "The perimeter is: ",0
	len2: equ $-msg2

section .bss
	num: resb 1
	temp: resb 1
	qnum: resd 1
	float1: resq 1
	float2: resq 1

section .text
	global main
	extern scanf
	extern printf
	fldz

	main:
	mov eax, 4
	mov ebx, 1
	mov ecx, msg1
	mov edx, len1
	int 80h

	call read

	fstp qword[float1]

;;;;;;;;;;;;;;;;;;;;;;;Multiplying 2*22;;;;;;;;;;;;;;;;;


	fld qword[float1]
	mov dword[qnum], 44
	fimul dword[qnum]
	mov dword[qnum], 7
	fidiv dword[qnum]




;;;;;;;;;;;;;;;;;Multiplying;;;;;;;;;;;;;;;;;;;;;;;;;;;

	mov eax, 4
	mov ebx, 1
	mov ecx, msg2
	mov edx, len2
	int 80h

	call print


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
