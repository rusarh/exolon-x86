;original code - Rafaelle Cecco (c) 1987
;disassembled by Sergey Erokhin aka ESL - Nov-Dec 2014
;eslexolon@gmail.com
;https://bitbucket.org/esl/exolon-zx/
;licensed under a Creative Commons Attribution Share-Alike 3.0 (CC-BY-SA 3.0)

ShowHiscoreTable:
	xor al,al								;		xor	a
	mov byte ptr ds:[HiScoreUpdatedFlag],al	;		ld	(HiScoreUpdatedFlag), a

ShowHiscoreTable2:
	mov bl, 44h								;		ld	c, 44h
	call	ClearScreen_fromback 			;		call	ClearScreen_fromback ; C - Attr	value
;
	mov si, offset xMSG_HighScoreScreen		;		ld	hl, xMSG_HighScoreScreen
	call	xMSG							;		call	xMSG
;
	mov si, offset HiscoreTable				;		ld	hl, HiscoreTable ; "RAFFAELE  001000"
	mov word ptr ds:[HiTabPTR], di			;		ld	(HiTabPTR), hl
;
	mov bx, 960								;		ld	bc, 960
	mov si, offset FNT_MAIN					;		ld	hl, FNT_MAIN
	mov word ptr ds:[FontPTR+1], si			;		ld	(FontPTR+1), hl

sht_loop:
	push bx									;		push	bc
	nop										;		nop
	nop										;		nop;		
	nop										;		nop
	mov al, bl								;		ld	a, c
	and al, 0fH								;		and	0Fh
	or al, al								;		or	a
;
	mov bx, 400h							;		ld	bc, 400h
	jz	mh1									;		call	nz, _delayLDIR
	call _delayLDIR
mh1:
	jnz mh2
	call nextHiScoreToScr					;		call	z, nextHiScoreToScr
mh2:
	call	ScrollHiScore_1_line			;		call	ScrollHiScore_1_line
;
	pop bx									;		pop	bc
	dec bx									;		dec	bc
	mov al, bh								;		ld	a, b
	or al, bl								;		or	c
	jnz mhs0								;		jp	z, xmenu
	jmp xmenu
;
mhs0:
	;call	GetKEY							;		call	GetKEY
	or al,al								;		or	a
	jz sht_loop								;		jp	z, sht_loop
;
	cmp al, '1'								;		cp	'1'
	;jz StartGame							;		jp	z, StartGame
;
	jmp	xmenu								;		jp	xmenu
; ---------------------------------------------------------------------------
include data_m~2.asm;	data_msg_high_score.asm;	include 	"data_msg_high_score.asm"

HiScoreUpdatedFlag:
		db 0

HiscoreTable:	db 'RAFFAELE  001000'
		db 'SURYANI   001000'
		db 'SCRAGGY   001000'
		db 'SABATTA!  001000'
		db 'PADDY     001000'
		db 'LOFTY     001000'
		db 'JIMBO     001000'
		db 'LEO       001000'
		db 'GLEN      001000'
		db 'MORANGE   001000'
		db 'PUPPY     001000'
		db 'ONION     001000'
		db 'RIP       001000'
		db 'FIGARO    001000'
		db 'INK       001000'
		db 'PEN       001000'
		db 'DUMBO     001000'
		db 'MEPHISTO  001000'
		db 'QUEEN     001000'
		db 'UNYIL ?   001000'
		db 'EQUINOX   001000'
		db 'REALMS    001000'
		db 'MAJALA    001000'
		db 'LENGKAP   001000'
		db 'JAZZ      001000'
		db 'HEWSON    001000'
		db 'TIM.M     001000'
		db 'CECCO     001000'
		db 'LUCY      001000'
		db 'ANTONY    001000'
		db 'NIAEREH   001000'
		db '*!/?!@    001000'
		db 'POD       001000'
		db 'HUTNEE    001000'
		db 'BUTNEE    001000'
		db 'JOHN.O    001000'
		db 'CARROT    001000'
		db 'COLIN     001000'
		db 'FLASH     001000'
		db 'SEVILLE   001000'
		db 'T-STATE   001000'
		db 'CLUB      001000'
		db 'HWP       001000'
		db 'CDP       001000'
		db 'TACHYON   001000'
		db 'KILLER    001000'
		db 'DROOPY    001000'
		db 'R 4 S     001000'
		db 'RZASM2    001000'
lastHiScoreROW:	db 'HUMPTY    001000'
;
HiscoreTable_StopByte:
		db 0FFh
;
hiTableTailBuffer:
		db 10h dup (?) 
; ---------------------------------------------------------------------------

ScrollHiScore_1_line:
;		push	bc
;		ld	(_SAV_SP), sp
;		ld	sp,  scr_addr_8+64	;scroll from 64 screen row
;		ld	bc, 159*14		;8B2h 14 bytes in row
;		pop	de

scroll_lp:
;		pop	hl
;		ld	(next_de+1), hl
;		ldi
;		ldi
;		ldi
;		ldi
;		ldi
;		ldi
;		ldi
;		ldi		;8 - name
;		inc	l	;skip 2 byte onscreen (for speedup?)
;		inc	e
;		inc	l
;		inc	e
;		ldi
;		ldi
;		ldi
;		ldi
;		ldi
;		ldi		;6 - score

next_de:	
;		ld	de, 0
;		jp	pe, scroll_lp
;
;		ld	sp, (_SAV_SP)
;		ex	de, hl
;		ld	e, l
;		ld	d, h
;		inc	e
;		ld	bc, 16	;10h
;		ld	(hl), b
;		ldir		;clear last line
;		pop	bc
		ret

; =============== S U B	R O U T	I N E =======================================


nextHiScoreToScr:
	mov si, word ptr ds:[HiTabPTR]	;	ld	hl, (HiTabPTR)
	mov al, byte ptr ds:[si]		;	ld	a, (hl)
	cmp al, 0ffh					;	cp	0FFh
	jnz nhsts0
	jmp _delayLDIR					;	jp	z, _delayLDIR	; BC
nhsts0:
	mov cx, 1708h					;	ld	de, 1708h
	mov bx, 1000h					;	ld	bc, 1000h

loc_7577:
	mov al, byte ptr ds:[si]		;	ld	a, (hl)
	call	putChar					;	call	putChar		; A - chr
;					; C - COLOR
;					; E-X
;					; D-Y
	inc cl							;	inc	e
	inc si							;	inc	hl
	dec bh
	jnz loc_7577					;	djnz	loc_7577
;
	mov word ptr ds:[HiTabPTR], si	;	ld	(HiTabPTR), hl
;
	mov bx, 28Eh					;		ld	bc, 28Eh
	jmp	_delayLDIR					;		jp	_delayLDIR	; BC
;
; ---------------------------------------------------------------------------
HiTabPTR:	dw 0
