;	graphics_putchars.asm
;original code - Rafaelle Cecco (c) 1987
;disassembled by Sergey Erokhin aka ESL - Nov-Dec 2014
;eslexolon@gmail.com
;https://bitbucket.org/esl/exolon-zx/
;licensed under a Creative Commons Attribution Share-Alike 3.0 (CC-BY-SA 3.0)

; =============== S U B	R O U T	I N E =======================================

; C - color
; E-X
; D-Y

;вывесьти символ и установить noWalkFlag & over_player_tab
;они модифицируются из xMSG

; C - color = (BL)
; E-X = (CL)
; D-Y = (CH)

PurCharAndSetVarsChkX:

test cl, 020h	;		bit	5, e
jz z0		;		ret	nz
ret			;

z0:
lahf 	;		push	af
push ax
push cx ;		push	de
push dx ;		push	hl
push bx	;		push	bc
push si
add al,al ;		add	a, a
mov dl, al;		ld	l, a
mov dh, 0 ;		ld	h, 0
add dx,dx ;		add	hl, hl
add dx,dx ;		add	hl, hl		; *8

add dx,dx ;						; *2(CGA)

FontPTR:	

mov bx, offset FNT_MAIN	;		ld	bc, FNT_MAIN
nop
add dx, bx				;		add	hl, bc

;; CALC scr addr	- D,E
push ax
push dx
mov ax, 0140h
mov dl, ch
mov dh, 00
mul dx
mov dx, ax
mov ah, 0
mov al, cl
add dx, ax
add dx, ax
mov cx, dx
pop dx
pop ax

add cx, 10    		;  <------------------------ CGA SHIFT
;
mov bh, 8				;		ld	b, 8

char_lp:
mov si, dx
mov ax, word ptr ds:[si]	;		ld	a, (hl)
;
push bx
shr bl, 4
and bl, 7
cmp bl, 7
jz clrisset
and al, 055h
and ah, 055h
clrisset:
pop bx

mov si, cx
mov word ptr es:[si], ax	;		ld	(de), a
 					
					;		inc	d
cmp cx, 2000h
jb scrsc
sub cx,2000h
add cx,050h
jmp scrsc2
scrsc:
add cx,2000h
scrsc2:

inc dx						;		inc	hl
inc dx

dec bh
jnz char_lp					;		djnz	char_lp
;;cal ATTR addr
;; ... zx-specific

pop si
pop bx	

jmp endxmsg

noWalkFlag:	
mov si, 0
nop
nop
nop
nop
;mov byte ptr ds:[si], 1		;		ld	(hl), 1

;mov cx, 0;-0600h				;		ld	de, -600h	; 5B00 - over_player_tab
;add dx, cx					;		add	hl, de

overPlayerFlag:	
mov si, 0
nop
nop
nop
nop
;mov byte ptr ds:[si], 0;		ld	(hl), 0
endxmsg:
pop dx 	;		pop	hl
pop cx	;		pop	de
pop ax
sahf	;		pop	af

		ret

; =============== S U B	R O U T	I N E =======================================

; A - chr
; C - COLOR
; E-X
; D-Y

putChar:

lahf		;		push	af
push ax
push cx		;		push	de
push dx		;		push	hl
push bx		;		push	bc
push si
add al, al	;		add	a, a
mov dl, al	;		ld	l, a
mov dh, 0	;		ld	h, 0
add dx, dx 	;		add	hl, hl
add dx, dx	;		add	hl, hl
add dx,dx ;						; *2(CGA)
mov bx, word ptr ds:[FontPTR+1];		ld	bc, (FontPTR+1)
add dx, bx	;		add	hl, bc

;		ld	a, d
;		and	0F8h ; 'ш'
;		or	40h ; '@'
;		ld	b, a
;		ld	a, d
;		ld	d, b
;		and	7
;		rrca
;		rrca
;		rrca
;		add	a, e
;		ld	e, a
;		ld	b, 8

;loc_AE46:
;		ld	a, (hl)
;		ld	(de), a
;		inc	d
;		inc	hl
;		djnz	loc_AE46
;		dec	d
;		ld	a, d
;		rrca
;		rrca
;		rrca
;		and	3
;		or	58h ; 'X'
;		ld	h, a
;		ld	l, e
;		pop	bc
;		ld	(hl), c

;; CALC scr addr	- D,E
push ax
push dx
mov ax, 0140h
mov dl, ch
mov dh, 00
mul dx
mov dx, ax
mov ah, 0
mov al, cl
add dx, ax
add dx, ax
mov cx, dx
pop dx
pop ax

add cx, 10
;
mov bh, 8				;		ld	b, 8

char_lp2:
	mov si, dx
	mov ax, word ptr ds:[si]	;		ld	a, (hl)
	;
	push bx
	shr bl, 4
	and bl, 7
	cmp bl, 7
