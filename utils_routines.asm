;original code - Rafaelle Cecco (c) 1987
;disassembled by Sergey Erokhin aka ESL - Nov-Dec 2014
;eslexolon@gmail.com
;https://bitbucket.org/esl/exolon-zx/
;licensed under a Creative Commons Attribution Share-Alike 3.0 (CC-BY-SA 3.0)


ClearToBLACK:
;		ld	c, 0
		mov bl, 0
; C - Attr value

ClearScreen_fromback:
		;ld	hl,  ATTR_TABLE+2FFh
		;ld	de,  ATTR_TABLE+2FEh
		;ld	(hl), c
		;ld	bc, 768-1
		;lddr
		;ld	(hl), 0
		;ld	bc, 6143
		;lddr
		
		push es
		push ax
		push cx
		push si
		push di
		mov ax, 0b800h
		mov es, ax
		xor si, si
		xor di, di
		mov al, bl
		mov ah, bl
		mov cx, 04000h
		cld
		rep stosw
		pop di
		pop si
		pop cx
		pop ax
		pop es
		
		ret
; =============== S U B	R O U T	I N E =======================================

clr_PlayScreen:
;		ld	c, 0
;		ld	hl, ATTR_TABLE
;		ld	(hl), c
;		ld	de,  ATTR_TABLE+1
;		ld	bc, 22*32-1	;703
;		ldir
;
;		ld	hl, SCRLINE000
;		ld	b, 176
;loc_B074:
;		push	bc
;		push	hl
;		ld	e, l
;		ld	d, h
;		inc	de
;		ld	(hl), 0
;		ld	bc, 32-1	;1Fh
;		ldir
;		pop	hl
;		call	NextScrLineAddr
;		pop	bc
;		djnz	loc_B074

		ret

; =============== S U B	R O U T	I N E =======================================

; IN: D	- Y (0..191),E - X (0..127)
; OUT: HL - scr	addr

XY2SCR_ADDR:

;		push	af
;		ld	l, d
;		ld	h, 65h          ; 6500 - Y2SCR_HI
;		ld	a, (hl)
;		inc	h		; 6600 - Y2SCR_LO
;		ld	l, (hl)
;		ld	h, a		; HL - Y-ScrAddr

;		ld	a, e
;		and	1111100b
;		rrca
;		rrca
;		add	a, l
;		ld	l, a		; hl+=(x&0xfc)>>2

;		pop	af

;CH(D) = y
;CL(E) = x
;out = DX - scr addr
		lahf
		;mov cx, 0101h
		push ax
		mov ax, 050h/2
		xor dx, dx
		mov dl, ch
		mul dl
		mov dx,ax
		
		xor ax, ax
		mov al, cl
		and al, 0fch
		;shr al, 2
		add dx, ax
		pop ax
		sahf
		ret

; =============== S U B	R O U T	I N E =======================================


NextScrLineAddr:
		inc dh				;		inc	h
		mov al,bh			;		ld	a, h
		and al, 7			;		and	7
		jnz nscr1
		ret;		ret	nz
nscr1:
		mov al, 1			;		ld	a, l
		add al, 20h			;		add	a, 20h
		mov dl, al			;		ld	l, a
		jc nscr2
		ret
nscr2:				;		ret	c
		mov al, dh			;		ld	a, h
		sub al, 8			;		sub	8
		mov dh, al			;		ld	h, a
		
		ret
		
; =============== S U B	R O U T	I N E =======================================

; BC

_delayLDIR:
		push bx			;		push	bc
		push cx			;		push	de
		push si			;		push	hl
		mov si, 0		;		ld	hl, 0
		mov cx, 0		;		ld	de, 0
		rep movsb		;		ldir
		pop si			;		pop	hl
		pop cx			;		pop	de
		pop bx			;		pop	bc
		ret
; ---------------------------------------------------------------------------

show_A:
		push bx					;		push	bc
		push dx					;		push	hl
		mov dx, offset FNT_MAIN ;		ld	hl, FNT_MAIN
		mov	word ptr ds:[FontPTR+1], dx	;		ld	(FontPTR+1), hl
		mov bh, 100				;		ld	b, 100
		call putDec31			;		call	putDec31
		mov bh, 10				;		ld	b, 10
		call	putDec31		;		call	putDec31
		mov bh, 1				;		ld	b, 1
		call	putDec31		;		call	putDec31
		pop dx					;		pop	hl
		pop bx					;		pop	bc
		ret

; =============== S U B	R O U T	I N E =======================================

putDec31:
		mov dl, 0				;		ld	l, 0

loc_B0E2:
		sub al, bh	;		sub	b
		jc loc_B0E8	;		jr	c, loc_B0E8
		inc dl		;		inc	l
		jmp loc_B0E2;		jr	loc_B0E2

loc_B0E8:
		add al, bh	;		add	a, b
		lahf		;		push	af
		push ax
		mov al, dl	;		ld	a, l
		add al, 30h ; '0';	add	a, 30h ; '0'
		call putChar;		call	putChar		; A - chr
							; C - COLOR
							; E-X
							; D-Y
		pop ax
		sahf		;		pop	af
		inc cl		;		inc	e

		ret
