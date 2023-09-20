;	graphics_sprites_code_24x32.asm

;original code - Rafaelle Cecco (c) 1987
;disassembled by Sergey Erokhin aka ESL - Nov-Dec 2014
;eslexolon@gmail.com
;https://bitbucket.org/esl/exolon-zx/
;licensed under a Creative Commons Attribution Share-Alike 3.0 (CC-BY-SA 3.0)

;
; 00-09	- WALK
; 10 - Duck
; 11 - DIE
; 12-21	WALK 2gun
; 22 - Duck2gun
; 23 - Die 2gun
; 24 - PUMP
;

Sprite24x32_Player:
;0193:6D3C  FA                  cli                                              
;0193:6D3D  F4                  hlt       

	;cli
	
	lahf
	push ax;		push	af
	push bx;		push	bc
	push cx;		push	de
	push di;		push	ix
	push si
	push dx;		push	hl
	push bx;		push	bc
	push dx;		push	hl
	push cx;		push	de
;
; 1. calculate sprite ram addr
;
	mov dl,al;		ld	l, a
	mov dh,0;		ld	h, 0
	
	add dx,dx;		add	hl, hl
	add dx,dx;		add	hl, hl
	add dx,dx;		add	hl, hl
	add dx,dx;		add	hl, hl
	add dx,dx;		add	hl, hl		; 32
;
	mov al, cl;		ld	a, e
	mov ch, dh;		ld	d, h
	mov cl, dl;		ld	e, l
	
	add dx, dx;		add	hl, hl
	add dx, cx;		add	hl, de		; *96
	;
	mov cx, offset PLAYER_WALK;		ld	de, PLAYER_WALK	; 10 phases
	add dx, cx				  ;		add	hl, de
	;
	mov word ptr ds:[_SAV_SP], sp ;		ld	(_SAV_SP), sp
	mov sp, dx;		ld	sp, hl
;
; 2. shift sprite to sprite buff
; (x&7)
	add al,al;		add	a, a		; x
	and al,7;		and	7
	add al,al;		add	a, a
	mov dl,al;		ld	l, a
	mov dh,0;		ld	h, 0
	;
	mov cx, offset _shif_jp_tab24;		ld	de, _shif_jp_tab24
	add dx, cx;		add	hl, de
	;
	mov si, dx
	mov cl, byte ptr ds:[si];		ld	e, (hl)
	inc dx;		inc	hl
	mov si, dx
	
	mov ch, byte ptr ds:[si];		ld	d, (hl)
	mov di, 0;		ld	ix, 0
	add di, cx;		add	ix, de
	;
	mov dx, offset ShiftedSprites;		ld	hl, ShiftedSprites
	mov al, 32;		ld	a, 32

shift_loop_24x32:
	pop bx;		pop	bc		;word from sprite
	pop cx;		pop	de		;word from sprite
	dec sp;		dec	sp		;correct for pop 3 byte
	mov ch,0;		ld	d, 0
	jmp di;		jp	(ix)

; ---------------------------------------------------------------------------

shift24_4:
	rol cl,1;		rl	e
	rol bh,1;		rl	b
	rol bl,1;		rl	c
	rol ch,1;		rl	d
;
shift24_5:
	rol cl,1;		rl	e
	rol bh,1;		rl	b
	rol bl,1;		rl	c
	rol ch,1;		rl	d

shift24_6:
	rol cl,1;		rl	e
	rol bh,1;		rl	b
	rol bl,1;		rl	c
	rol ch,1;		rl	d
