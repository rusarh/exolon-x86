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
	
	lahf
	push ax;		push	af
	push bx;		push	bc
	push cx;		push	de
	push dx;		push	hl
	push si
	push di;		push	ix
	
	push cx
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
	
	add dx,dx;		add	hl, hl ; my
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
	mov si, dx
	; ? xchg ch, cl
	
	pop cx
	call XY2SCR_ADDR ; CX = xy coord ;
	mov di, dx
	
	add di, 2   ;  <------------------------ CGA SHIFT
	
	; paint CGA
	mov cx, 16 ; Y size
l1:
	cld
	push cx
	mov cx, 24/8
	rep movsw
	
	add di, 02000h-(24/4)
	mov cx, 24/8
	
	rep movsw
	sub di, 02000h ;-(24/4)
	
	add di, 050h-(24/4)
	pop cx
	
	loop l1
	

loc_7897:
	pop di						;		pop	ix
	pop si
	pop dx						;		pop	hl
	pop cx 						;		pop	de
	pop bx						;		pop	bc
	pop ax						;		pop	af
	sahf
	
	ret

; =============== S U B	R O U T	I N E =======================================

exx_table:
bx_save:		dw 0
cx_save:		dw 0
dx_save:		dw 0

;
_SAV_SP:	
	dw 0;	_stack
;

ShiftedSprites:	
	db 128*2 dup (?) 	;ds 128
	;