jz clrisset2
	and al, 0aah
	and ah, 0aah
clrisset2:
	pop bx
	mov si, cx
	mov word ptr es:[si], ax	;		ld	(de), a
						
							;		inc	d
	cmp cx, 2000h
	jb scrsc12
	sub cx,2000h
	add cx,050h
	jmp scrsc22
scrsc12:
	add cx,2000h
scrsc22:

	inc dx						;		inc	hl
	inc dx

	dec bh
	jnz char_lp2

	pop si
	pop bx	
	pop dx;		pop	hl
	pop cx;		pop	de
	pop ax
	sahf  ;		pop	af
		ret
; End of function putChar


; =============== S U B	R O U T	I N E =======================================
; A - chr
; C - COLOR
; E-X
; D-Y
;same as putChar but XOR instead set
;putCharXOR:
;		push	af
;		push	de
;		push	hl
;		push	bc
;		add	a, a
;		ld	l, a
;		ld	h, 0
;		add	hl, hl
;		add	hl, hl
;		ld	bc, (FontPTR+1)
;		add	hl, bc
;		ld	a, d
;		and	0F8h ; 'ш'
;		or	40h ; '@'
;		ld	b, a
;		ld	a, d
;		ld	d, b
;		and	7
;		rrca
;		rrca
;		rrca
;		add	a, e
;		ld	e, a
;		ld	b, 8

;loc_AE7D:
;		ld	a, (de)
;		xor	(hl)
;		ld	(de), a
;		inc	d
;		inc	hl
;		djnz	loc_AE7D
;		dec	d
;		ld	a, d
;		rrca
;		rrca
;		rrca
;		and	3
;		or	58h ; 'X'
;		ld	h, a
;		ld	l, e
;		pop	bc
;		ld	(hl), c
;		pop	hl
;		pop	de
;		pop	af
		ret
; End of function putCharXOR


; =============== S U B	R O U T	I N E =======================================

;используется для стирания объектов
;очищает таблицу занятости 
;и заодно добавляет две части взырва
;уничтожение активных объектов

;PutCharXorRemoveObject_2boom:

;		bit	5, e
;		ret	nz
;
;		push	af
;		push	de
;		push	hl
;		push	bc
;		add	a, a
;		ld	l, a
;		ld	h, 0
;		add	hl, hl
;		add	hl, hl
;		ld	bc, (FontPTR+1)
;		add	hl, bc
;		ld	a, d
;		and	0F8h ; 'ш'
;		or	40h ; '@'
;		ld	b, a
;		ld	a, d
;		ld	d, b
;		and	7
;		rrca
;		rrca
;		rrca
;		add	a, e
;		ld	e, a
;		ld	b, 8

;loc_AEB8:
;		ld	a, (de)
;		xor	(hl)
;		ld	(de), a
;		inc	d
;		inc	hl
;		djnz	loc_AEB8
;		dec	d
;		ld	a, d
;		rrca
;		rrca
;		rrca
;		and	3
;		ld	h, a
;		ld	l, e
;		ld	de, over_player_tab
;		add	hl, de
;		pop	bc
;		ld	(hl), 0FFh
;		ld	de, 300h	; 5b00
;		add	hl, de
;		ld	(hl), 0
;		ld	de, 300h	; 6100
;		add	hl, de
;		ld	(hl), 0
;		pop	hl
;		pop	de
;		pop	af
;		call	add_explosion_particle ; e-x (/4)
					; d-y (/8)
;		jp	add_explosion_particle ; e-x (/4)

; ---------------------------------------------------------------------------
;используется для стирания объектов
;очищает таблицу занятости  
;бех взырва

;PutCharXorRemoveObject_noBoom:
;		push	af
;		push	de
;		push	hl
;		push	bc
;		add	a, a
;		ld	l, a
;		ld	h, 0
;		add	hl, hl
;		add	hl, hl
;		ld	bc, (FontPTR+1)
;		add	hl, bc
;		ld	a, d
;		and	0F8h ; 'ш'
;		or	40h ; '@'
;		ld	b, a
;		ld	a, d
;		ld	d, b
;		and	7
;		rrca
;		rrca
;		rrca
;		add	a, e
;		ld	e, a
;		ld	b, 8

;loc_AF04:
;		ld	a, (de)
;		xor	(hl)
;		ld	(de), a
;		inc	d
;		inc	hl
;		djnz	loc_AF04
;		dec	d
;		ld	a, d
;		rrca
;		rrca
;		rrca
;		and	3
;		ld	h, a
;		ld	l, e
;		ld	de, over_player_tab
;		add	hl, de
;		pop	bc
;		ld	(hl), 0FFh
;		ld	de, 300h	; 5b00
;		add	hl, de
;		ld	(hl), 0
;		ld	de, 300h	; 6100
;		add	hl, de
;		ld	(hl), 0
;		pop	hl
;		pop	de
;		pop	af
		ret
