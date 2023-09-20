playBeeperMusic:
		xor ax,ax;		xor	a
		;in	a, (0FEh)
		;cpl
		;and	1Fh
		;jr	nz, playBeeperMusic
		
		cli
		mov     al, 182; 0b6h ;          ; Prepare the speaker for the
        out     43h, al         ;  note.
        mov     ax, 1;          ; Frequency number (in decimal)
                                ;  for middle C.
        out     42h, al         ; Output low byte.
        mov     al, ah          ; Output high byte.
        out     42h, al  
		
		in al, 61h
		and al, 0fch
		out 61h, al
		mov byte ptr ds:[stat_61h], al
		
		xor ax,ax
		
		mov dx, offset  menuMusic;musicGameOver;
		mov word ptr ds:[NoteAddr], DX; ld	(NoteAddr), hl

check_key:
		push ax
		mov ax, 0100h
		int 16h
		pop ax
		jz loc_7D2D; jz loc_7D2D
		
exit_proc:
		STI
		in      al, 61h       ; 
        and     al, 11111100b ;
        out     61h, al       ; 
		ret
; ---------------------------------------------------------------------------

loc_7D2D:
	mov DI, word ptr ds:[NoteAddr];		ld	hl, (NoteAddr)
	mov AL, byte ptr ds:[DI];			ld	a, (hl)
    OR AL, AL;							or	a
	JNZ loc_7D2D1;						jp	z, locret_7D2C
	jmp exit_proc;
loc_7D2D1:
	INC DI	;							inc	hl
	MOV BYTE PTR ds:[byte_7FEE], AL	;	ld	(byte_7FEE), a
	MOV BL, BYTE PTR ds:[DI];			ld	c, (hl)
	INC DI							;	inc	hl
	MOV BH,BYTE PTR DS:[DI];			ld	b, (hl)
	INC DI	;							inc	hl
	MOV WORD PTR DS:[NoteAddr], DI;		ld	(NoteAddr), hl
	MOV DX, DI
	MOV AL, BL;							ld	a, c
	OR  AL, BH;							or	b
	JNZ loc_7D4E;						jp	nz, loc_7D4E
	MOV AL, byte ptr ds:[byte_7FEE];	ld	a, (byte_7FEE)
	call	sub_8004
	jmp	check_key
; ---------------------------------------------------------------------------

loc_7D4E:
	MOV DH,0;					ld	h, 0
	MOV DL, BL;	;				ld	l, c
	MOV CX, offset Notes;	ld	de, byte_8062
	ADD DX, CX;					add	hl, de
	mov di, dx;
	MOV CH, BYTE PTR DS:[DI];	ld	d, (hl)
	MOV DH, 0;	ld	h, 0
	MOV DL, BH;	ld	l, b
	MOV BX, offset 	Notes; ld	bc, byte_8062
	ADD DX, BX;	add	hl, bc
	MOV DI, DX
	MOV CL, byte ptr ds:[DI];	ld	e, (hl)
	MOV AL, byte ptr ds:[byte_7FEE];	ld	a, (byte_7FEE)
	call	sub_803D
	jmp	check_key; jp	loc_7D22

; ---------------------------------------------------------------------------

flag_BeeperMenuMusic:db	0
;musicGameOver:	db  0Fh, 1Ch, 28h, 0Fh,	1Ch, 2Ch, 0Fh, 1Ch, 2Fh, 0Fh, 1Bh, 27h,	0Fh, 1Bh, 2Bh, 0Fh; 0;
;		db  1Bh, 2Eh, 0Fh, 1Ah,	26h, 0Fh, 1Ah, 2Ah, 0Fh, 1Ah, 2Dh, 0Fh,	19h, 25h, 0Fh, 19h; 16
;		db  29h, 0Fh, 19h, 2Ch,	0Fh, 18h, 24h, 0Fh, 18h, 28h, 0Fh, 18h,	2Bh, 0Fh, 17h, 23h; 32
;		db  0Fh, 17h, 27h, 0Fh,	17h, 2Ah, 2Dh, 1Ch, 28h,   0,	0; 48

