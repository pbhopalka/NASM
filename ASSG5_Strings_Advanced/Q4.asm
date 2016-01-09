section .data
	starting: db "To print the length of the longest repeating sequence" ,0Ah, 0Ah
	size_starting: equ $-starting
	prompt1: db "Enter a string:", 0Ah
	size_prompt1: equ $-prompt1
	prompt2: db "Enter another string:", 0Ah
	size_prompt2: equ $-prompt2
	yes: db 0Ah, "The strings are anagrams.", 0Ah
	size_yes: equ $-yes
	no: db 0Ah, "The strings are not anagrams.", 0Ah
	size_no: equ $-no
	result: db 0Ah, "The length of longest sub-sequence is:", 0Ah
	size_result: equ $-result
	countOccurence1: TIMES 200 db 0
	newline: db 0Ah

section .bss
	temp: resb 1
	array: resb 1000
	array1Length: resb 1
	array1: resb 1000
	array2Length: resb 1
	array2: resb 1000
	length: resb 1
	max: resb 1
	letter: resb 1


section .text
	global _start

	_start:

;;;;;;;;;;;;;;;;;;;;;;;;;;Program title;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	mov eax, 4
	mov ebx, 1
	mov ecx, starting
	mov edx, size_starting
	int 80h

;;;;;;;;;;;;;;;;;;;;;;;;;Printing the first prompt;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	mov eax, 4
	mov ebx, 1
	mov ecx, prompt1
	mov edx, size_prompt1
	int 80h

	call input_array
	mov byte[array1Length], 0
	mov esi, array
	mov edi, array1
	copying_array_array1:
		movzx eax, byte[esi]
		cmp eax, 10
			je end_copying_array_array1
		inc byte[countOccurence1+eax]
		MOVSB
		inc byte[array1Length]
		jmp copying_array_array1		
	end_copying_array_array1:
		mov byte[edi], 10

;;;;;;;;;;;;;;;;;;;;;;;;;;Traversing through the array;;;;;;;;;;;;;;;;;;;;;;;;;;;

	mov byte[length], 1
	mov byte[max], 0
	mov esi, 0
	mov al, byte[array1+esi]
	mov byte[letter], al
	mov ebx, esi
	outer_loop:
		mov al, byte[array1+esi]
		cmp al, 0
			je end_outer_loop
		traverse_to_check_letter:
			inc ebx
			cmp byte[array1+ebx], 0
				je increase_esi
			cmp al, byte[array1+ebx]
				je call_check_length
			jmp traverse_to_check_letter
		increase_esi:
			inc esi
			jmp outer_loop
	call_check_length:
		call check_length
		jmp traverse_to_check_letter
	end_outer_loop:

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;Printing the result;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	mov eax, 4
	mov ebx, 1
	mov ecx, result
	mov edx, size_result
	int 80h

	mov al, byte[max]
	mov byte[temp], al
	add byte[temp], 30h
	call print_character

;;;;;;;;;;;;;;;;;;;;;;;;;;;System Exit;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
exit:
	mov byte[temp], 10
	call print_character

	mov eax, 1
	mov ebx, 0
	int 80h

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;Functions;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

check_length:
	push eax
	mov byte[length], 0
	mov ecx, array1
	add ecx, esi
	mov edx, array1
	add edx, ebx
	mov edi, edx
	loop:
		mov al, byte[edx]
		cmp ecx, edi
			je end_loop
		cmp byte[ecx], al
			jne end_loop
		inc byte[length]
		inc ecx
		inc edx
		jmp loop
	end_loop:

		mov al, byte[length]
		cmp al, byte[max]
			jng leave_max
		mov byte[max], al
		mov al, byte[array+esi]
		mov byte[letter], al
	leave_max:
	pop eax
	ret


;;;;;;;;;;;;;;;;;;;;;;;;For inputting 1D array;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

input_array:
	pusha
		mov edi, array
		mov eax, 0
	reading_array:
		call input_character
		mov al, byte[temp]
		STOSB
		cmp byte[temp], 10
		jne reading_array
	end_reading_array:
	popa
	ret

;;;;;;;;;;;;;;;;;;;;;;;;For inputting 2D array;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

input_2D_array:
	pusha
		mov ebx, 0
		mov edx, ebx
		shl edx, 5
		mov edi, array
		add edi, edx
		CLD
	reading:
		call input_character
		cmp byte[temp], 10
			je end_input_array
		mov al, byte[temp]
		STOSB
		cmp byte[temp], 32
			je change_ebx
		jmp reading
	change_ebx:
		inc ebx
		mov edx, ebx
		shl edx, 5
		mov edi, array
		add edi, edx
		jmp reading
	end_input_array:
		mov byte[edi], 10
	popa
	ret

;;;;;;;;;;;;;;;;;;;;;;;;For printing the array;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

print_array:
	pusha
		mov esi, array1
	printing_array:
		LODSB
		mov byte[temp], al
		call print_character
		cmp byte[temp], 10
			jne printing_array
	end_printing_array:
	popa
	ret

;;;;;;;;;;;;;;;;;;;;;;;;For prinyting 2D array;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

print_2D_array:
	pusha
		mov ebx, 0
		mov edx, ebx
		shl edx, 5
		mov esi, array
		add esi, edx
		CLD
	printing:
		LODSB
		mov byte[temp], al
		call print_character
		cmp byte[temp], 10
			je end_printing
		cmp byte[temp], 32
			jne printing
		inc ebx
		mov edx, ebx
		shl edx, 5
		mov esi, array
		add esi, edx
		jmp printing
	end_printing:
	popa
	ret	



;;;;;;;;;;;;;;;;;;;;;;;;For taking a single character as an input;;;;;;;;;;;;;;;;;;

input_character:
	pusha
		mov eax, 3
		mov ebx, 0
		mov ecx, temp
		mov edx, 1
		int 80h
	popa
	ret

;;;;;;;;;;;;;;;;;;;;;;;;For printing a single character at a time;;;;;;;;;;;;;;;;;

print_character:
	pusha
		mov eax, 4
		mov ebx, 1
		mov ecx, temp
		mov edx, 1
		int 80h
	popa
	ret