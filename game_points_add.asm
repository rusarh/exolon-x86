;original code - Rafaelle Cecco (c) 1987
;disassembled by Sergey Erokhin aka ESL - Nov-Dec 2014
;eslexolon@gmail.com
;https://bitbucket.org/esl/exolon-zx/
;licensed under a Creative Commons Attribution Share-Alike 3.0 (CC-BY-SA 3.0)

addPoints:
pushf		;		push	af
push ax
push bx		;		push	bc
push dx		;		push	de
push dx		;		push	hl
mov bl, 0	;		ld	c, 0
mov dx, offset points+5 ;		ld	hl,  points+5
mov bh, 6	;		ld	b, 6

loc_AD5E:
mov si,cx
mov al, byte ptr ds:[si];		ld	a, (de)
mov si,dx
add al, byte ptr ds:[si];		add	a, (hl)
sub al, '0'				;		sub	'0'
add al, bl				;		add	a, c
cmp al, 03ah			;		cp	3Ah ; ':'
mov bl, 1				;		ld	c, 1
jc loc_AD6D				;		jr	c, loc_AD6D
sub al, 0ah				;		sub	0Ah
jmp loc_AD6E			;		jr	loc_AD6E
; ---------------------------------------------------------------------------

loc_AD6D:
dec bl					;		dec	c

loc_AD6E:
mov si, dx
mov byte ptr ds:[si], al;		ld	(hl), a
dec dx					;		dec	hl
dec cx					;		dec	de
dec bh
jnz loc_AD5E			;		djnz	loc_AD5E
xor al,al				;		xor	a
mov byte ptr ds:[overPlayerFlag+1], al;		ld	(overPlayerFlag+1), a
mov dx, offset xMSG_Points	;		ld	hl, xMSG_Points
call xMSG			;		call	xMSG		; C - color
					; HL - PRE
					; E-X
					; D-Y
pop dx				;		pop	hl
pop cx				;		pop	de
pop bx				;		pop	bc
pop ax
popf				;		pop	af
		ret
; End of function addPoints

; ---------------------------------------------------------------------------
xMSG_Points:	
		db _E0_Attribute?
		db 45h
		db _E6_DW_FONT
		dw FNT_MAIN
		db _DF_DW_xy
		_XY_ 23, 14
points:		
		db '000000'
		db _FF_EndMSG
;
;
;

a000025:	db '000025'
a000050:	db '000050'
a000100:	db '000100'
a000125:	db '000125'
a000150:	db '000150'
a000200:	db '000200'
a000250:	db '000250'
a000300:	db '000300'
a000350:	db '000350'
a001000:	db '001000'
