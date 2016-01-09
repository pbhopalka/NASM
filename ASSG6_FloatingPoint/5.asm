section .data
	format1: db "%lf", 0
	format2: db "%lf", 10, 0
	msg1: db "Enter x:", 0Ah
	len1: equ $-msg1
	msg2: db "Enter n:", 0Ah
	len2: equ $-msg2
	msg3: db "Sum:", 0Ah
	len3: equ $-msg3
	msg4: db "Value of cos(x) by processor:", 0Ah
	len4: equ $-msg4

section .bss
	num: resw 1
	a: resd 1
	x: resq 1
	n: resw 1
	f: resq 1
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
	mov eax, 4
	mov ebx, 1
	mov ecx, msg2
	mov edx, len2
	int 80h

	call input
	mov ax, word[num]
	mov word[n], ax 
	cmp word[n], 0
	je exit

	call cosx
	fld qword[sum]

	mov eax, 4
	mov ebx, 1
	mov ecx, msg3
	mov edx, len3
	int 80h

	call print

	ffree ST0
	fld qword[x]

	fcos ;;;;Using inbuilt cos function

	mov eax, 4
	mov ebx, 1
	mov ecx, msg4
	mov edx, len4
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

cosx:
	mov dword[a], 1
	fild dword[a]
	fst qword[sum]
	fstp qword[f]
	mov esi, 1
	mov dword[a], esi
	loop1:
		cmp si, word[n]
		je end_loop1
		fld qword[f]
		fmul qword[x]
		fmul qword[x]
		fidiv dword[a]
		inc dword[a]
		fidiv dword[a]
		fchs
		fst qword[f]
		fld qword[sum]
		fadd ST1
		fstp qword[sum]
		ffree ST0
		inc dword[a]
		inc esi
	jmp loop1
	end_loop1:
	ret

;;;;;;;;;;;;;;;;;;Function to input a number;;;;;;;;;;;;;
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