;
shift24_7:
	rol cl,1;		rl	e
	rol bh,1;		rl	b
	rol bl,1;		rl	c
	rol ch,1;		rl	d
	;
	mov si,dx
	mov byte ptr ds:[si], ch;		ld	(hl), d
	inc dx					;		inc	hl
	;
	mov si,dx
	mov byte ptr ds:[si], bl;		ld	(hl), c
	inc dx					;		inc	hl
	;
	mov si,dx
	mov byte ptr ds:[si], bh;		ld	(hl), b
	inc dx					;		inc	hl
	;
	mov si,dx
	mov byte ptr ds:[si], cl;		ld	(hl), e
	inc dx					;		inc	hl
	;
	dec al					;		dec	a
	
	jnz shift_loop_24x32	;		jp	nz, shift_loop_24x32
	;
	jmp spr24x32_shift_done;		jp	spr24x32_shift_done
; ---------------------------------------------------------------------------

shift24_3:
	ror bl,1	;		rr	c
	ror bh,1	;		rr	b
	ror cl,1	;		rr	e
	ror ch,1	;		rr	d

shift24_2:
	ror	bl,1	;		rr	c
	ror bh,1	;		rr	b
	ror cl,1	;		rr	e
	ror ch,1	;		rr	d
;
shift24_1:
	ror	bl,1	;		rr	c
	ror bh,1	;		rr	b
	ror cl,1	;		rr	e
	ror ch,1	;		rr	d
;
shift24_0:
	mov si,dx
	mov byte ptr ds:[si], bl;		ld	(hl), c
	inc dx					;		inc	hl
	;
	mov si,dx
	mov byte ptr ds:[si], bh;		ld	(hl), b
	inc dx					;		inc	hl
	;
	mov si,dx
	mov byte ptr ds:[si], cl;		ld	(hl), e
	inc dx					;		inc	hl
	;
	mov si,dx
	mov byte ptr ds:[si], ch;		ld	(hl), d
	inc dx					;		inc	hl
	;
	dec al					;		dec	a
	jnz shift_loop_24x32	;		jp	nz, shift_loop_24x32

spr24x32_shift_done:
	mov sp, word ptr ds:[_SAV_SP];		ld	sp, (_SAV_SP)
	pop cx						;		pop	de
	call XY2SCR_ADDR			;		call	XY2SCR_ADDR	; IN: D	- Y (0..191),E - X (0..127)
;					; OUT: HL - scr	addr
;
	mov dx, 0
	mov word ptr ds:[scr_addr_spr24x32+1], dx;		ld	(scr_addr_spr24x32+1), hl
	mov al, dh;		ld	a, h
	shr al, 1;		rrca
	shr al, 1;		rrca
	shr al, 1;		rrca
	and al, 3;		and	3
	mov dh, al;		ld	h, a
;
	push cx;		push	de
	mov bx, offset over_player_tab;		ld	bc, over_player_tab
	add dx, bx;		add	hl, bc
;
	push dx;		push	hl
	mov al, ch;		ld	a, d
	mov cx, 29;		ld	de, 29		; 32-3
	mov bh, 4;		ld	b, 4		; 4byte
	and al, 7;		and	7
	jz loc_778F;	jr	z, loc_778F
	inc bh	;		inc	b

loc_778F:
	mov ah, 0ffh;		ld	a, 0FFh

loc_7791:
	mov si, dx
	and byte ptr ds:[si],al;		and	(hl)
	inc dx
	mov si, dx;		inc	hl
	and byte ptr ds:[si], al;		and	(hl)
	inc dx					;		inc	hl
	mov si,dx
	and byte ptr ds:[si],al;		and	(hl)
	inc dx
	mov si,dx				;		inc	hl
	and byte ptr ds:[di],al	;		and	(hl)
;
	add dx, cx					   ;    add	hl, de
	dec bh
	jnz loc_7791				   ;    djnz	loc_7791
