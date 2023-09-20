;	gr_sprb.asm

;original code - Rafaelle Cecco (c) 1987
;disassembled by Sergey Erokhin aka ESL - Nov-Dec 2014
;eslexolon@gmail.com
;https://bitbucket.org/esl/exolon-zx/
;licensed under a Creative Commons Attribution Share-Alike 3.0 (CC-BY-SA 3.0)

; =============== S U B	R O U T	I N E =======================================


clr_SpriteBuffers:

	mov si, offset SpriteBuf24x32	;		ld	hl, SpriteBuf24x32
	mov di, offset SpriteBuf24x32+1	;		ld	de, SpriteBuf24x32+1
	mov cx, 1359; ((32*4)*5)+((3*16)*15)-1;		ld	bc, ((32*4)*5)+((3*16)*15)-1	;1360-1
	mov word ptr ds:[si], 0;		ld	(hl), 0
	cld
	rep movsb;		ldir
		ret

;if FIX_SPRITE16x16COM 
	;ESL
;	SPR_COMP:
	; 		ds  80h 	; 0
	;		dc  80h,0x00 	; 0
			db 80h ,0
	;ESL
;		endif
		
byte_B101:
; 		ds  80h 	; 0
;		dc  80h,0x00 	; 0
		
		db 80h, 0

;buffers of last sprite
;sprite16x & sprite24x erase sprite from this buff
;and store new in this buf

SpriteBuf24x32:
;; 		ds 	(4*32)*1	;player
;		dc 	(4*32)*1,0x00	;player
		db (4*32)*2 dup (0)
SpriteBuf24x32_pump:
; 		ds 	(4*32)*4	;4 pump
;		dc 	(4*32)*4,0x00	;4 pump
		
		db (4*32)*8 dup (0)
afterLifeSpriteBuf:
; 		ds 	(3*16)*5	;5 sprites
;		dc 	(3*16)*5,0x00	;5 sprites
		db (3*16)*10 dup (0)
greenRocketSpriteBuf:
; 		ds 	(3*16)*1	;
;		dc 	(3*16)*1,0x00	;
		db (3*16)*2 dup (0)
enemySpriteBuf:
; 		ds 	(3*16)*6	;6 sprites
;		dc 	(3*16)*6,0x00	;6 sprites

		db (3*16)*12 dup(0)
HighVoltageSpriteBuf:
; 		ds	(3*16)*2	;2 sprites
;		dc	(3*16)*2,0x00	;2 sprites
		db (3*16)*4 dup(0)
longDelayKillerSpriteBuf:
; 		ds	(3*16)*1	;
;		dc	(3*16)*1,0x00	;
		db (3*16)*2 dup (0)

