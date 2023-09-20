;original code - Rafaelle Cecco (c) 1987
;disassembled by Sergey Erokhin aka ESL - Nov-Dec 2014
;eslexolon@gmail.com
;https://bitbucket.org/esl/exolon-zx/
;licensed under a Creative Commons Attribution Share-Alike 3.0 (CC-BY-SA 3.0)

initBitSwapTab:
		mov ax, 0
		mov bx, offset bitSwapTab;		ld	hl, bitSwapTab	; swapped bits

loc_7B9C:
		mov ch, bl;		ld	d, l
		mov ah, 8 ;		ld	b, 8

loc_7B9F:
		shr ch, 1;		srl	d
		rcl al, 1;		rl	c
		
		dec ah
		jnz loc_7B9F;		djnz	loc_7B9F
		;
		mov byte ptr ds:[bx], al;		ld	(hl), c
		inc bl					;		inc	l
		jnz loc_7B9C;					jr	nz, loc_7B9C
		ret

; =============== S U B	R O U T	I N E =======================================

; Swap sprites to left/right when move in left/right directions

swapBigSprite:
		nop
		nop
		pushf
		push ax;		push	af
		push bx;		push	bc
		push cx;		push	de
		push dx;		push	hl
		push si;
		push di
		
		mov al, byte ptr ds:[playerSpriteDirection] ;		ld	a, (playerSpriteDirection) ;	0 - to right, 1	- to left
		xor al, dl									;		xor	1
		mov byte ptr ds:[playerSpriteDirection], al ;		ld	(playerSpriteDirection), a ;	0 - to right, 1	- to left
;
		mov si, offset PLAYER_WALK ;		ld	hl, PLAYER_WALK	; 10 phases
		mov bx, offset bitSwapTab ; 64h			;		ld	d, 64h ; 'd'    ; 6400 - bitSwapTab
		mov cx, 24*10			;		ld	bc, 768 (32*24)

;
;  original A,B,C converted to swapped (') C',B',A'
;  1111000 10101010 0001011 -> 11010000 01010101 00001111
;

loc_7BBE:
		push cx;		push	bc
		;push si;		push	hl
		
		mov di, si
		mov cx, 6
		
loc_7BBE_x:
		mov bl, byte ptr ds:[si];		ld	e, (hl)	;1
		mov al, byte ptr ds:[bx];		ld	a, (de)
		mov byte ptr ds:[si], al
		inc si					;		inc	hl
		loop loc_7BBE_x
		
		mov ax, word ptr ds:[di]
		mov cx, word ptr ds:[di+2] 
		mov dx, word ptr ds:[di+4]
		xchg ah, dl
		xchg cl, ch
		xchg dh, al
		mov word ptr ds:[di], ax
		mov word ptr ds:[di+2], cx
		mov word ptr ds:[di+4], dx
		
		pop cx			
		loop loc_7BBE			;		jp	nz, loc_7BBE
		
		pop di
		pop si
		pop dx;		pop	hl
		pop cx;		pop	de
		pop bx;		pop	bc
		pop ax;		pop	af
		popf
		
		ret
; ---------------------------------------------------------------------------
playerSpriteDirection:
		db 0		; 0 - to right,	1 - to left