;
	pop dx						   ;	pop	hl
	pop cx						   ;	pop	de
	xchg ah,al					   ;	ex	af, af'
	mov al, cl					   ;	ld	a, e
	cmp al, 75h					   ;	cp	75h
	jz loc_77CF					   ;	jp	c, loc_77CF
	
	exx_						   ;	exx
	
	mov dx, offset ShiftedSprites+1;	ld	hl,  ShiftedSprites+1
	cmp al, 07ch;		cp	7Ch
	mov cx, 0	;		ld	de, 0
	mov bl, dh	;		ld	c, d
	jnc loc_77BD;		jr	nc, loc_77BD
	cmp al, 78h;		cp	78h
	mov cx, 0FF00h;		ld	de, 0FF00h
	mov bl, cl	;		ld	c, e
	jnc loc_77BD;		jr	nc, loc_77BD
	mov cx, 0FFFFh;		ld	de, 0FFFFh
	mov bl, 0	;		ld	c, 0

loc_77BD:
	mov bh, 32;		ld	b, 32

loc_77BF:
	mov al, ch;		ld	a, d
	mov si, dx
	and al, byte ptr ds:[si] ;		and	(hl)
	mov byte ptr ds:[si], al;		ld	(hl), a
	inc dx				;			inc	hl
	mov al, cl				;		ld	a, e
	mov si, dx
	and al, byte ptr ds:[si];		and	(hl)
	mov byte ptr ds:[si],al;		ld	(hl), a
	inc dx				   ;		inc	hl
	mov al, bl				;		ld	a, c
	mov si,dx
	and al, byte ptr ds:[si];		and	(hl)
	mov byte ptr ds:[si],al;		ld	(hl), a
	inc dx					;		inc	hl
	inc dx					;		inc	hl
	dec bh
	jnz loc_77BF			;		djnz	loc_77BF
	
	exx_;		exx

loc_77CF:
	xchg ah,al	;		ex	af, af'
	jnz loc_77FB;		jr	nz, loc_77FB
;
	mov al, 8	;		ld	a, 8
	mov byte ptr ds:[last_mask24_len+1], al;		ld	(last_mask24_len+1), a
;
	mov al, ch	;		ld	a, d
	and al,7	;		and	7
	mov cx, offset ShiftedSprites;		ld	de, ShiftedSprites
	jz first_byte24_shift_0		;		jr	z, first_byte24_shift_0
;
	mov byte ptr ds:[last_mask24_len+1], al;		ld	(last_mask24_len+1), a
	mov bh, al								;		ld	b, a
	mov al, 8								;		ld	a, 8
	sub al, bh								;		sub	b
	mov bh, al								;		ld	b, a
	mov cx, offset ShiftedSprites			;		ld	de, ShiftedSprites
	call mask24_hl_de_a						;		call	mask24_hl_de_a

first_byte24_shift_0:
	call	mask24_hl_de_8;		call	mask24_hl_de_8
	call	mask24_hl_de_8;		call	mask24_hl_de_8
	call	mask24_hl_de_8;		call	mask24_hl_de_8

last_mask24_len:
	mov bh,0			;		ld	b, 0
	call mask24_hl_de_a;		call	mask24_hl_de_a

loc_77FB:
	pop dx				;		pop	hl
	pop cx				;		pop	de
	mov bh, dh			;		ld	b, h
	mov bl, dl			;		ld	c, l
	call XY2SCR_ADDR	;		call	XY2SCR_ADDR	; IN: D	- Y (0..191),E - X (0..127)
;					; OUT: HL - scr	addr
	mov ch, bh			;		ld	d, b
	mov cl, bl			;		ld	e, c
	mov bl, 7			;		ld	c, 7
	
	exx_				;		exx

scr_addr_spr24x32:
	mov dx,0	; <---- overwriten	;		ld	hl, 0		; <---- overwriten
	mov word ptr ds:[_SAV_SP],sp;		ld	(_SAV_SP), sp
	mov sp, offset ShiftedSprites;		ld	sp, ShiftedSprites
	mov  bx, 2007h				;		ld	bc, 2007h

