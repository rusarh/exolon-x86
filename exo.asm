;;
; a = AL ; a' = AH
; b = BH ; c = BL ; bc = BX
; d = CH ; e = CL ; de = CX
; h = DH ; l = DL ; hl = DX
;-----------------
; index HL -> BX / SI
; index IX -> DI

;     AF = AL + Flags
;    HL = Can be seen as BX (H=BH,L=BL) or SI in a (HL) setting, like BX also used for addressing.
;    BC = Can be seen as CX (B=CH,C=CL), often used for loops
;    DE = Can be seen as DX (D=DH,E=DL) or DI in a (DE) setting
;    IX = 16 bit Index Register X, can also be accessed with IXH,IXL
;    IY = 16 bit Index Register Y, can also be accessed with IYH,IYL

ex_af macro ;ex af,af'
	xchg ah,al
	;nop
endm

exx_ macro
	xchg word ptr ds:[bx_save], bx
	xchg word ptr ds:[cx_save], cx
	xchg word ptr ds:[dx_save], dx
endm
	
cseg		segment	
		assume	cs:cseg, ds:cseg
  
		org	100h
  
start:
		push ds
		push cs
		pop ds
	
		; enable graph mode
		mov ax, 4
		int 10h
		
		mov     ah, 0Bh         ; interrupt 10B
		mov     bh, 1           ; 1 = 4 pallette mode
		mov     bl, 0           ; 0 = warm colors (r,g,b) 1 = cool (c,m,w)
		int     10h             ; bios int
		
		; ds = data segment = code segment
		push cs
		pop ds
		
		; es = video buffer segment
		mov ax, 0b800h
		mov es, ax
		
		call initBitSwapTab
		
		call	xmenu
		pop ds
		
		; return dos 80-column mode
		;mov ax, 3
		;int 10h
		
		mov ah, 04ch
		int 21h
		retf
		

locret_7D2C:

; ---------------------------------------------------------------------------

xmenu:
		call	ClearToBLACK
;		call	clr_no_walk_tab
;		call	clr_over_player_tab
;		mov bx,31		; force	last line to
		;ldir

		mov	dx, offset xMSG_MENU ;xMSG_MENU
		call	xMSG		; C - color
					; HL - PRE
					; E-X
					; D-Y		

		;jmp ShowHiscoreTable2
		call	playBeeperMusic
		
menuLoop:
		call	starsAnimationStep
		call	GetKEY
		jz menutasks
		mov ax, 0000h
		int 16h
		
menutasks:
		cmp al, '1'				;	cp	'1'
		jc noMenuKEY			;	jr	c, noMenuKEY
		;cp	'6'
		;jr	nc, noMenuKEY
		cmp al, '1' ;cp	'1'
		jnz exo0
		jmp StartGame
exo0:		
		cmp al, '2'				;	cp	'2'
		jnz exo1
		jmp DefineKeys			;	jp	z, DefineKeys
exo1:
		;sub	'3'

		
		;mov ax,0100h
		;int 16h
		;jz xmenu_noKey
		;mov ax,0
		;int 16h
		
		mov dx, offset xMSG_MENU		;	ld	hl, xMSG_MENU
		push bx					;	push	bc
		call	xMSG		; C - color
					; HL - PRE
					; E-X
					; D-Y
	;	call	highLightSelectedContorol
		pop bx					;	pop	bc
		
		call _delayLDIR

noMenuKEY:

		dec bx					;	dec	bc
		mov al, bh				;	ld	a, b
		or al, bl				;	or	c
		;jz ShowHiscoreTable2	;	jp	z, ShowHiscoreTable2
		jmp menuLoop			;	jp	menuLoop

		
xmenu_noKey:
	
		mov	al, 9
		mov byte ptr ds:[_LIVES], al
		
		mov	al, 99
		mov byte ptr ds:[_AMMO], al
		
		mov	al, 10
		mov byte ptr ds:[_GRENADES], al
		
		xor	al,al
		
		mov al, 0
		mov cx, 255
		
;menuLoop:

		call	ClearToBLACK
		;mov byte ptr ds:[Die_Animation_Step], al
		push ax
		push cx
		mov byte ptr ds:[_ZONE], al

		;call	show2BottomLine
		;call	build_zone_screen
		
		sti
		mov ax, 0
		int 16h
		
		pop cx
		pop ax
		inc ax
		
		;jmp startGame
				

		loop menuLoop
		
