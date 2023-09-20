;original code - Rafaelle Cecco (c) 1987
;disassembled by Sergey Erokhin aka ESL - Nov-Dec 2014
;eslexolon@gmail.com
;https://bitbucket.org/esl/exolon-zx/
;licensed under a Creative Commons Attribution Share-Alike 3.0 (CC-BY-SA 3.0)

;out: a-key kode if key pressed
GetKEY:
		push bx					;		push	bc
		push dx					;		push	hl
		push cx
		mov dx, offset KBD_TABLE;		ld	hl, KBD_TABLE
		mov ch, 060h;		ld	d, 0FEh	; '�'

loc_ACD8:
;		ld	a, d
;		in	a, (0FEh)
;		ld	e, 1
;		ld	b, 5

loc_ACDF:
;		rrca
;		jr	nc, loc_ACEB
;		inc	hl
;		sla	e
;		djnz	loc_ACDF
;		rlc	d
;		jr	c, loc_ACD8

loc_ACEB:
;		ld	a, (hl)

		pop cx
		pop dx			;		pop	hl
		pop bx			;		pop	bc

		mov ax, 0100h
		int 16h

		ret

; ---------------------------------------------------------------------------
; 1 - SS
; 2 - CS
KBD_TABLE:	db   1,'Z','X','C','V'
		db 'A','S','D','F','G'
		db 'Q','W','E','R','T'
		db '1','2','3','4','5'
		db '0','9','8','7','6'
		db 'P','O','I','U','Y'
		db 0Dh,'L','K','J','H'
		db ' ',  2,'M','N','B'
		db   0

; =============== S U B	R O U T	I N E =======================================


waitKEY:
		mov ax, 0000
		int 16h
		mov ax, 0100h
		int 16h
		
;		xor	a
;		in	a, (0FEh)
;		cpl
;		and	11111b
;		jr	nz, waitKEY
		ret

; step by step animation while pressing	3

chk_key_3:

;		ld	a, 0F7h
;		in	a, (0FEh)	; 54321
;		and	1Fh
;		cp	11011b		; 3
;		ret	nz
;
		mov bx, 1F4h	;		ld	bc, 1F4h
		call	_delayLDIR
		call	waitKEY
		jmp	chk_key_3_continue