musicGameOver:
		db 0Fh, 1Ch, 28h, 0Fh,	1Ch, 2Ch, 0Fh, 1Ch, 2Fh, 0Fh, 1Bh, 27h,	0Fh, 1Bh, 2Bh, 0Fh
		db 1Bh, 2Eh, 0Fh, 1Ah,	26h, 0Fh, 1Ah, 2Ah, 0Fh, 1Ah, 2Dh, 0Fh,	19h, 25h, 0Fh, 19h
		db 29h, 0Fh, 19h, 2Ch,	0Fh, 18h, 24h, 0Fh, 18h, 28h, 0Fh, 18h,	2Bh, 0Fh, 17h, 23h
		db 0Fh, 17h, 27h, 0Fh,	17h, 2Ah, 2Dh, 1Ch, 28h, 0
;
MenuMusic:
		db 12h, 13h, 2Bh, 12h,	13h, 26h, 12h, 13h, 2Bh, 12h, 13h, 2Fh,	24h, 13h, 32h, 24h
		db 13h, 26h, 24h, 18h,	28h, 12h, 18h, 30h, 12h, 18h, 2Fh, 12h,	18h, 30h, 12h, 18h
		db 2Fh, 24h, 18h, 2Dh,	12h, 1Ah, 2Dh, 12h, 1Ah, 2Ah, 12h, 1Ah,	2Bh, 24h, 1Ah, 2Dh
		db 12h, 1Ah, 2Ah, 24h,	1Ah, 26h, 24h, 13h, 30h, 12h, 13h, 30h,	36h, 13h, 2Fh, 24h
		db 13h, 2Bh, 12h, 13h,	2Bh, 12h, 13h, 26h, 12h, 13h, 2Bh, 12h,	13h, 2Fh, 24h, 13h
		db 32h, 24h, 13h, 26h,	24h, 18h, 28h, 12h, 18h, 30h, 12h, 18h,	2Fh, 12h, 18h, 30h
		db 12h, 18h, 2Fh, 24h,	18h, 2Dh, 12h, 1Ah, 2Dh, 12h, 1Ah, 2Ah,	12h, 1Ah, 2Bh, 24h
		db 1Ah, 2Dh, 12h, 1Ah,	2Ah, 24h, 1Ah, 26h, 24h, 13h, 30h, 12h,	13h, 30h, 36h, 13h
		db 2Fh, 24h, 13h, 2Dh,	24h, 10h, 2Bh, 24h, 10h, 23h, 24h, 10h,	2Bh, 12h, 10h, 23h
		db 24h, 10h, 2Fh, 12h,	10h, 23h, 12h, 10h, 2Fh, 12h, 10h, 23h,	12h, 10h, 2Dh, 12h
		db 10h, 23h, 12h, 10h,	2Bh, 12h, 10h, 23h, 24h, 0Ch, 2Bh, 24h,	0Ch, 24h, 24h, 0Ch
		db 2Bh, 12h, 0Ch, 24h,	24h, 0Ch, 2Fh, 12h, 0Ch, 24h, 12h, 0Ch,	2Fh, 12h, 0Ch, 24h
		db 12h, 0Ch, 2Dh, 12h,	0Ch, 24h, 12h, 0Ch, 2Bh, 12h, 0Ch, 24h,	24h, 10h, 2Bh, 24h
		db 10h, 23h, 24h, 10h,	2Bh, 12h, 10h, 23h, 24h, 10h, 2Fh, 12h,	10h, 23h, 12h, 10h
		db 2Fh, 12h, 10h, 23h,	12h, 10h, 2Dh, 12h, 10h, 23h, 12h, 10h,	2Bh, 12h, 10h, 23h
		db 24h, 0Ch, 2Bh, 24h,	0Ch, 24h, 24h, 0Ch, 2Bh, 12h, 0Ch, 24h,	24h, 0Ch, 2Fh, 12h
		db 0Ch, 24h, 12h, 0Ch,	2Fh, 12h, 0Ch, 24h, 12h, 0Ch, 2Dh, 12h,	0Ch, 24h, 12h, 0Ch
		db 2Bh, 12h, 0Ch, 24h,	24h, 10h, 2Fh, 24h, 10h, 30h, 12h, 10h,	2Dh, 24h, 10h, 2Fh
		db 24h, 10h, 2Bh, 24h,	10h, 2Dh, 24h, 10h, 2Ah, 12h, 10h, 2Fh,	24h, 10h, 28h, 24h
		db 10h, 2Fh, 24h, 10h,	30h, 12h, 10h, 2Dh, 24h, 10h, 2Fh, 24h,	10h, 2Bh, 24h, 10h
		db 2Dh, 24h, 10h, 2Ah,	12h, 10h, 2Fh, 24h, 10h, 28h, 24h, 0Ch,	2Dh, 12h, 0Ch, 2Dh
		db 5Ah, 0Ch, 2Bh, 24h,	0Ch, 18h, 12h, 0Ch, 2Bh, 24h, 0Ch, 2Dh,	12h, 0Ch, 2Dh, 24h
		db 0Ch, 2Bh, 24h, 7, 28h, 12h,	7, 28h,	5Ah, 7,	26h, 24h, 7, 13h, 12h, 7
		db 26h, 24h, 7, 28h, 12h, 7, 28h, 24h,	7, 26h,	24h, 10h, 2Fh, 24h, 10h, 30h
		db 12h, 10h, 2Dh, 24h,	10h, 2Fh, 24h, 10h, 2Bh, 24h, 10h, 2Dh,	24h, 10h, 2Ah, 12h
		db 10h, 2Fh, 24h, 10h,	28h, 24h, 10h, 2Fh, 24h, 10h, 30h, 12h,	10h, 2Dh, 24h, 10h
		db 2Fh, 24h, 10h, 2Bh,	24h, 10h, 2Dh, 24h, 10h, 2Ah, 12h, 10h,	2Fh, 24h, 10h, 28h
		db 24h, 0Ch, 2Dh, 12h,	0Ch, 2Dh, 5Ah, 0Ch, 2Bh, 24h, 0Ch, 18h,	12h, 0Ch, 2Bh, 24h
		db 0Ch, 2Dh, 12h, 0Ch,	2Dh, 24h, 0Ch, 2Bh, 24h, 7, 28h, 12h, 7, 28h, 5Ah, 7
		db 26h, 24h, 7, 13h, 12h, 7, 26h, 24h,	7, 28h,	12h, 7,	26h, 12h, 7, 28h
		db 12h, 7, 26h, 48h, 11h, 24h,	48h, 11h, 21h, 24h, 11h, 24h, 12h, 11h,	21h, 24h
		db 11h, 24h, 12h, 11h,	21h, 12h, 11h, 28h, 12h, 11h, 26h, 48h,	0Ch, 24h, 48h, 0Ch
		db 1Fh, 24h, 0Ch, 24h,	12h, 0Ch, 1Fh, 24h, 0Ch, 24h, 12h, 0Ch,	1Fh, 12h, 0Ch, 28h
		db 12h, 0Ch, 26h, 24h,	11h, 24h, 24h, 11h, 21h, 24h, 11h, 24h,	24h, 11h, 21h, 24h
		db 11h, 24h, 12h, 11h,	21h, 24h, 11h, 24h, 12h, 11h, 21h, 12h,	11h, 28h, 12h, 11h
		db 26h, 24h, 0Ch, 24h,	24h, 0Ch, 1Fh, 24h, 0Ch, 24h, 24h, 0Ch,	1Fh, 12h, 0Ch, 24h
		db 12h, 0Ch, 30h, 12h,	0Ch, 30h, 24h, 0Ch, 24h, 0
