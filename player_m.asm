;original code - Rafaelle Cecco (c) 1987
;disassembled by Sergey Erokhin aka ESL - Nov-Dec 2014
;eslexolon@gmail.com
;https://bitbucket.org/esl/exolon-zx/
;licensed under a Creative Commons Attribution Share-Alike 3.0 (CC-BY-SA 3.0)

move_player:

; debug
;	mov byte ptr ds:[key_RIGHT],1
;	mov ah, 99h
;	int 21h

	;call doRetIfPlayerAlreadyDie			;		call	doRetIfPlayerAlreadyDie
	xor al, al								;		xor	a
	mov byte ptr ds:[UpdateZoneRequired], al;		ld	(UpdateZoneRequired), a
	mov cx, word ptr ds:[Player_X_Pos]		;		ld	de, (Player_X_Pos) ; 0..127
	
;in fall progress
	mov al, byte ptr ds:[flag_fall_down]	;		ld	a, (flag_fall_down)
	or  al, al								;		or	a
	jz mp1
	jmp loc_8280							;		jp	nz, loc_8280
mp1:
	; in death jump
	mov al, byte ptr ds:[death_jump_phase]	;		ld	a, (death_jump_phase)
	or al, al								;		or	a
	jnz next_dead_jump 						;		jr	nz, next_dead_jump
	;
	;		;start fall?
;	call chk_can_move_down					;		call	chk_can_move_down	;=0 if can
;	jnz mp2
	jmp loc_8280							;		jp	z, loc_8280
mp2:
	;
	;		;duck
	mov al, -6;		ld	a, -6 			;0FAh
	mov byte ptr ds:[flag_duck_y], al	;		ld	(flag_duck_y), a
	;
	mov al, byte ptr ds:[key_DOWN]		;		ld	a, (key_DOWN)
	or al, al							;		or	a
	;
	mov al, sprPlayerDuck;		ld	a, sprPlayerDuck	;10 - sprite DUCK
	jnz ShowPlayerSprite;		jp	nz, ShowPlayerSprite ; a  - sprite
	;
	xor al, al;		xor	a
	mov byte ptr ds:[flag_duck_y], al;		ld	(flag_duck_y), a
	;
	;		;start jump ?
	mov al, byte ptr ds:[flag_duck_y];		ld	a, (c)
	or al, al;		or	a

	jnz mp3
	jmp loc_8280;		jp	z, loc_8280 		;no jmp
	;
	;		;no jump if not on ground
	;call chk_can_move_down;		call	chk_can_move_down	;=0 if can
mp3:
;	jnz mp4
	jmp loc_8280;		jp	z, loc_8280
	;
	
mp4:
	mov al, 22;		ld	a, 22

next_dead_jump:
	mov si, offset  death_jump_tab-1 ;		ld	hl, death_jump_tab-1	;byte_8269!!!!!!
	mov bl, al	;		ld	c, a
	mov bh, 0	;		ld	b, 0
	dec al		;		dec	a
	mov byte ptr ds:[death_jump_phase], al;		ld	(death_jump_phase), a
	add si, bx			;		add	hl, bc
	mov al, byte ptr ds:[si];		ld	a, (hl)
	or al,al;		or	a
	jz loc_820A;		jr	z, loc_820A
	cmp al, 0ah;		cp	0Ah
	jnc loc_81FB;		jr	nc, loc_81FB
	;
;	;call	chk_can_move_down;		call	chk_can_move_down	;=0 if can
	jmp loc_81FE;		jr	loc_81FE
	
; ---------------------------------------------------------------------------

loc_81FB:
;	call	chk_can_move_up;		call	chk_can_move_up

loc_81FE:
	;jz loc_8207;		jr	z, loc_8207
	xor al, al;		xor	a
	mov byte ptr ds:[death_jump_phase], al;		ld	(death_jump_phase), a
	jmp loc_8280;		jp	loc_8280
; ---------------------------------------------------------------------------

loc_8207:
	mov al, byte ptr ds:[si];		ld	a, (hl)
	add al, al;		add	a, d
	mov ch, al;		ld	d, a