;menuLoop:
;		call	starsAnimationStep
;		call	GetKEY
;		cmp al, '1'
;		jc noMenuKEY
;		cmp al,	'6'
;		jnc, noMenuKEY
;		cmp al,	'1'
;		jz, StartGame
;		cmp al,	'2'
;		jz, DefineKeys
;		sub	al, '3'
;		mov	cl, al
;		mov	al, [active_control]
;		cp	al, cl
;		jz, noMenuKEY
;		mov	a, e
;		mov	[active_control], a
		mov	dx, offset xMSG_MENU
		push	bx
		call	xMSG		; C - color
;					; HL - PRE
					; E-X
					; D-Y 
;		call	highLightSelectedContorol
		pop		bx

;noMenuKEY:
		;dec	bx
		;mov	al, bh
		;or	bl
		;jz  ShowHiscoreTable2
		;jmp	menuLoop
		
		
		;mov ax, 0
		;int 16h
		
		ret
; ---------------------------------------------------------------------------


; ---------------------------------------------------------------------------
DEBUG_DISABLE_AY 	equ 	1
CHEAT_NO_CANNON_FIRE 	equ 	0
CHEAT_SUPER_SHIELD 	equ 	0
CHEAT_LIFE 		equ 	0
CHEAT_NO_DEATH 		equ 	1
CHEAT_AMMO 		equ 	0
FIX_SPRITE16x16COM	equ	0

	ORG	04000h
SCRLINE000:
	db	0
	ORG	05800h
ATTR_TABLE:
	db   	0
	ORG	05b00h
over_player_tab:
	db 	0
	ORG	05e00h
ATTR_TABLE_COPY:
	 	db 	0
;array 32x24
;=0 - empty
;=1 - not empty, player	can't walk
;=xx - animation code
	ORG	06100h
no_walk_tab: 	
	db 	0
	ORG	06400h
bitSwapTab:
	db 	0
	ORG	06500h
Y2SCR_HI:
	db 	0
	ORG	06600h
Y2SCR_LO:
	db 	0
	ORG	06700h

scr_addr_8:		;used for scrolling highscore table
	db 	0
	ORG	06D60h
		
		
include	defs.asm

include action~1.asm;   actions_long_dalay_killer.asm
include sound_~1.asm;	sound_beeper_music.asm   (playBeeperMusic)
include sound_~2.asm;	sound_sound_48.asm

include data_m~1.asm;	data_msg_exolon.asm
include data_m~3.asm;	data_msg_menu.asm

include data_f~1.asm;	data_fonts.asm
include data_z~1.asm;	data_zone_blocks.asm
include data_z~2.asm;	data_zone_data.asm
include data_s~1.asm;	data_sprites_data.asm

;include putchar1.asm;
include gr_putch.asm ;  graphics_putchars.asm
include gr_sprb.asm  ;  graphics_sprite_bufs.asm
include gr_xmsg.asm  ;  graphics_xmsg.asm
include gr_24x32.asm ;	graphics_sprites_code_24x32.asm
include gr_16x16.asm ;	graphics_sprites_code_16x16.asm
include graph1.asm	 ;	graphics_sprites_compensate.asm

include utils_~1.asm;	utils_bitswap.asm
include utils_~2.asm; 	utils_rnd.asm
include utils_~3.asm;	utils_routines.asm
include utils_~4.asm;   utils_init_tables.asm
include utils_~5.asm;   utils_keys2.asm
include utils_~6.asm;   utils_keys3.asm
include utils_~7.asm;   utils_keys3_2.asm

include game_z~1.asm;   game_zone_prepare.asm
include game_i~1.asm;   game_info.asm
include game_p~1.asm;   game_points_add.asm
include game_l~1.asm;   game_loop.asm
include game_i~2.asm;   game_info_full.asm
include game_d~1.asm;   game_destroyable_objects.asm
;include menu_h~1.asm;   menu_highscore.asm
include menu_r~1.asm;   menu_random_stars.asm
include menu_r~2.asm;   menu_redefine_key.asm
include menu_s.asm;   menu_stars.asm

include player_m.asm;   player_move.asm

; ---------------------------------------------------------------------------
flag_Exoskeleton:
	db 0	
grenade_phase:	
	db 0
xyGrenade:	
	dw 0
grenade_DX:	
	db 0
grenade_spr_id:	
	db 0
		
; ---------------------------------------------------------------------------

; _Dx4_Ex8
; d*4
; e*8
;

block2xy:
lahf	;			push	af
push ax
mov al, cl	;		ld	a, e
add al,al	;		add	a, a
add al,al	;		add	a, a
mov cl,al	;		ld	e, a		; 4
mov al,ch	;		ld	a, d
add al,al	;		add	a, a
add al,al	;		add	a, a
add al,al	;		add	a, a
mov ch,al	;		ld	d, a		; 8
pop ax
sahf		;		pop	af
ret			;		ret
		
cseg	ends
end	start