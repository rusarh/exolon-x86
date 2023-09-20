;original code - Rafaelle Cecco (c) 1987
;disassembled by Sergey Erokhin aka ESL - Nov-Dec 2014
;eslexolon@gmail.com
;https://bitbucket.org/esl/exolon-zx/
;licensed under a Creative Commons Attribution Share-Alike 3.0 (CC-BY-SA 3.0)

;show zone
;1. clear all buffers
;2. get addr of zone info (db y,x,blk; db 0xff)
;3. add element in "destroyable" tab if requre
;4. show block (and fill no_walk_tab and over_player_tab)
;5. loop while all element on level
;6. init_Level_Actions no_walk_tab contains "actions". fill structures if exist
;7. init specific actions if require

new_zone_if_required:
	mov al, byte ptr ds:[UpdateZoneRequired];		ld	a, (UpdateZoneRequired)
	or al,al;		or	a
	jnz gzp1;		ret	z
	ret

gzp1:
	xor al,al						   ;		xor	a
	mov byte ptr ds:[Player_X_Pos],al  ;		ld	(Player_X_Pos),	a
	mov byte ptr ds:[PlayerXY_COPY], al;		ld	(PlayerXY_COPY), a

	call	osd_ZONE

build_zone_screen:

	mov si, 0							;		ld	hl, 0
	mov word ptr ds:[delay_to_killer], si;		ld	(delay_to_killer), hl

	;call ClearToBLACK
	xor al,al							;		xor	a
	mov byte ptr ds:[grenade_phase],al	;		ld	(grenade_phase), a
	mov byte ptr ds:[dead_sprite_delay2],al;		ld	(dead_sprite_delay2),	a
	mov byte ptr ds:[flag_LongDelayKiller],al;		ld	(flag_LongDelayKiller), a
;
		call	clr_SpriteBuffers
;		call	clr_over_player_tab
;		call	clr_no_walk_tab
;		call	clr_myBullets
;		call	clr_Gun_machine_bullets
;		call	clr_MineBuf
;		call	clr_ExplosionParicles
;		call	clr_MachineGun
;		call	clr_AnimatedParticles
;		call	clr_Spheres
;		call	clr_Pump
;		call	clr_Rockets
;		call	clr_TeleportParticles
;		call	clr_EnemyData
;		call	clr_AfterLifeObject
;		call	clr_BonusPoints
;		call	clr_PlayScreen

	mov al, byte ptr ds:[_ZONE];		ld	a, (_ZONE)
	mov bx, offset ZONE_TAB	   ;		ld	bc, ZONE_TAB
	call	get_hl_a_BC		   ;		call	get_hl_a_BC

	mov	di, offset destroyableBuffer	;		ld	ix, destroyableBuffer

build_zone_loop:
	;mov si, dx
	mov al, byte ptr ds:[si];		ld	a, (hl)
	cmp al, 0ffH			;		cp	0FFh
	jz zone_done			;		jr	z, zone_done
;
	mov ch, al				;		ld	d, a		; y
	inc si					;		inc	hl
	mov cl, byte ptr ds:[si];		ld	e, (hl)		; x
	inc si					;		inc	hl
	push si					;		push	hl
	mov al, byte ptr ds:[si];		ld	a, (hl)		; block
;
;		call	update_destoryabl_objects 	; ix -	buffer
;							; a - block id

;		;put "block" to screen
;		;also tables no_walk_tab and over_player_tab
;		;no_walk_tab also contain information about "actions" and will be used in init_Level_Actions
;
	mov bx, offset xZoneBlock;		ld	bc, xZoneBlock
	call	get_hl_a_BC;		call	get_hl_a_BC
;
	mov al,1;		ld	a, 1
	mov byte ptr ds:[noWalkFlag+1],al;		ld	(noWalkFlag+1),	a
;
	xor al,al;		xor	a
	mov byte ptr ds:[overPlayerFlag+1],al;		ld	(overPlayerFlag+1), a
;
	mov bl, al;		ld	c, a
	mov dx, si
	call xMSG;		call	xMSG		; C - color
;					; HL - PRE
;					; E-X
;					; D-Y
	pop si;		pop	hl
	inc si;		inc	hl
	jmp	build_zone_loop;		jp	build_zone_loop
; ---------------------------------------------------------------------------

zone_done:
	mov byte ptr ds:[di+0], 0ffh;		ld	(ix+0),	0FFh	;set "END" mark in destroyable buffer
;
;	call	_save_attr_table;		call	_save_attr_table
;
;;;;;;;; ->	call	init_random_stars;		call	init_random_stars
;
;	call	init_Level_Actions 	;		call	init_Level_Actions 	;init "actions" structures if exist on level
;
;		;additionally init specific actions if exist
;	call	init_Spheres;		call	init_Spheres
;	call	init_Enemies;		call	init_Enemies
;	call	init_greenSphereRocket;		call	init_greenSphereRocket
;	jmp init_BEAM;		jp	init_BEAM


	ret

; ---------------------------------------------------------------------------

_ZONE:		db 0

; =============== S U B	R O U T	I N E =======================================


get_hl_a_BC:
	mov dl, al;		ld	l, a
	mov dh, 0 ;		ld	h, 0
	add dx, dx;		add	hl, hl
	add dx, bx;		add	hl, bc
	mov si, dx
	mov al, byte ptr ds:[si];		ld	a, (hl)
	inc dx;		inc	hl
	
	mov si, dx
	mov dh, byte ptr ds:[si];		ld	h, (hl)
	mov dl, al;		ld	l, a
	
	mov si,dx
	
	ret
