section .data
	msg1:	db	"Enter Number of Elements ",
	msg1_len: equ	$-msg1
	msg2:	db	"The Numbers sorted are ",0Ah
	msg2_len: equ	$-msg2
	esize:	equ 8

section .bss
	rnum:	resw 1
	pnum:	resw 1
	temp:	resb 1
	nod:	resb 1

	num:	resw 1
	array: 	resw 50
	temparray: 	resw 50
	left:	resw 50
	right:	resw 50
	level:	resw 1
	lo: 	resw 1
	mid: 	resw 1
	hig:	resw 1
	n:		resw 1

section .text
	global _start

_start:
	mov eax, 4
	mov ebx, 1
	mov ecx, msg1
	mov edx, msg1_len
	int 80h
	
	call read_num
	mov word[n], ax
	
	mov edx, 0
	readingLoop:
		cmp dx, word[n]
		je endOfReadingLoop
		call read_num
		mov word[array+2*edx], ax
		inc edx
		jmp readingLoop
	endOfReadingLoop:
	
	mov word[level], 0
	mov word[left], 0
	mov ax, word[n]
	dec ax
	mov word[right], ax
	call mergeSort
	
	;Printing Elements of C
	mov eax, 4
	mov ebx, 1
	mov ecx, msg2
	mov edx, msg2_len
	int 80h
	
	mov edx, 0
	printingLoop:
		cmp dx, word[n]
		je endOfPrintingLoop
		mov ax, word[array+2*edx]
		call print_num
		call print_comma
		inc edx
		jmp printingLoop
	endOfPrintingLoop:
	
	call print_newline
	
	Exit:
	mov eax, 1
	mov ebx, 0
	int 80h
	
mergeSort:

	
	movzx ecx, word[level]
	mov ax, word[left+2*ecx]
	mov bx, word[right+2*ecx]
	cmp bx, ax
	jna return
	
	mov word[mid], ax
	add word[mid], bx
	shr word[mid], 1
	inc	word[level]
	inc ecx
	mov word[left+2*ecx], ax
	mov dx, word[mid]
	mov word[right+2*ecx], dx
	call mergeSort
	
	dec word[level]
	movzx ecx, word[level]
	mov ax, word[left+2*ecx]
	mov bx, word[right+2*ecx]
	mov word[mid], bx
	add word[mid], ax
	shr word[mid], 1
	inc word[mid]
	inc	word[level]
	inc ecx
	mov dx, word[mid]
	mov word[left+2*ecx], dx
	mov word[right+2*ecx], bx
	call mergeSort
	
	dec word[level]
	movzx ecx, word[level]
	mov ax, word[left+2*ecx]
	mov bx, word[right+2*ecx]
	mov word[mid], bx
	add word[mid], ax
	shr word[mid], 1
		
	call merge
	
	return:
	ret
	
merge:
	movzx ecx, word[level]
	mov ax, word[left+2*ecx]
	mov bx, word[right+2*ecx]
	mov word[lo], ax 
	mov word[hig], bx
	mov word[num], bx
	inc word[num]
	movzx edx, ax
	copyingLoop:
		cmp dx, word[num]
		je endOfcopyingLoop
		mov cx, word[array+2*edx]
		mov word[temparray+2*edx], cx
		inc edx
		jmp copyingLoop
	endOfcopyingLoop:
	
	;call print_newline
	
	movzx ecx, word[level]
	movzx eax, word[left+2*ecx]
	movzx ebx, word[right+2*ecx]
	mov edx, eax
	add ebx, eax
	shr ebx, 1
	mov word[mid], bx
	inc ebx
	mergingLoop:
		cmp dx, word[num]
		je endOfmergingLoop
		cmp ax, word[mid]
		jna else1
			
			mov cx, word[temparray+2*ebx]
			mov word[array+2*edx], cx
			inc ebx
			jmp next
		else1:
		cmp bx, word[hig]
		jna else2
		
			mov cx, word[temparray+2*eax]
			mov word[array+2*edx], cx
			inc eax
			jmp next
		else2:
		mov cx, word[temparray+2*eax]
		cmp word[temparray+2*ebx], cx
		jnb else3
			
			mov cx, word[temparray+2*ebx]
			mov word[array+2*edx], cx
			inc ebx
			jmp next
		else3:
		
			mov cx, word[temparray+2*eax]
			mov word[array+2*edx], cx
			inc eax
			jmp next
		next:
	
		inc edx
		jmp mergingLoop
	endOfmergingLoop:
	ret

read_num:
	pusha
	mov word[rnum], 0
	loop_read:
		mov eax, 3
		mov ebx, 0
		mov ecx, temp
		mov edx, 1
		int 80h
	
		cmp byte[temp], 0Ah
		je end_read
		cmp byte[temp], 20h
		je end_read
	
		mov ax, word[rnum]
		mov bx, 10
		mul bx
		mov bl, byte[temp]
		sub bl, 30h
		mov bh, 0
		add ax, bx
		mov word[rnum], ax
		jmp loop_read
	
	end_read:
		popa
		mov ax,word[rnum]
		ret
		

print_num:
	pusha
	cmp ax, 0
	je print_Zero
	mov word[pnum], ax
	mov byte[nod], 0
	extract_no:
		cmp word[pnum], 0
		je print_no
		inc byte[nod]
		mov dx, 0
		mov ax, word[pnum]
		mov bx, 10
		div bx
		
		push dx
		mov word[pnum], ax
		jmp extract_no
	
	print_no:
		cmp byte[nod], 0
		je end_print
		dec byte[nod]
		pop dx
		mov byte[temp], dl
		add byte[temp], 30h
		
		mov eax, 4
		mov ebx, 1
		mov ecx, temp
		mov edx, 1
		int 80h
		
		jmp print_no
		
	end_print:
		popa
		ret
		
	print_Zero:
		mov byte[temp], 30h
		mov eax, 4
		mov ebx, 1
		mov ecx, temp
		mov edx, 1
		int 80h
		popa
		ret
		
		
		
print_newline:
	pusha
	mov byte[temp], 0Ah
	mov eax, 4
	mov ebx, 1
	mov ecx, temp
	mov edx, 1
	int 80h
	popa
	ret
		
print_comma:
	pusha
	mov byte[temp], 2Ch
	mov eax, 4
	mov ebx, 1
	mov ecx, temp
	mov edx, 1
	int 80h
	mov byte[temp], 20h
	mov eax, 4
	mov ebx, 1
	mov ecx, temp
	mov edx, 1
	int 80h
	popa
	ret
