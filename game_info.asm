;original code - Rafaelle Cecco (c) 1987
;disassembled by Sergey Erokhin aka ESL - Nov-Dec 2014
;eslexolon@gmail.com
;https://bitbucket.org/esl/exolon-zx/
;licensed under a Creative Commons Attribution Share-Alike 3.0 (CC-BY-SA 3.0)

show_3digit:
push bx					;		push	bc
push dx					;		push	hl
;
mov dx, offset FNT_MAIN		;		ld	hl, FNT_MAIN
mov word ptr ds:[FontPTR+1], dx;		ld	(FontPTR+1), hl
;
mov bh, 100				;		ld	b, 100
call put_digit_div		;		call	put_digit_div
mov bh, 10				;		ld	b, 10
call	put_digit_div	;		call	put_digit_div
mov bh,1				;		ld	b, 1
call	put_digit_div	;		call	put_digit_div
pop dx					;		pop	hl
pop bx					;		pop	bc
		ret

; =============== S U B	R O U T	I N E =======================================


put_digit_div:
mov dl, 0			;		ld	l, 0

div_dig_loop:
sub al, bh			;		sub	b
jc loc_8E3F			;		jr	c, loc_8E3F
inc dl				;		inc	l
jmp div_dig_loop	;		jr	div_dig_loop

loc_8E3F:
add al, bh			;		add	a, b
pushf				;		push	af
push ax
mov al, bh			;		ld	a, b
cmp al, 100			;		cp	100
jz loc_8E4D			;		jr	z, loc_8E4D
mov al, dl			;		ld	a, l
add al, '0'			;		add	a, '0'
call putChar		;		call	putChar
inc cl				;		inc	e

loc_8E4D:
pop ax
popf				;		pop	af
		ret

; =============== S U B	R O U T	I N E =======================================


osd_AMMO:

mov	al, byte ptr ds:[_AMMO]	;		ld	a, (_AMMO)
mov cx, 1701h				;		ld	de, 1701h
mov bl, 47h 				; 'G';		ld	c, 47h ; 'G'
jmp show_3digit				;		jp	show_3digit

; ---------------------------------------------------------------------------

_AMMO:		db 63h


; =============== S U B	R O U T	I N E =======================================


osd_GRENADES:
mov	al, byte ptr ds:[_GRENADES]	;		ld	a, (_GRENADES)
mov cx, 1708h					;		ld	de, 1708h
mov bl,  43h ; 'C'				;		ld	c, 43h ; 'C'
jmp	show_3digit					;		jp	show_3digit

; ---------------------------------------------------------------------------

_GRENADES:	db 0Ah


; =============== S U B	R O U T	I N E =======================================


osd_LIVES:
mov al, byte ptr ds:[_LIVES]	;		ld	a, (_LIVES)
add al, '0'						;		add	a, '0'
mov cx, 1717h					;		ld	de, 1717h
mov bl, 46h						;		ld	c, 46h
mov dx, offset FNT_MAIN				;		ld	hl, FNT_MAIN
mov word ptr ds:[FontPTR+1], dx	;		ld	(FontPTR+1), hl
jmp	putChar						;		jp	putChar
; ---------------------------------------------------------------------------
_LIVES:		db 9

; =============== S U B	R O U T	I N E =======================================

osd_ZONE:

mov al, byte ptr ds:[_ZONE];		ld	a, (_ZONE)
mov cx, 171Ch			   ;		ld	de, 171Ch
mov bl, 46h;		ld	c, 46h
jmp show_A;		jp	show_A
