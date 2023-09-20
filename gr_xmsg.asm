;	graphics_xmsg.asm

;original code - Rafaelle Cecco (c) 1987
;disassembled by Sergey Erokhin aka ESL - Nov-Dec 2014
;eslexolon@gmail.com
;https://bitbucket.org/esl/exolon-zx/
;licensed under a Creative Commons Attribution Share-Alike 3.0 (CC-BY-SA 3.0)

; C - color
; HL - PRE
; E-X
; D-Y

xMSG:
		;ld	a, (hl)
		;inc	hl
		;cp	61h
		;jp	nc, ctrlChar
		
		mov si, dx
		mov al, byte ptr ds:[si]
		inc dx
		inc si
		cmp al, 61h
		jnc ctrlChar

putCharxMSGAddr:
		call	PurCharAndSetVarsChkX ;	C - color
					; E-X
					; D-Y
		inc cl		;inc	e
		jmp xMSG	;jp	xMSG
; ---------------------------------------------------------------------------

ctrlChar:
		cmp al,90h					;cp	90h ; 'ê'
		jnc loc_AF49				;jp	nc, loc_AF49
		sub al, _78_deltaY__p0_dbX	;sub	_78_deltaY__p0_dbX
		add al, ch					;add	a, d
		mov ch, al					;ld	d, a
		mov si, dx
		mov al, byte ptr ds:[si] 	;ld	a, (hl)
		add al, cl					;add	a, e
		mov cl, al					;ld	e, a		; X
		inc dx						;inc	hl
		jmp xMSG					;jp	xMSG
; ---------------------------------------------------------------------------

loc_AF49:
		cmp al, 0cfh				;cp	0CFh
		jnc loc_AF56				;jp	nc, loc_AF56
		inc ch						;inc	d
		sub al, -51h				;sub	-51h
		add al, cl					;add	a, e
		mov cl, al					;ld	e, a		; X
		jmp	xMSG					;jp	xMSG
; ---------------------------------------------------------------------------

loc_AF56:
		cmp al, 0dfh				;cp	0DFh
		jnc loc_AF6F				;jp	nc, loc_AF6F
		sub	al, _CF_setLoColor_00	;sub	_CF_setLoColor_00
		cmp al, 8					;cp	8
		jc loc_AF66					;jp	c, loc_AF66
		sub	al, 8					;sub	8
		or	al, 40h					;or	40h

loc_AF66:
		mov bh, al		;ld	b, a
		mov al, bl		;ld	a, c
		and al, 038h	;and	38h
		or al, bh		;or	b
		mov bl, al		;ld	c, a		; color
		jmp xMSG 		;jp	xMSG
; ---------------------------------------------------------------------------

loc_AF6F:
		cmp al, _DF_DW_xy			;cp	_DF_DW_xy
		jnz loc_AF7B				;jp	nz, loc_AF7B
		mov si,	dx
		mov ch, byte ptr ds:[si] 	;ld	d, (hl)
		inc dx						;inc	hl
		mov si, dx
		mov cl, byte ptr ds:[si]	;ld	e, (hl)
		inc dx 						;inc	hl
		jmp	xMSG	;jp	xMSG
; ---------------------------------------------------------------------------

loc_AF7B:
		cmp al, _E0_Attribute?	;cp	_E0_Attribute?
		jnz loc_AF85			;jp	nz, loc_AF85
		
		mov si, dx
		mov bl, byte ptr ds:[si] ;ld	c, (hl)
		inc dx 					;inc	hl
		jmp xMSG				;jp	xMSG
; ---------------------------------------------------------------------------

loc_AF85:
		cmp al, _E1_DBcnt_xLoopStart ;cp	_E1_DBcnt_xLoopStart
		jnz loc_AF91				;jp	nz, loc_AF91
		
		mov si, dx
		mov bh, byte ptr ds:[si]	;ld	b, (hl)
		inc dx						;inc	hl

loc_AF8C:
		push dx 		;push	hl
		push bx			;push	bc
		jmp xMSG		;jp	xMSG
; ---------------------------------------------------------------------------

loc_AF91:
		cmp al, _E2_xMSG_NEXT_e1	;cp	_E2_xMSG_NEXT_e1
		jnz loc_AFA1				;jp	nz, loc_AFA1
		pop bx						;pop	bc
		dec bh
		jnz loc_AF9D				;djnz	loc_AF9D
		pop ax
		sahf		; ;popf<-- strange leak	;pop	af 
		jmp xMSG					;jp	xMSG
		
; ---------------------------------------------------------------------------

