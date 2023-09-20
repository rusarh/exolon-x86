; C - color = (BL)
; E-X = (CL)
; D-Y = (CH)

PurCharAndSetVarsChkX:

test cl, 020h	;		bit	5, e
jz z0		;		ret	nz
ret			;

z0:
pushf 	;		push	af
push cx ;		push	de
push dx ;		push	hl
push bx	;		push	bc
add al,al ;		add	a, a
mov dl, al;		ld	l, a
mov dh, 0 ;		ld	h, 0
add dx,dx ;		add	hl, hl
add dx,dx ;		add	hl, hl		; *8
add dx,dx ;		add	hl, hl

FontPTR:	

mov bx, offset FNT_MAIN	;		ld	bc, FNT_MAIN
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

add cx, 10
;
mov bh, 8				;		ld	b, 8

char_lp:
mov si, dx
mov ax, word ptr ds:[si]	;		ld	a, (hl)
;
;193:2d6e ; clr = 79 ; D9;
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
;dec ch						;		dec	d
;mov al, ch 					;		ld	a, d
;shr al,3					;		rrca
							;		rrca
							;		rrca
;and al, 3					;		and	3
;
;or al, 058h	;or al, 058h					;		or	58h ; 'X'       ; 5800 - ATTR_TABLE
;mov dh, al					;		ld	h, a
;mov dl, cl					;		ld	l, e
pop bx						;		pop	bc
;mov si, dx
;mov byte ptr ds:[si], bl	;		ld	(hl), c
;
;mov cx, 0900h				;		ld	de, 900h	; 6100 - no_walk_tab
;add dx, cx					;		add	hl, de

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

pop dx 	;		pop	hl
pop cx	;		pop	de
popf	;		pop	af

		ret
