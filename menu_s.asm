;original code - Rafaelle Cecco (c) 1987
;disassembled by Sergey Erokhin aka ESL - Nov-Dec 2014
;eslexolon@gmail.com
;https://bitbucket.org/esl/exolon-zx/
;licensed under a Creative Commons Attribution Share-Alike 3.0 (CC-BY-SA 3.0)

starsAnimationStep:
		lahf
		push ax			;		push	af
		push bx			;		push	bc
		push cx			;		push	de
		push dx			;		push	hl
		push di			;		push	iy
		push si
		
		mov di, offset clr_SpriteBuffers;		ld	iy, clr_SpriteBuffers
		mov dx, offset StarsData?		;		ld	hl, StarsData?

nextStar:
		mov si, dx
		mov cl, byte ptr ds:[si];		ld	e, (hl)		; X?
		test cl, 80h			;		bit	7, e
		jz doStar				;		jr	z, doStar
		
		pop si
		pop di					;		pop	iy
		pop dx					;		pop	hl
		pop cx					;		pop	de
		pop bx					;		pop	bc
		pop ax
		sahf					;		pop	af
		ret
; ---------------------------------------------------------------------------

doStar:
		push dx						;		push	hl
		
		inc dx						;		inc	hl		; Y
		mov si, dx
		mov ch, byte ptr ds:[si]	;		ld	d, (hl)
		inc dx						;		inc	hl
		mov si, dx
		mov al, byte ptr ds:[si]	;		ld	a, (hl)		; sprPhase?
		or al,al					;		or	a
		jnz noNewPos				;		jr	nz, noNewPos
		call	RND					;		call	RND
		and al, 1Eh					;		and	1Eh
		mov cl, al					;		ld	e, a
		call RND					;		call	RND
		and al, 1Fh					;		and	1Fh
		cmp al, 22					;		cp	22
		jnc skipGeneration			;		jr	nc, skipGeneration
		mov ch, al					;		ld	d, a
		call	textXY2TABLEOFFSET 	;		call	textXY2TABLEOFFSET ; in:
			;					; d - y	(0..23)
			;					; e - x	(0..31)
			;					; out:
			;					; hl=Y*32+X
		mov bx, offset no_walk_tab	;		ld	bc, no_walk_tab	; ?AnimationTab?
		add dx, bx					;		add	hl, bc
			;;
		mov si, dx
		mov al, byte ptr ds:[si]	;		ld	a, (hl)
		inc dx						;		inc	hl
		mov si, dx
		or al, byte ptr ds:[si]		;		or	(hl)
		mov bx, 32					;		ld	bc, 32
		add dx, bx					;		add	hl, bc
		mov si, dx
		or al, byte ptr ds:[si]		;		or	(hl)
		dec dx						;		dec	hl
		mov si, dx
		or al, byte ptr ds:[si]		;		or	(hl)
		jnz skipGeneration			;		jr	nz, skipGeneration
			;
		pop dx						;		pop	hl
		
		push dx						;		push	hl
		mov al, cl					;		ld	a, e
		add al, al					;		add	a, a
		add al, al					;		add	a, a

		mov si, dx
		mov byte ptr ds:[si], al	;		ld	(hl), a
		inc dx						;		inc	hl
		mov al, ch					;		ld	a, d
		add al, al					;		add	a, a
		add al, al					;		add	a, a
		add al, al					;		add	a, a

		mov si,dx
		mov byte ptr ds:[si], al	;		ld	(hl), a
		inc dx						;		inc	hl
		mov si,dx
		mov byte ptr ds:[si], 16	;		ld	(hl), 16	; Idx in Idx2SprTable
		jmp skipGeneration			;		jr	skipGeneration
; ---------------------------------------------------------------------------

noNewPos:
		mov si, dx	
		dec byte ptr ds:[si]	;		dec	(hl)
		mov dl, al				;		ld	l, a
		mov dh, 0				;		ld	h, 0
		mov bx, offset sprPhase2SprId-1;		ld	bc, sprPhase2SprId-1	;m_128_XXXX	; sprPhase2SprId-2
		add dx, bx				;		add	hl, bc
		
		mov si, dx
		mov al, byte ptr ds:[si];		ld	a, (hl)
		mov bh, ch				;		ld	b, d
		mov bl, cl				;		ld	c, e
		push di					;		push	iy
		pop dx					;		pop	hl
		call	putSpriteAndPlay128Music?;call	putSpriteAndPlay128Music? ; A sprId (00..45)
;					; D - Y	(0..192)?
;					; E - X	(0..255)
;					; HL - ??
;					;
		mov bl, 47h			;		ld	c, 47h
		;call	fillAttr_2x2
;
skipGeneration:
		pop dx;		pop	hl
		
		inc dx;		inc	hl
		inc dx;		inc	hl
		inc dx;		inc	hl
		mov cx, 48;		ld	de, 48
		add di, cx;		add	iy, de
		jmp nextStar;		jr	nextStar	; X?

; =============== S U B	R O U T	I N E =======================================

; A sprId (00..45)
; D - Y	(0..192)?
; E - X	(0..255)
; HL - ??
;

putSpriteAndPlay128Music?:
		call Sprite16x16	; A sprId (00..45)
;					; D - Y	(0..192)?
;					; E - X	(0..255)
;					; HL - saveSpriteArea
;					;
;		push	af
;		ld	a, (FlagZX128)	; 00 - zx48
;		or	a
;		jr	z, no128music
;
;		ld	a, (m_128_XXXX)
;		inc	a
;		ld	(m_128_XXXX), a
;		cp	4
;		jr	nz, no128music
;		xor	a
;		ld	(m_128_XXXX), a
;		push	af
;		push	bc
;		push	de
;		push	hl
;		push	ix
;		push	iy
;		call	do128musicstep
;		pop	iy
;		pop	ix
;		pop	hl
;		pop	de
;		pop	bc
;		pop	af

no128music:
;		pop	af
		ret

; ---------------------------------------------------------------------------
m_128_XXXX:	
		db 2
sprPhase2SprId:	
		db 0
		db sStar_1,sStar_1,sStar_2; 0
		db sStar_2,sStar_3,sStar_3; 3
		db sStar_4,sStar_4,sStar_4; 6
		db sStar_3,sStar_3,sStar_2; 9
		db sStar_3,sStar_1,sStar_1; 12
StarsData?:
		db 12*3 dup (?) 	; 		ds 	12*3
 		lvl    8, 112,	 3; 0
 		lvl   96,  16,	 0; 11
		db 0FFh

; =============== S U B	R O U T	I N E =======================================


clr_menuStars:
 push si
 push di
 mov si, offset StarsData?;		ld	hl, StarsData?
 mov di, offset StarsData?+1;		ld	de, StarsData?+1
 mov cx, 12*3-1; 		ld	bc, 12*3-1
 mov [si], bh;		ld	(hl), b
 rep movsb;		ldir
 
 pop di
 pop si
 ret

