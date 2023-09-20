;original code - Rafaelle Cecco (c) 1987
;disassembled by Sergey Erokhin aka ESL - Nov-Dec 2014
;eslexolon@gmail.com
;https://bitbucket.org/esl/exolon-zx/
;licensed under a Creative Commons Attribution Share-Alike 3.0 (CC-BY-SA 3.0)

key_buff:
db 16 dup(90h) 

_ctrl_KBD:
		mov ch, 1 ;		ld	d, 1
		mov si, offset key_LEFT-1 ;		ld	hl, key_LEFT-1 	;locret_7B91
	;	mov bl, 060h	;		ld	c, 0FEh 	;xxFE
		
		mov ax, 1
		int 16h
;		mov word ptr ds:[key_buff+4], ax
KeyScanCodes:
k_chk_LEFT:
		inc si;		inc	hl
		cmp al, 111 ; 'o'
;mov ch, 0dfh;		ld	b, 0DFh 	;YUIOP
;in al, bl;		in	a, (c)
;		and	2		;O
		jnz k_chk_RIGHT;		jr	nz, k_chk_RIGHT
		mov [si],ch		;		ld	(hl), d; ds:[E8A6]=0001  
		mov ah,99h
		int 21h

k_chk_RIGHT:
		inc si;		inc	hl
		cmp al, 112 ;	'p'
;		ld	b, 0DFh		;YUIOP
;		in	a, (c)
;		and	1		;P
		jnz k_chk_UP;		jr	nz, k_chk_UP
		mov [si],ch ;		ld	(hl), d ; ds:[E8A7]=0001 
		mov ah,98h
		int 21h

k_chk_UP:
		inc si;		inc	hl
;		ld	b, 0FBh		;TREWQ
;		in	a, (c)
;		and	1		;Q
;		jr	nz, k_chk_DOWN
;		mov [si],ch		;		ld	(hl), d

k_chk_DOWN:
		inc si;		inc	hl
;		ld	b, 0FDh		;GFDSA
;		in	a, (c)
;		and	1		;A
;		jr	nz, k_chk_FIRE
;		mov [si],ch		;		ld	(hl), d

k_chk_FIRE:
		inc si;		inc	hl
;		ld	b, 7Fh		;BNM SS SP
;		in	a, (c)
;		and	4		;M
;		ret	nz
;		mov [si],ch		;		ld	(hl), d
		ret
; ---------------------------------------------------------------------------

_ctrl_IFF2:
;		ld	bc, 0EFFEh
;		in	a, (c)		;67890 - LRDUF
;		cpl
;		and	1Fh
;		ld	d, a
;		call	shiftDtoA
;		ld	(key_FIRE), a
;		call	shiftDtoA
;		ld	(key_UP), a
;		call	shiftDtoA
;		ld	(key_DOWN), a
;		call	shiftDtoA
;		ld	(key_RIGHT), a
;		call	shiftDtoA
;		ld	(key_LEFT), a
		ret
; ---------------------------------------------------------------------------

_ctrl_KEMPSTON:
;		ld	c, 1Fh
;		in	d, (c) 		; 000FUDLR
;		call	shiftDtoA
;		ld	(key_RIGHT), a
;		call	shiftDtoA
;		ld	(key_LEFT), a
;		call	shiftDtoA
;		ld	(key_DOWN), a
;		call	shiftDtoA
;		ld	(key_UP), a
;		call	shiftDtoA
;		ld	(key_FIRE), a
		ret

; =============== S U B	R O U T	I N E =======================================


shiftDtoA:
;		xor	a
;		srl	d
;		rla
		ret

; =============== S U B	R O U T	I N E =======================================


chk_KEYS:
		call	clrKEYS
		mov al,byte ptr ds:[active_control] ;		ld	a, (active_control)
		or al,al							;		or	a
		jmp  _ctrl_KBD ;jz _ctrl_KBD						;		jp	z, _ctrl_KBD
		cmp al,1							;		cp	1
		jz _ctrl_IFF2						;		jp	z, _ctrl_IFF2
		jmp _ctrl_KEMPSTON					;		jp	_ctrl_KEMPSTON

; =============== S U B	R O U T	I N E =======================================


clrKEYS:
;		ld	hl, key_LEFT
;		ld	de, key_RIGHT
;		ld	(hl), 0
;		ld	bc, 4
;		ldir
		mov byte ptr ds:[key_LEFT],  0
		mov byte ptr ds:[key_RIGHT], 0
		mov byte ptr ds:[key_UP],    0
		mov byte ptr ds:[key_DOWN],  0
		mov byte ptr ds:[key_FIRE],  0
		ret
		
		nop
		nop
; ---------------------------------------------------------------------------

key_LEFT:	db 0
key_RIGHT:	db 0
key_UP:		db 0
key_DOWN:	db 0
key_FIRE:	db 0

active_control:	db 0

;UNUSED
byte_7B98:	db 0