loc_7814:
	pop cx						;		pop	de
	mov al, cl					;		ld	a, e
	mov si, dx
	xor al, byte ptr es:[si]	;		xor	(hl)
	mov byte ptr es:[si], al	;		ld	(hl), a
	inc dl						;		inc	l
	mov al, ch					;		ld	a, d
	mov si, dx
	xor al, byte ptr es:[si]	;		xor	(hl)
	mov byte ptr es:[si],al		;		ld	(hl), a
	inc dl						;		inc	l
;
	pop cx						;		pop	de
	mov al, cl					;		ld	a, e
	mov si,dx
	xor al, byte ptr es:[si]	;		xor	(hl)
	mov byte ptr es:[si],al		;		ld	(hl), a
	inc dl						;		inc	l
	mov al, ch					;		ld	a, d
	mov si, dx
	xor al, byte ptr es:[si]	;		xor	(hl)
	mov byte ptr es:[si],al		;		ld	(hl), a
	dec dl						;		dec	l
	dec dl						;		dec	l
	dec dl						;		dec	l
	inc dh						;		inc	h
	mov al, dh					;		ld	a, h
	and al, bl					;		and	c
	jnz loc_7837				;		jr	nz, loc_7837
	mov al, dl					;		ld	a, l
	add al, 32					;		add	a, 32
	mov dl, al					;		ld	l, a
	jc loc_7837					;		jr	c, loc_7837
	mov al, dh					;		ld	a, h
	sub al, 8					;		sub	8
	mov dh, al					;		ld	h, a

loc_7837:
	exx_						;		exx
	
	mov si, cx
	mov al, byte ptr ds:[si]	;		ld	a, (de)
	mov si, dx
	xor al, byte ptr ds:[si]	;		xor	(hl)
	mov [si], al				;		ld	(hl), a
	inc dl						;		inc	l
	inc cx 						;		inc	de
	mov si, cx
	mov al, byte ptr ds:[si]	;		ld	a, (de)
	mov si, dx
	xor al, byte ptr ds:[si]	;		xor	(hl)
	mov byte ptr ds:[si], al	;		ld	(hl), a
	inc dl						;		inc	l
	inc cx						;		inc	de
	mov si, cx
	mov al, byte ptr ds:[si]	;		ld	a, (de)
	xor al, byte ptr ds:[si]	;		xor	(hl)
	mov si, dx
	mov byte ptr ds:[si], al	;		ld	(hl), a
	inc dl						;		inc	l
	inc cx 						;		inc	de
	mov si, cx
	mov al, byte ptr ds:[si]	;		ld	a, (de)
	xor al, byte ptr ds:[si]	;		xor	(hl)
	mov si, dx
	mov byte ptr ds:[si], al	;		ld	(hl), a
	inc cx						;		inc	de
	dec dl						;		dec	l
	dec dl						;		dec	l
	dec dl						;		dec	l
	inc dh						;		inc	h
	mov al, dh					;		ld	a, h
	and al, bl					;		and	c
	jnz loc_785D				;		jr	nz, loc_785D
	mov al, dl					;		ld	a, l
	add al, 20h					;		add	a, 20h ; ' '
	mov dl, al					;		ld	l, a
	jc loc_785D					;		jr	c, loc_785D
	mov al, dh					;		ld	a, h
	sub al, 8					;		sub	8
	mov dh, al					;		ld	h, a

loc_785D:
	exx_						;		exx
	dec bh
	jz loc_785D1				;		djnz	loc_7814
	jmp loc_7814
loc_785D1:
	mov sp, word ptr ds:[_SAV_SP];		ld	sp, (_SAV_SP)
	pop cx						;		pop	de
	push cx						;		push de
	and al, al					;		and	a
	mov dx, offset byte_B101	;		ld	hl, byte_B101
	sbb dx, cx					;		sbc	hl, de
	jz loc_7897					;		jr	z, loc_7897
	mov si, dx