loc_AF9D:
		pop dx						;pop	hl
		jmp loc_AF8C				;jp	loc_AF8C
; ---------------------------------------------------------------------------

loc_AFA1:
		cmp al, _E3_DWptr_RecursiveCallxMSG	;cp	_E3_DWptr_RecursiveCallxMSG
		jnz	loc_AFB7						;jp	nz, loc_AFB7
		mov si, dx
		mov al, byte ptr ds:[si] 			;ld	a, (hl)
		inc dx								;inc	hl
		push dx								;push	hl
		mov si, dx
		mov dh, byte ptr ds:[si]			;ld	h, (hl)
		mov dl, al							;ld	l, a
		push bx								;push	bc
		push cx								;push	de
		call xMSG							;call	xMSG
		pop cx								;pop	de
		pop bx								;pop	bc
		pop dx								;pop	hl
		inc dx 								;inc	hl
		jmp xMSG							;jp	xMSG
; ---------------------------------------------------------------------------

loc_AFB7:
		cmp al, _E4_DBcnt_DBCHR_FillCharX	;cp	_E4_DBcnt_DBCHR_FillCharX
		jnz loc_AFC9						;jp	nz, loc_AFC9
		mov si, dx
		mov bh, byte ptr ds:[si]			;ld	b, (hl)
		inc dx 								;inc	hl
		mov si, dx
		mov al, byte ptr ds:[si] 			;ld	a, (hl)

putChar_xMSG_E4:
					; DATA XREF: selectPutCHR+Bw

		call PurCharAndSetVarsChkX			;call	PurCharAndSetVarsChkX ;	C - color
		
					; E-X
					; D-Y
		inc cl	;inc	e
		
		dec bh
		jnz putChar_xMSG_E4 ;djnz	putChar_xMSG_E4
		inc dx			;inc	hl
		jmp xMSG		;jp	xMSG
; ---------------------------------------------------------------------------

loc_AFC9:
		cmp al, _E5_DBcnt_DBCHR_FillCharY	;cp	_E5_DBcnt_DBCHR_FillCharY
		jnz loc_AFDB						;jp	nz, loc_AFDB
		mov si, dx
		mov bh, byte ptr ds:[si]			;ld	b, (hl)
		inc dx 								;inc	hl
		mov si, dx
		mov al, byte ptr ds:[si]			;ld	a, (hl)

putChar_xMSG_E5:
					; DATA XREF: selectPutCHR+Ew
		call PurCharAndSetVarsChkX	;call	PurCharAndSetVarsChkX ;	C - color
					; E-X
					; D-Y
		inc ch 		;inc	d
		dec bh		
		jnz putChar_xMSG_E5		;djnz	putChar_xMSG_E5
		inc dx					;inc	hl
		jmp xMSG				;jp	xMSG
; ---------------------------------------------------------------------------

loc_AFDB:
		cmp al, _E6_DW_FONT			;cp	_E6_DW_FONT
		jnz loc_AFEC				;jr	nz, loc_AFEC
		mov si, dx
		mov al, byte ptr ds:[si]	;ld	a, (hl)
		mov byte ptr ds:[FontPTR+1], al		;ld	(FontPTR+1), a
		inc dx					;inc	hl
		mov si, dx
		mov al, byte ptr ds:[si] ;ld	a, (hl)
		mov byte ptr ds:[FontPTR+2], al	;ld	(FontPTR+2), a
		inc dx 					;inc	hl
		jmp xMSG				;jp	xMSG
; ---------------------------------------------------------------------------

loc_AFEC:
		cmp al, _E7_SPACE	;cp	_E7_SPACE
		jnz loc_B009		;jr	nz, loc_B009
		push dx				;push	hl
		mov dx, word ptr ds:[FontPTR+1];ld	hl, (FontPTR+1)
		push dx 			;push	hl
		mov dx, offset FNT_MAIN	;ld	hl, FNT_MAIN ; FONT_ALPHA1 - 0x20*8
		mov word ptr ds:[FontPTR+1], dx;		;ld	(FontPTR+1), hl
		mov al, 020h;	ld	a, 20h ; ' '

putChar_xMSG_E7:			; DATA XREF: selectPutCHR+11w
					; xMSG+108 r
		call	PurCharAndSetVarsChkX 	;call	PurCharAndSetVarsChkX ;	C - color
					; E-X
					; D-Y
		inc cl	;inc	e
		pop dx	;pop	hl
		mov word ptr ds:[FontPTR+1], dx	;ld	(FontPTR+1), hl
		pop dx							;pop	hl
		jmp xMSG						;jp	xMSG