loc_820A:
	mov al, byte ptr ds:[walk_dx];		ld	a, (walk_dx)
	or al, al;			or	a
	jz loc_8222;		jr	z, loc_8222
	dec al	;			dec	a
	jz loc_8218;		jr	z, loc_8218
	;call chk_can_move_left;		call	chk_can_move_left	;=0 if can
	jmp loc_821B;		jr	loc_821B
	; ---------------------------------------------------------------------------

loc_8218:
	;call	chk_can_move_right;		call	chk_can_move_right ;a=0 if can walk


loc_821B:
	jnz loc_8222;		jr	nz, loc_8222
	mov al, byte ptr ds:[walk_dx];		ld	a, (walk_dx)
	add al, cl;		add	a, e
	mov cl, al;		ld	e, a

loc_8222:
	mov al, sprPlayerPhase3;		ld	a, sprPlayerPhase3	;3-jump phase?
;
; a  - sprite

ShowPlayerSprite:
	mov bl, al;		ld	c, a
	mov al, byte ptr ds:[flag_Exoskeleton];		ld	a, (flag_Exoskeleton)
	add al, bl;		add	a, c

show32xsprite:
	xchg ah,al	;		ex	af, af'    
	mov al, cl;		ld	a, e
	cmp al,128;		cp	128
	mov al, ch;		ld	a, d
	jz nextZONEPrepare;		jr	z, nextZONEPrepare ; A - player	Y pos
	;
	mov bl, 47h;		ld	c, 47h ; 'G'
	xchg ah, al;		ex	af, af'
;	call	fillAttr_3x4;		call	fillAttr_3x4
	;
	mov bx, word ptr ds:[Player_X_Pos];		ld	bc, (Player_X_Pos) ; 0..127
	
	mov word ptr ds:[Player_X_Pos], cx;		ld	(Player_X_Pos),	de ; 0..127
	;
	mov dx, word ptr ds:[byte_8269];		ld	hl, (byte_8269)
	cmp al, dl	;		cp	l
	jnz loc_824A;		jr	nz, loc_824A
	mov dh, bh;		ld	h, b
	mov dl, bl;		ld	l, c
	and al, al;		and	a
	sbb dx, cx;		sbc	hl, de
	jnz loc_824A;		ret	z
	ret

loc_824A:
	mov byte ptr ds:[byte_8269], al;		ld	(byte_8269), a
	mov dx, offset SpriteBuf24x32;		ld	hl, SpriteBuf24x32
	
	jmp Sprite24x32_Player;		jp	Sprite24x32_Player ;
						; 00-09	- WALK
						; 10 - Duck
						; 11 - DIE
						; 12-21	WALK 2gun
						; 22 - Duck2gun
						; 23 - Die 2gun
						; 24 - PUMP
						;

; =============== S U B	R O U T	I N E =======================================

; A - player Y pos

nextZONEPrepare:
		mov byte ptr ds:[Player_Y_Pos],al;		ld	(Player_Y_Pos),	a ; 0x70 - ground
		mov byte ptr ds:[PlayerXY_COPY+1],al;		ld	(PlayerXY_COPY+1), a
	;
		mov byte ptr ds:[UpdateZoneRequired],al;		ld	(UpdateZoneRequired), a
	;
		mov al, byte ptr ds:[_ZONE];		ld	a, (_ZONE)
		inc al;		inc	a
		mov byte ptr ds:[_ZONE],al;		ld	(_ZONE), a
	;
		mov al, 0ffh;		ld	a, 0FFh
		mov byte ptr ds:[byte_8269],al;		ld	(byte_8269), a
		ret

; ---------------------------------------------------------------------------
byte_8269:	db 0

death_jump_tab:
		db    4,   4,	2,   2,	  2
		db    1,   1,	1,   1,   0
		db    0,   0,   0,  -1,  -1
		db   -1,  -1,  -2,  -2,  -2
		db   -4,  -4
; ---------------------------------------------------------------------------

loc_8280:
		xor al, al	;		xor	a
		mov byte ptr [flag_fall_down], al;		ld	(flag_fall_down), a
	;	call chk_can_move_down;		call	chk_can_move_down	;=0 if can
		jmp loc_8295 ;	jnz loc_8295;		jr	nz, loc_8295
	
;falldown
		inc ch;		inc	d
		inc ch;		inc	d
		inc ch;		inc	d
		inc ch;		inc	d
