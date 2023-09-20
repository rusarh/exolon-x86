;original code - Rafaelle Cecco (c) 1987
;disassembled by Sergey Erokhin aka ESL - Nov-Dec 2014
;eslexolon@gmail.com
;https://bitbucket.org/esl/exolon-zx/
;licensed under a Creative Commons Attribution Share-Alike 3.0 (CC-BY-SA 3.0)

DefineKeys:
;		call	psg_mute
		call	ClearToBLACK
;		call	clr_no_walk_tab
;		call	clr_over_player_tab
;		ld	bc, 1Fh
;		ldir
		xor al, al 							;		xor	a
		mov byte ptr ds:[active_control],al	;		ld	(active_control), a
		mov dx, offset xMSG_KeySelect		;		ld	hl, xMSG_KeySelect
		call	xMSG
;;
;		call	_save_attr_table
		call	clr_SpriteBuffers
;		call	clr_menuStars
;
		mov si, offset key_buff	 	 ;		ld	ix, KeyScanCodes
		mov di, offset CheatKeyBuffer;		ld	iy, CheatKeyBuffer
		mov cx, 090Fh	;scr-pos			 ;X-Y;	ld	de, 90Fh
		mov bh, 5					 ;		ld	b, 5

loc_6FDC:
		push bx				;		push	bc
		mov al, '?'			;		ld	a, '?'
		mov bl, 44h			;		ld	c, 44h
		call	PurCharAndSetVarsChkX
		
		push cx				;		push	de

		call	waitKEY

loc_6FE8:
		call	GetKEY
		or al, al			;		or	a
		jz loc_6FE8			;		jr	z, loc_6FE8
		
		and al, 7Fh
		or al,al
		jz loc_6FE8
		
		cmp al, 60h
		jb loc_6FE81
		sub al, 20h
		
		or al, al
		jz loc_6FE8
		
loc_6FE81:		
		;mov byte ptr ds:[si], ch 	;		ld	(ix+2),	d
		;mov byte ptr ds:[si+1], cl	;		ld	(ix+6),	e
		mov cx, 0AH			;		ld	de, 0Ah
		add si, cx			;		add	ix, de
		mov byte ptr ds:[di], al	;		ld	(iy+0),	a
		inc	di				;		inc	iy
		
		pop cx				;		pop	de
		
		mov dx, offset aEnteredKEY	;		ld	hl, aEnteredKEY
		cmp al, ' '			;		cp	' '
		jnz loc_7009		;		jr	nz, loc_7009
		mov dx, offset aSpace		;		ld	hl, aSpace	; "SPACE"
 
loc_7009:
		cmp al, 0Dh			;		cp	0Dh
		jnz loc_7010		;		jr	nz, loc_7010
		mov dx, offset aEnter		;		ld	hl, aEnter	; "ENTER"

loc_7010:
		cmp al, 1			;		cp	1
		jnz loc_7017		;		jr	nz, loc_7017
		mov dx, offset aCapsShift	;		ld	hl, aCapsShift	; "CAPS SHIFT"

loc_7017:
		cmp al, 2			;		cp	2
		jnz loc_701E		;		jr	nz, loc_701E
		mov dx, offset aSymbolShift;		ld	hl, aSymbolShift ; "SYMBOL SHIFT"

loc_701E:
		mov byte ptr ds:[aEnteredKEY], al	;		ld	(aEnteredKEY), a
		mov bl, 43h			;		ld	c, 43h
		call	xMSG		; put char 

		push cx				;		push	de
		mov bh, 0C8h		;		ld	b, 0C8h
		call	sound48
		pop cx				;		pop	de
		
		pop bx				;		pop	bc
		
		dec bh
		jnz loc_6FDC		;		djnz	loc_6FDC

		mov bx, 50000		;		ld	bc, 50000
		call	_delayLDIR
		call	_delayLDIR
;
; build in cheat
; compare defined keys with "SECRET" code, and patch game if comapred
;
		mov dx, offset CheatKeyBuffer;		ld	hl, CheatKeyBuffer
		mov cx, offset aCHEAT_KEYS	;		ld	de, aCHEAT_KEYS	; "ZORBA"
		mov bh, 5					;		ld	b, 5

loc_7041:
		mov si, cx
		mov al, byte ptr ds:[si];		ld	a, (de)
		mov si, dx
		cmp al, byte ptr ds:[si];		cp	(hl)
		jz loc_70412
		jmp xmenu				;		jp	nz, xmenu
loc_70412:		
		inc dx					;		inc	hl
		inc cx					;		inc	de
		
		dec bh
		jnz loc_7041			;		djnz	loc_7041

		;mov al, byte ptr ds:[cheatLife] ;		ld	a, (cheatLife)
		;xor al, 3Dh						;		xor	3Dh
		;mov byte ptr ds:[cheatLife], al	;		ld	(cheatLife), a

		mov dx, offset musicGameOver	;		ld	hl, musicGameOver
		jnz loc_70413
		call playBeeperMusic	;		call	z, playBeeperMusic
loc_70413:
		jmp xmenu				;		jp	xmenu

; ---------------------------------------------------------------------------
aEnteredKEY:	db '?'
		db _7A_deltaY__p2_dbX
		db -1
		db 0FFh
aSpace:		db 'SPACE'
		db _7A_deltaY__p2_dbX
		db -5
		db _FF_EndMSG
aEnter:		db 'ENTER'
		db _7A_deltaY__p2_dbX
		db -5
		db _FF_EndMSG
aCapsShift:	db 'CAPS SHIFT'
		db _7A_deltaY__p2_dbX
		db -10
		db _FF_EndMSG
aSymbolShift:	db 'SYMBOL SHIFT'
		db _7A_deltaY__p2_dbX
		db -12
		db _FF_EndMSG

CheatKeyBuffer:	
		db 5 dup (?)	;ds 5
aCHEAT_KEYS:	db 'ZORBA'

xMSG_KeySelect:	db _DF_DW_xy
		_XY_ 0, 8
		db _E3_DWptr_RecursiveCallxMSG
		dw xMsgEXOLON?
		db _E0_Attribute?
		db 46h
		db _DF_DW_xy
		_XY_ 6, 7
		db _E6_DW_FONT
		dw FNT_MAIN
		db 'SELECT KEY FOR....'
		db _DE_setLoColor_15
		db _7B_deltaY__p3_dbX
		db 0EEh
		db 'LEFT'
		db _7A_deltaY__p2_dbX
		db 0FCh
		db 'RIGHT'
		db _7A_deltaY__p2_dbX
		db 0FBh
		db 'JUMP'
		db _7A_deltaY__p2_dbX
		db 0FCh
		db 'DUCK'
		db _7A_deltaY__p2_dbX
		db 0FCh
		db 'FIRE'
		db _70_deltaY__m8_dbX
		db 4
		db _E5_DBcnt_DBCHR_FillCharY
		db 9
		db ' '
		db _DF_DW_xy
		_XY_ 23, 2
		db _D9_setLoColor_10_RED
		db 'EXOLON COPYRIGHT 1987 HEWSON'
		db _FF_EndMSG
