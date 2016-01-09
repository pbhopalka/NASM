section .data
	starting: db "To remove all the characters in second string which are present in first string" ,0Ah, 0Ah
	size_starting: equ $-starting
	prompt1: db "Enter a string:", 0Ah
	size_prompt1: equ $-prompt1
	prompt2: db "Enter another string:", 0Ah
	size_prompt2: equ $-prompt2
	yes: db 0Ah, "The strings are anagrams.", 0Ah
	size_yes: equ $-yes
	no: db 0Ah, "The strings are not anagrams.", 0Ah
	size_no: equ $-no
	result: db 0Ah, "The result is:", 0Ah
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

;;;;;;;;;;;;;;;;;;;;;;;;;Printing the second prompt;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	mov eax, 4
	mov ebx, 1
	mov ecx, prompt2
	mov edx, size_prompt2
	int 80h

	call input_array
	mov byte[array2Length], 0
	mov esi, array
	mov edi, array2
	copying_array_array2:
		movzx eax, byte[esi]
		cmp byte[countOccurence1+eax], 0
			jg here 
		mov al, byte[esi]
		mov byte[edi], al
		inc edi
		inc byte[array2Length]
	here:
		inc esi
		cmp eax, 10
			jne copying_array_array2
	end_copying_array_array2:	
	
;;;;;;;;;;;;;;;;;;;;;;;;;''''''''''Printing the result;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	mov eax, 4
	mov ebx, 1
	mov ecx, result
	mov edx, size_result
	int 80h

	call print_array

;;;;;;;;;;;;;;;;;;;;;;;;;;;System Exit;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
exit:
	mov eax, 1
	mov ebx, 0
	int 80h

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;Functions;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


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
		mov esi, array2
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