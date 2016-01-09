section .data
	format1: db "%lf", 0
	format2: db "%lf", 10
	msg1: db "Enter Number of elements :",0Ah
	len1: equ $-msg1
	msg2: db "Enter array :",0Ah
	len2: equ $-msg2
	msg3: db "Sorted array :",0Ah
	len3: equ $-msg3

section .bss
	array: resq 100
	num: resw 1
	length: resw 1
	temp: resb 1

section .text
	global main:
	extern scanf
	extern printf

	main:
		mov eax, 4
		mov ebx, 1
		mov ecx, msg1
		mov edx, len1
		int 80h
	call input
	cmp word[num], 0
	je exit
	mov ax, word[num]
	mov word[length], ax

	mov eax, 4
	mov ebx, 1
	mov ecx, msg2
	mov edx, len2
	int 80h
	;fldz
	call take_array_input

	mov eax, 4
	mov ebx, 1
	mov ecx, msg3
	mov edx, len3
	int 80h

;;;;;;;;;;;;;;;;;;;;;Calling the sort function

	call sort

;;;;;;Printing the sorted array

	call print_array

exit:
	mov eax, 1
	mov ebx, 0
	int 80h   

;;;;;;;;;;;;;;;;;;;;function to read floating point......

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

;;;;;;;;;;;;;Store elements in an array;;;;;;;;;;;;;;

take_array_input:
	pusha
	mov esi, 0
	taking:
		cmp si, word[length]
		je end_taking  
		call read
		fstp qword[array + esi*8]
		inc esi
	jmp taking
	end_taking:
	popa
	ret

;;;;;;;;;;;;Print array;;;;;;;;;;;;;;;;;;;;;

print_array:
	pusha
	mov esi, 0
	printing:
		cmp si, word[length]
		je end_printing  
		fld qword[array + esi*8]
		call print
		ffree ST0
		inc esi
		jmp printing
	end_printing:
	popa
	ret

;;;;;;;;;;;Sorting;;;;;;;;;;;;;;;;;;;

sort:
	pusha
	mov edi, 0
	loop1:
		mov esi, 0
		movzx eax, word[length]
		sub eax, edi
		sub eax, 1
		loop2:
			push eax
			fld qword[array + 8*esi]
			fld qword[array + 8*esi + 8]
			fcom ST1	
			fstsw ax
			sahf
			jb swap
			jmp cont1
		swap:
			fstp qword[array + 8*esi]
			fstp qword[array + 8*esi + 8]
			jmp cont
		cont1:
			ffree ST0
			ffree ST1
		cont:
			pop eax
			add esi, 1
			cmp esi, eax
			jl loop2 ;;;loop2 ends
		add edi, 1
		movzx eax, word[length] 
		cmp edi, eax
		jl loop1 ;;; loop1 ends
	popa
	ret

;;;;;;;;;;;;;;;Taking an integer input from the user
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
		mov bh, 0
		mov bl, byte[temp]
		add ax, bx
		mov word[num], ax
	jmp loopadd
	end_read:
	popa
	ret

