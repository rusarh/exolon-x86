;original code - Rafaelle Cecco (c) 1987
;disassembled by Sergey Erokhin aka ESL - Nov-Dec 2014
;eslexolon@gmail.com
;https://bitbucket.org/esl/exolon-zx/
;licensed under a Creative Commons Attribution Share-Alike 3.0 (CC-BY-SA 3.0)

init_random_stars:
		mov dx, offset FNT_SmallHLIne	;		ld	hl, FNT_SmallHLIne
		mov word ptr ds:[FontPTR+1], dx	;		ld	(FontPTR+1), hl
		;
		mov bh, 22						;		ld	b, 22 		;22 lines with row
		;
StarLineLoop:
		push bx							;		push	bc
		mov al, 3						;		ld	a, 3 		;3 sars in each row

starInLineLoop:
		xchg ah, al						;		ex	af, af'
		;push ax
		call RND						;		call	RND
		;pop ax
		and al, 31						;		and	31
		mov cl, al						;		ld	e, a
		mov ch, bh						;		ld	d, b
		dec ch							;		dec	d
		call	textXY2TABLEOFFSET 		;		call	textXY2TABLEOFFSET ; in:
		;					; d - y	(0..23)
		;					; e - x	(0..31)
		;					; out:
		;					; hl=Y*32+X
		push bx							;		push	bc
		mov bx, offset ATTR_TABLE_COPY	;		ld	bc, ATTR_TABLE_COPY
		add dx, bx						;		add	hl, bc
		pop bx							;		pop	bc
		mov si,	dx
		mov al, byte ptr ds:[si]		;		ld	a, (hl)
		or al, al						;		or	a
		jnz skip_star_place_used		;		jr	nz, skip_star_place_used
		;		;color
		call	RND						;		call	RND
		and al,7						;		and	7
		or al, 42h						;		or	42h ; 'B'
		mov bl, al						;		ld	c, a
		;		;char - dot in font
		mov al, 3						;		ld	a, 3		; one dot (START)
		call	putChar					;		call	putChar		; A - chr
;					; C - COLOR
;					; E-X
;					; D-Y
;
skip_star_place_used:
		xchg al, ah						;		ex	af, af'
		dec al							;		dec	a
		jnz starInLineLoop				;		jr	nz, starInLineLoop
		pop bx							;		pop	bc
		dec bh
		jnz starInLineLoop				;		djnz	StarLineLoop
		ret								; 		ret