; ---------------------------------------------------------------------------

loc_B009:
		cmp al, _E8_LD_DB_setNoWalk	;cp	_E8_LD_DB_setNoWalk
		jnz loc_B015				;jr	nz, loc_B015
		mov si, dx
		mov al, byte ptr ds:[si] 	;ld	a, (hl)
		mov byte ptr ds:[noWalkFlag+1],	al		;ld	(noWalkFlag+1),	a
		inc dx 						;inc	hl
		jmp xMSG					;jp	xMSG
; ---------------------------------------------------------------------------

loc_B015:
		cmp al, _E9_setNoOverPlayer	;cp	_E9_setNoOverPlayer
		jnz loc_B020 				;jr	nz, loc_B020
		xor al, al					;xor	a
		mov byte ptr ds:[overPlayerFlag+1], al 		;ld	(overPlayerFlag+1), a
		jmp xMSG 					;jp	xMSG
; ---------------------------------------------------------------------------

loc_B020:
		cmp al, _EA_setOverPlayer	;cp	_EA_setOverPlayer
		jnz loc_B02C				;jr	nz, loc_B02C
		mov al, 0ffh				;ld	a, 0FFh
		mov byte ptr ds:[overPlayerFlag+1], al 		;ld	(overPlayerFlag+1), a
		jmp xMSG					;jp	xMSG
; ---------------------------------------------------------------------------

loc_B02C:
		cmp al, _EB_AnimatedObject	;cp	_EB_AnimatedObject
		jz z1
		ret
		;ret	nz
;
z1:
		mov si, dx
		mov al, byte ptr ds:[si] 	;ld	a, (hl)
		push bx 					;push	bc
		push cx 					;push	de
		push dx						;push	hl
		mov dx, word ptr ds:[putChar_xMSG_E7+1]	;ld	hl, (putChar_xMSG_E7+1)
		mov bx, offset PurCharAndSetVarsChkX	;ld	bc, PurCharAndSetVarsChkX ; C -	color?
					;; E-X
					;; D-Y
		sbb dx, bx	;sbc	hl, bc
		jnz loc_B044	;jr	nz, loc_B044
;
		call block2xy	;call	block2xy	;; _Dx4_Ex8
					;; d*4
					;; e*8
					;;
		call getNowalkAddrForXY	;call	getNowalkAddrForXY ; d-y (0..191) ,e-x (0..127)
					;; ret
					;; hl-NoWalkaddr
		mov si, dx
		mov byte ptr ds:[si], al	;ld	(hl), a

loc_B044:
		pop dx	;pop	hl
		pop cx	;pop	de
		pop bx	;pop	bc
		inc dx	;inc	hl
		jmp xMSG	;jp	xMSG



; =============== S U B	R O U T	I N E =======================================

; d-y (0..191) ,e-x (0..127)
; ret
; hl-NoWalkaddr

getNowalkAddrForXY:
		lahf;			push	af
		push ax
		push cx;		push	de
		mov al,cl;		ld	a, e		; x
		and al,1111100b;and	1111100b
		ror al,2;		rrca
				;rrca
		mov cl,al;		ld	e, a		; x/4
		;
		mov al,ch;		ld	a, d
		and al,11111000b;and	11111000b
		ror al,3;		rrca
				;rrca
				;rrca
		mov ch, al;		ld	d, a		; y/8
		;
		call textXY2TABLEOFFSET; call	textXY2TABLEOFFSET ; in:
							; d - y	(0..23)
							; e - x	(0..31)
							; out:
							; hl=Y*32+X
		mov cx, offset no_walk_tab;		ld	de, no_walk_tab	; ?AnimationTab?
		add dx, cx;		add	hl, de
		pop cx;		pop	de
		pop ax
		sahf;		pop	af
		ret
; End of function getNowalkAddrForXY

; =============== S U B	R O U T	I N E =======================================

; in:
; d - y	(0..23)
; e - x	(0..31)
; out:
; hl=Y*32+X

textXY2TABLEOFFSET:
		mov al, ch		;		ld	a, d
		sar al,3		;		sra	a
						;		sra	a
						;		sra	a
		mov dh,al		;		ld	h, a		; y/8
						;
		mov al, ch		;		ld	a, d
		and al, 111b	;		and	111b		; 0000111 -> 11100000
		ror al,3		;		rrca
						;		rrca
						;		rrca
		add al,cl		;		add	a, e		; y/8+x
						;
		mov dl, al		;		ld	l, a
						;
		ret