;
		mov al, sprPlayerPhase9;		ld	a, sprPlayerPhase9	;9 - falldown sprite
		mov byte ptr ds:[flag_fall_down],al;		ld	(flag_fall_down), a
		jmp ShowPlayerSprite;		jr	ShowPlayerSprite ; a	- sprite

flag_fall_down:	db 0


loc_8295:
;keyLeftpressed ^ keyRightpressed
;=1 only if pressed single key left or right
; F023
		mov dx, word ptr ds:[key_LEFT];		ld	hl, (key_LEFT)
		mov al, dh;		ld	a, h
		xor al, dl;		xor	l
		mov byte ptr [walk_dx], al;		ld	(walk_dx), a
		
;		;no move - stay (sprite 5)
		mov al, sprPlayerPhase5;		ld	a, sprPlayerPhase5	;5 plain walk
		jnz loc_82951

		jmp ShowPlayerSprite;		jp	z, ShowPlayerSprite ;	a  - sprite
;
loc_82951:
		mov al, 1;		ld	a, 1
		mov byte ptr ds:[player_direction_DX], al;		ld	(player_direction_DX), a
		
		test dl, 0	;		bit	0, l 			;right
		jz move_right;		jr	z, move_right
		
		mov al, -1;		ld	a, -1
		mov byte ptr ds:[walk_dx], al;		ld	(walk_dx), a
		mov byte ptr ds:[player_direction_DX], al;		ld	(player_direction_DX), a;
		mov al, byte ptr ds:[playerSpriteDirection];		ld	a, (playerSpriteDirection) ;	0 - to right, 1	- to left
		or  al, al ;		or	a
		jnz sw1pm
		
		call swapBigSprite;		call	z, swapBigSprite ; Swap	sprites	to left/right when move	in left/right directions
		jmp change_player_direction ;		jr	z, change_player_direction
sw1pm:
;		call	chk_can_move_left	;=0 if can
		jmp loc_82CD;		jr	loc_82CD
; ---------------------------------------------------------------------------

move_right:
	mov al, byte ptr ds:[playerSpriteDirection];		ld	a, (playerSpriteDirection) ;	0 - to right, 1	- to left
	or al, al;		or	a
	jz sw2pm
	call swapBigSprite;		call	nz, swapBigSprite ; Swap sprites to left/right when move in left/right directions
sw2pm:
	jnz change_player_direction;		jr	nz, change_player_direction
;		call	chk_can_move_right ;a=0 if can walk

loc_82CD:
	mov al, sprPlayerPhase5;		ld	a, sprPlayerPhase5	;5-plainwalk
	jz loc_82CD_1;		jp	nz, ShowPlayerSprite ; a  - sprite
	jmp ShowPlayerSprite;

loc_82CD_1:
	mov al, byte ptr ds:[walk_dx];		ld	a, (walk_dx)
	add al, cl;		add	a, e
	mov cl, al;		ld	e, a
	
	mov al, byte ptr ds:[player_walk_phase];		ld	a, (player_walk_phase)
	cmp al, sprPlayerPhase9+1;		cp	sprPlayerPhase9+1	;10-max phase
	jnz no_reset_phase;		jr	nz, no_reset_phase
	xor al,al;		xor	a

no_reset_phase:
	mov bh, al		;		ld	b, a
	inc al			;		inc	a
	mov byte ptr ds:[player_walk_phase],al;		ld	(player_walk_phase), a
	mov al, bh		;		ld	a, b
	jmp ShowPlayerSprite;		jp	ShowPlayerSprite ; a	- sprite
; ---------------------------------------------------------------------------

change_player_direction:
	mov al, 0ffh					;		ld	a, 0FFh
	mov byte ptr ds:[byte_8269], al	;		ld	(byte_8269), a
	mov al, sprPlayerPhase5	;		ld	a, sprPlayerPhase5	;5
	jmp ShowPlayerSprite			;		jp	ShowPlayerSprite ; a	- sprite
; ---------------------------------------------------------------------------
UpdateZoneRequired:	 db 0
PlayerXY_COPY:	     dw 0
Player_X_Pos:	     db 0	; 0..127
Player_Y_Pos:	     db 0	; 0x70 - ground
death_jump_phase:    db 0
walk_dx:	         db 1
player_walk_phase:   db 0
player_direction_DX: db 1
flag_duck_y:	     db 0