;;
	push cx
	push si
	push di
	
	mov dx, offset ShiftedSprites;	ld	hl, ShiftedSprites
	mov si, dx	; HL
	mov di, cx  ; DE
	mov cx,  16*8				;	ld	bc, 16*8	;128?? 8 SPRITES?

move_1_shifted_spr:
	cld
	rep movsb					;		ldi
	;movsb						;		ldi
	;movsb						;		ldi
	;movsb						;		ldi
	;movsb						;		ldi
	;movsb						;		ldi
	;movsb						;		ldi
	;movsb						;		ldi
	;movsb						;		ldi
	;movsb						;		ldi
	;movsb						;		ldi
	;movsb						;		ldi
	;movsb						;		ldi
	;movsb						;		ldi
	;movsb						;		ldi
	;movsb						;		ldi
	;jp move_1_shifted_spr		;		jp	pe, move_1_shifted_spr
	
	pop di
	pop si
	pop cx

loc_7897:
	pop dx						;		pop	hl
	pop si
	pop di						;		pop	ix
	pop cx 						;		pop	de
	pop bx						;		pop	bc
	pop ax						;		pop	af
	sahf
	ret

; =============== S U B	R O U T	I N E =======================================


mask24_hl_de_8:
	mov bh, 8					;		ld	b, 8

mask24_hl_de_a:
	mov si, dx
	mov al, byte ptr ds:[si]			;		ld	a, (hl)
	mov byte ptr ds:[spr_byte24_1+1], al;		ld	(spr_byte24_1+1), a
	inc dx								;		inc	hl
	
	mov si, dx
	mov al, byte ptr ds:[si]			;		ld	a, (hl)
	mov byte ptr ds:[spr_byte24_2+1], al;		ld	(spr_byte24_2+1), a
	inc dx 								;		inc	hl
	
	mov si, dx
	mov al, byte ptr ds:[si]			;		ld	a, (hl)
	mov byte ptr ds:[spr_byte24_3+1],al;		ld	(spr_byte24_3+1), a
;
	inc dx								;		inc	hl
	mov si, dx
	mov bl, byte ptr ds:[si]			;		ld	c, (hl)		; spr_byte24_4

loc_78B0:
	mov si, cx
	mov al, byte ptr ds:[si]			;		ld	a, (de)
spr_byte24_1:	
	and al,0							;		and	0
	mov si, cx
	mov byte ptr ds:[si],al				;		ld	(de), a
	inc cx 								;		inc	de
	mov si, cx
	mov al, byte ptr ds:[si]			;		ld	a, (de)
spr_byte24_2:	
	and al, 0							;		and	0
	mov si, cx
	mov byte ptr ds:[si], al			;		ld	(de), a
	inc cx								;		inc	de
	mov si, cx
	mov al, byte ptr ds:[si]			;		ld	a, (de)
spr_byte24_3:	
	and al, 0							;		and	0
	mov si, cx
	mov byte ptr ds:[si], al			;		ld	(de), a
	inc cx								;		inc	de
;
	mov si, cx
	mov al, byte ptr ds:[si]			;		ld	a, (de)
	and al, bl							;		and	c
	mov si, cx
	mov byte ptr ds:[si], al			;		ld	(de), a
	inc cx 								;		inc	de
;
	dec bh
	jnz loc_78B0						;		djnz	loc_78B0
;
	mov bx, 29							;		ld	bc, 29		;32-3
	add dx, bx							;		add	hl, bc
	ret 								;		ret

exx_table:
bx_save:		dw 0
cx_save:		dw 0
dx_save:		dw 0

_shif_jp_tab24:	
		dw shift24_0
		dw shift24_1
		dw shift24_2
		dw shift24_3
		dw shift24_4
		dw shift24_5
		dw shift24_6
		dw shift24_7
;
_SAV_SP:	
	dw 0;	_stack
;

ShiftedSprites:	
	db 128*2 dup (?) 	;ds 128
	;

