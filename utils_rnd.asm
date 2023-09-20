;original code - Rafaelle Cecco (c) 1987
;disassembled by Sergey Erokhin aka ESL - Nov-Dec 2014
;eslexolon@gmail.com
;https://bitbucket.org/esl/exolon-zx/
;licensed under a Creative Commons Attribution Share-Alike 3.0 (CC-BY-SA 3.0)

;return A-random number
RND:
push dx							;		push	hl
push cx							;		push	de
push bx							;		push	bc
mov dx, word ptr ds:[rndSEED]	;		ld	hl, (rndSEED)
mov cx, 7						;		ld	de, 7
add dx, cx						;		add	hl, de
mov cl, dl						;		ld	e, l
mov ch, dh						;		ld	d, h
add dx, dx						;		add	hl, hl
add dx, dx						;		add	hl, hl
mov bl, dl						;		ld	c, l
mov bh, dh						;		ld	b, h
add dx, dx						;		add	hl, hl
add dx, bx						;		add	hl, bc
add dx, cx						;		add	hl, de
mov word ptr ds:[rndSEED], dx	;		ld	(rndSEED), hl
xor al, dh						;		xor	h
pop bx							;		pop	bc
pop cx							;		pop	de
pop dx							;		pop	hl
		ret

rndSEED:	dw 8EAAh