byte_7FEE:	db 0EEh
NoteAddr:	dw 0
stat_61h:	db 0, 0
; ---------------------------------------------------------------------------

loc_7FF1:
		and	AL, 0ffh; 		and	0FFh
		ex_af 				;xchg AL, AH; 		ex	af, af'
		inc ch; 			inc	d
		jnz loc_801F;		jp	nz, loc_801F

loc_7FF8:
		nop
		nop
		nop
		xor	al, bl 	;	xor	c
		mov ch, dl	;	ld	d, l
		dec bh ; 		dec b
		JNZ loc_800E;	djnz	loc_800E
		dec dh;			dec	h
		jnz loc_8010;	jp	nz, loc_8010
		ret

sub_8004:
		mov dh, al		;ld	h, a
		mov bl, cl		;ld c, e; 	ld	ixl, e
		mov dl, ch 		;ld	l, d
		
		;mov bl, 3		;ld	c, 10h
		xor al,al; 		;xor	a
		
		xor al,al; 		;xor	a
		ex_af 			;ex	af, af'
		xor al,al;		;xor	a
		mov bh,al		;ld	b, a

loc_800E:
		or al,al	;or	a
		and al,al	;and	a

loc_8010:
		ex_af 		;ex	af, af'
		inc cl		;inc	e
		nop
		nop
		nop
		jnz loc_7FF1		;jr	nz, loc_7FF1
		xor al, 3 			;xor	c
		mov cl, bl		;ld	e, ixl
		ex_af			;ex	af, af'
		inc ch			;inc	d
		jz loc_7FF8 	;jp	z, loc_7FF8

