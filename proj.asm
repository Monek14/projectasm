section	.text
	global	find
find:
	push	rbp	; save stack pointer
	mov	rbp, rsp; set up frame pointer
	
	; stored registers
	push	rbx
	push	r12
	push	r13
	push	r14
	
	; rdi contains bitmap ptr
	; rsi contains x ptr
	; rdx contains y ptr
	
	mov	r13, rsi
	mov	r14, rdx
	
	; find amount of padding
	mov	edx, [rdi+18]
	mov	eax, [rdi+18] ; load the width
	mov	r9d, eax ; store the width
	
	lea	edx, [edx*2+edx] ; times 3
	lea	eax, [eax*2+eax+3] ; times 3 plus 3
	
	xor	rbx, rbx
	and	eax, -4 ; clear last two bits
	sub	eax, edx
	mov	ebx, eax ; store padding amount
	
	mov	esi, [rdi+22] ; load the height
	
	xor	rax, rax
	mov	eax, [rdi+10] ; move ptr to pixel array
	add	rdi, rax
	
	mov	r11, 0
	mov	r12, -1
	mov	r8, 0	; boolean var if pixel was found
	
height_loop:
	
	mov	ecx, r9d ; width counter
	
width_loop:
	cmp	byte [rdi], 255
	jne	wrong_color
	
	cmp	byte [rdi+1], 255
	jne	wrong_color
	
	cmp	byte [rdi+2], 255
	jne	wrong_color
	
	; the current pixel is white
	
	cmp	esi, r12d
	ja	wrong_color	; not actually wrong color but this is not the pixel we are looking for (using unsigned comparison so that -1 is the max number representable by int)
	
	mov	r11d, ecx	; store x coord (counting from top left zero indexed)
	mov	r12d, esi	; store y coord (counting from top left one indexed)
	
	mov	r8d, 1 ; a matching pixel was found

	
wrong_color:

	add	rdi, 3 ; move to next pixel
	
	dec	ecx
	jnz	width_loop
	
	add	rdi, rbx ; step over padding
	
	dec	esi
	jnz	height_loop

	
	mov	eax, r8d ; return whether pixel was found
	cmp	eax, 0
	je	exit	; exit if not found
	
	sub	r9d, r11d
	
	dec	r12d		; make y coord zero indexed
	
	mov	[r13], r9d	; store x coord
	mov	[r14], r12d	; store y coord
	
exit:
	; restore registers
	pop	r14
	pop	r13
	pop	r12
	pop	rbx
	leave
	ret
