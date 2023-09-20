;original code - Rafaelle Cecco (c) 1987
;disassembled by Sergey Erokhin aka ESL - Nov-Dec 2014
;eslexolon@gmail.com
;https://bitbucket.org/esl/exolon-zx/
;licensed under a Creative Commons Attribution Share-Alike 3.0 (CC-BY-SA 3.0)

;NOT USED

mov dx, 8000h				; 		ld	hl, 8000h
mov si, dx
mov byte ptr ds:[si], 81h	; 		ld	(hl), 81h ; 'Å'
mov dx, 8001h				; 		ld	de, 8001h
mov cx, 101h				; 		ld	bc, 101h
; 		ldir
; 		im	2
; 		ld	a, 80h ; 'Ä'
; 		ld	i, a
; 		ret


InitScrAddrTables:
mov bh, 192						;		ld	b, 192
mov si, offset Y2SCR_HI			;		ld	ix, Y2SCR_HI
mov di, offset Y2SCR_LO			;		ld	iy, Y2SCR_LO
mov dx, offset SCRLINE000		;		ld	hl, SCRLINE000

mk_y2scr:
mov byte ptr ds:[si], dh		;		ld	(ix+0),	h
mov byte ptr ds:[di], dl		;		ld	(iy+0),	l
inc si							;		inc	ix
inc di							;		inc	iy
call	NextScrLineAddr			;		call	NextScrLineAddr
dec bh
jnz mk_y2scr					;		djnz	mk_y2scr
;;
;;table used in scroll highscore
;;+8 - 8row on screen
mov bh, 192						;		ld	b, 192
mov dx, offset SCRLINE000+8		;		ld	hl,  SCRLINE000+8
mov si, offset scr_addr_8				;		ld	ix, scr_addr_8

loc_7C14:
mov byte ptr ds:[si],dl			;		ld	(ix+0),	l
mov byte ptr ds:[si+1],dh		;		ld	(ix+1),	h
inc si							;		inc	ix
inc si							;		inc	ix
call NextScrLineAddr			;		call	NextScrLineAddr
dec bh
jnz loc_7C14					;		djnz	loc_7C14

		ret
