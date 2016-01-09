section .data
	format1: db "%lf", 0
	format2: db "%lf", 10, 0
	msg1: db "Enter x :", 0Ah
	len1: equ $-msg1
	msg2: db "Enter n :", 0Ah
	len2: equ $-msg2
	msg3: db "Sum :", 0Ah
	len3: equ $-msg3

section .bss
	num: resw 1
	f: resq 1
	a: resd 1
	x: resq 1
	n: resw 1
	sum: resq 1
	temp: resb 1

section .text
	global main:
	extern scanf
	extern printf
	main:
;;Enter x
		mov eax, 4
		mov ebx, 1
		mov ecx, msg1
		mov edx, len1
		int 80h

	call read
	fstp qword[x]

;; Enter n

	;call input
	;mov ax, word[num]
	mov word[n], 10000
	cmp word[n], 0
	je exit

	call taylorSeries

	fld qword[sum]

	mov eax, 4
	mov ebx, 1
	mov ecx, msg3
	mov edx, len3
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



;;;;;;;;;;;;;;;;function to calculate taylor series sum

taylorSeries:
	mov dword[a], 1
	fild dword[a]
	fst qword[sum]
	fstp qword[f]
	mov esi, 1
	loop1:
		cmp si, word[n]
		jg end_loop1
		mov dword[a], esi
		fld qword[f]
		fmul qword[x]
		fidiv dword[a]
		fst qword[f]
		fld qword[sum]
		fadd ST1	
		fstp qword[sum]
		ffree ST0
		inc esi
		jmp loop1
	end_loop1:
	ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;	      function to read a number and store in num         ;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

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
		je end_input
		mov ax, word[num]
		mov bx, 10
		mul bx
		sub byte[temp], 30h
		mov bh, 0
		mov bl, byte[temp]
		add ax, bx
		mov word[num], ax
	jmp loopadd
	end_input:
	popa
	ret