loc_801F:
		nop
		nop
		nop
		or al,al		;or	a
		and al,al		;and	a
		dec bh			;djnz	loc_800E
		jnz loc_800E;
		dec dh			;dec	h
		jnz loc_8010	;jp	nz, loc_8010
		ret

; ---------------------------------------------------------------------------

loc_802B:
		and al, 0ffh		;and	0FFh
		ex_af				;ex	af, af'
		inc ch;				;inc	d
		jnz loc_8057		;jp	nz, loc_8057

loc_8032:
		
		;in al, 61h
		or al, byte ptr ds:[stat_61h]; 2		;or al, 04ch
		out [61h], al		;out	(0FEh),	a

		xor al, 3			;xor	c
		mov ch, dl			;ld	d, l
		dec bh				;	
		jnz loc_8047		;djnz	loc_8047
		dec dh				;dec	h
		jnz loc_8049		;jp	nz, loc_8049
		ret

; =============== S U B	R O U T	I N E =======================================


sub_803D:

		mov dh, al		;ld	h, a
		mov bl, cl		;ld	ixl, e
		mov dl, ch		;ld	l, d
		
		mov bl,bl 		;ld	c, 10h
		
		xor al,al		;xor	a
		ex_af			;xchg ah,al		;ex	af, af'
		xor al,al		;xor	a
		mov bh, al		;ld	b, a

loc_8047:
		or al,al		;or	a
		and al,al		;and	a

loc_8049:
		ex_af 			; xchg ah,al;	ex	af, af'

		;in al, 61h
		or al, byte ptr ds:[stat_61h]; 2		;or al, 04ch
		out 61h, al	;out	(0FEh),	a
		
;16.08	;;	or al,al		; my
		or al,al		; my
		
		inc cl			;inc	e
		jnz loc_802B	;jr	nz, loc_802B
		xor al, 3		;xor	c
		mov cl, bl		;ld	e, ixl
		ex_af			;xchg ah,al		;ex	af, af'
		
		inc ch			;inc	d
		jz loc_8032		;jp	z, loc_8032

loc_8057:
		
		;in al, 61h
		or al, byte ptr ds:[stat_61h]		;2		;or al, 04ch
		out 061h, al	;out	(0FEh),	a
	
;16.08	;		or al,al		;or	a
		;// раскоментировать для усиления 'басовой' партии
		;and al,al		;and	
		
		dec bh
		jnz loc_8047	;djnz	loc_8047
		dec dh			;dec	h
		jnz loc_8049	;jp	nz, loc_8049
		ret

; ---------------------------------------------------------------------------	
;Notes:;
;		db     255,240,227,215,204,192,181,172,161,151,144
;		db 136,128,121,114,108,102, 96, 91, 86, 81, 76, 72
;		db  68, 64, 60, 57, 54, 51, 48, 45, 43, 40, 38, 36
;		db  34, 32, 30, 28, 27, 25, 24, 23, 21, 20, 19, 18
;		db  17, 16, 15, 14, 13, 12
		
Notes:	db   1,	16, 29,	41, 52,	64, 76,	84, 95,105,112,120,128,135,142,148; 0
		db 154,160,165,170,175,180,184,188,192,195,199,202,205,208,211,213; 16
		db 216,218,220,222,224,226,228,229,231,232,233,235,236,237,238,239; 32
		db 240,241,242,243,244	; 48
