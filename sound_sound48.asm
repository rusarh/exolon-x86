;original code - Rafaelle Cecco (c) 1987
;disassembled by Sergey Erokhin aka ESL - Nov-Dec 2014
;eslexolon@gmail.com
;https://bitbucket.org/esl/exolon-zx/
;licensed under a Creative Commons Attribution Share-Alike 3.0 (CC-BY-SA 3.0)

; =============== S U B	R O U T	I N E =======================================

sound48:
;		ld	a, (FlagZX128)	; 00 - zx48
;		or	a
;		ret	nz
		push ax
		in al, 61h
		mov ah, al

loc_7C2B:
		mov al, 00000000b    ; al = channel in bits 6 and 7, remaining bits clear
		out 043h, al         ; Send the latch command
 
		in al, 040h          ; al = low byte of count
		mov ah, al           ; ah = low byte of count
		in al, 040h          ; al = high byte of count
		rol ax, 8            ; al = low byte, ah = high byte (ax = current count)
	
;		in al, 41H
;		ld	a, r
		and al, 0FCh ;		and	11111000b
		mov ah, al
		
		in al, 61h
		;or al, ah
		or al, 3
		out 61h, al
;		out	(0FEh),	a

		mov cl, bh			;		ld	e, b
		inc cl				;		inc	e


loc_7C33:
		dec cl				;		dec	e
		jnz loc_7C33		;		jr	nz, loc_7C33
		xor al, al			;		xor	a
		
		in al, 61h
		and al, 11111100b
		out 61h, al
				;		out	(0FEh),	a
		dec bh
		jnz loc_7C2B		;		djnz	loc_7C2B
		
		pop ax
		ret

; =============== S U B	R O U T	I N E =======================================


sndBox48:
;		push	af
;		push	bc
;		push	de
;		push	hl
;		ld	a, (FlagZX128)	; 00 - zx48
;		or	a
;		jr	nz, loc_7C5A
;		xor	a
;		ld	de, 1030h

loc_7C4A:
;		ld	h, 0Ah

loc_7C4C:
;		xor	10h
;		out	(0FEh),	a
;		ld	b, e

loc_7C51:
;		djnz	$
;		dec	h
;		jr	nz, loc_7C4C
;		inc	e
;		dec	d
;		jr	nz, loc_7C4A

loc_7C5A:
;		pop	hl
;		pop	de
;		pop	bc
;		pop	af
		ret
