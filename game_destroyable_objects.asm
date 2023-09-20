;original code - Rafaelle Cecco (c) 1987
;disassembled by Sergey Erokhin aka ESL - Nov-Dec 2014
;eslexolon@gmail.com
;https://bitbucket.org/esl/exolon-zx/
;licensed under a Creative Commons Attribution Share-Alike 3.0 (CC-BY-SA 3.0)

chk_destroy_oblect:
;		ld	a, e
;		and	7Ch ; '|'
;		rrca
;		rrca
;		ld	e, a
;		ld	a, d
;		and	0F8h ; 'ø'
;		rrca
;		rrca
;		rrca
;		ld	d, a
;
;		ld	hl, destroyableBuffer
chk_destoyable_loop:
;		ld	a, (hl)			; x_from
;		cp	0FFh
;		ret	z
;
;		cp	80h			; already destroyed flag
;		push	hl
;		jr	z, chk_next_destoyable
;
;		ld	a, e
;		cp	(hl)			; x_from
;		inc	hl
;		jr	c, chk_next_destoyable
;
;		cp	(hl)			; x_to
;		inc	hl
;		jr	nc, chk_next_destoyable
;
;		ld	a, d
;		cp	(hl)			; y_from
;		inc	hl
;		jr	c, chk_next_destoyable

;		cp	(hl)			; y_to
;		inc	hl
;		jr	nc, chk_next_destoyable
;
;		ld	e, (hl)			; x
;		inc	hl
;		ld	d, (hl)			; y
;		inc	hl
;		ld	a, (hl)			; block_id
;
;		ld	bc, xZoneBlock
;		call	get_hl_a_BC
;
;		ld	a, pch_PutCharXorRemoveObject_2boom	;3
;		call	selectPutCHR
;		call	xMSG		; C - color
;					; HL - PRE
;					; E-X
;					; D-Y
;		xor	a
;		call	selectPutCHR
;
;		pop	hl
;		ld	(hl), 80h		; set already destroyed flag
;
;		call	snd_first_first_gun
;		ld	de,  a000150+5
;		jp	addPoints
; ---------------------------------------------------------------------------

chk_next_destoyable:
;		pop	hl
;		ld	bc, 7
;		add	hl, bc
;		jr	chk_destoyable_loop

; ---------------------------------------------------------------------------
destroyableBuffer:
		db 11*7+3 dup (?);  		;bug?? +3 ??????
;; 		destroyableStruct <0>
;; 		db    0
;;		db    0
;; 		db    0

;; destroyableStruct struc	; (sizeof=0x7)
;; x_from:	db ?
;; x_to:		db ?
;; y;_from:	db ?
;; y_to:		db ?
;; X:		db ?
;; Y:		db ?
;; BLOCK:	db ?
;; destroyableStruct ends


; =============== S U B	R O U T	I N E =======================================

;; ix - buffer
;; a - block id

update_destoryabl_objects:
	pushf
	push ax;		push	af
	push bx;		push	bc
	push si;		push	hl
	mov si, offset DestroyableBlockSizeTable;		ld	hl, DestroyableBlockSizeTable

loc_948D:
	test byte ptr ds:[si],80h;		bit	7, (hl)
	jnz loc_949A			;		jr	nz, loc_949A
	cmp al, byte ptr ds:[si];		cp	(hl)
	jz appendBlockToBuffer  ;		jr	z, appendBlockToBuffer ; block
	mov bx,5				;		ld	bc, 5
	add si, bx				;		add	hl, bc
	jmp loc_948D			;	jr	loc_948D
	; ---------------------------------------------------------------------------

loc_949A:
	pop si;		pop	hl
	pop bx;		pop	bc
	pop ax;
	popf;		pop	af
		ret
; ---------------------------------------------------------------------------

appendBlockToBuffer:
	mov [di+6], al;		ld	(ix+6),	a	; block
	mov [di+4], cl;		ld	(ix+4),	e	; x
	mov [di+5], ch;		ld	(ix+5),	d	; y
	inc si;		inc	hl		; skip block number

	mov al, byte ptr ds:[si];		ld	a, (hl)		; dx_from
	add al, cl				;		add	a, e
	mov [di+0], al;		ld	(ix+0),	a	; x_from
	;
	inc si;		inc	hl
	add al, byte ptr ds:[si];		add	a, (hl)		; dx_to
	mov [di+1], al			;		ld	(ix+1),	a	; x_to

	inc si					;		inc	hl
	mov al, byte ptr ds:[si];		ld	a, (hl)		; dy_from
	add al, ch				;		add	a, d
	mov [di+2], al			;		ld	(ix+2),	a	; y_from

	inc si					;		inc	hl
	add al, byte ptr ds:[si];		add	a, (hl)		; dy_to
	mov [di+3], al			;		ld	(ix+3),	a	; y_to

	mov bx, 7				;		ld	bc, 7
	add di, bx				;		add	ix, bc
	pop si					;		pop	hl
	pop bx					;		pop	bc
	pop ax
	popf					;		pop	af
		ret

; ---------------------------------------------------------------------------

;

DestroyableBlockSizeTable:
		destroy_object_param  5, -1,  8, -2,  5 ; gunMachine
		destroy_object_param 13, -3,  5, -2, 10 ; FigureYellow
		destroy_object_param 15, -2,  7, -1,  9	; TowerDishWhite
		destroy_object_param 16, -2,  6, -2,  8	; TowerRocketWhite
		destroy_object_param 18, -6, 11,  1,  7 ; box_white
		destroy_object_param 21, -2,  7, -2,  8	; bobs_circle
		destroy_object_param 31, -1,  6, -2,  6	; SphereWithLinesGreen
		destroy_object_param 40, -1,  6, -2,  8	; Wagonetka
		destroy_object_param 44, -1,  8, -2,  4	; gunMachineTop
		destroy_object_param 46, -1,  5, -2,  6	; MushroomGreen
		db 0FFh

; destroy_object_param struc ; (sizeof=0x5)
; _BLK:		db ?			; base 10
; dx_minus:	db ?			; base 10 signed
; dx_size:	db ?			; base 10
; dy_minus:	db ?			; base 10 signed
; dy_size:	db ?			; base 10
; destroy_object_param ends
