;
; File generated by cc65 v 2.18 - Git 4a22487
;
	.fopt		compiler,"cc65 v 2.18 - Git 4a22487"
	.setcpu		"6502"
	.smart		on
	.autoimport	on
	.case		on
	.debuginfo	off
	.importzp	sp, sreg, regsave, regbank
	.importzp	tmp1, tmp2, tmp3, tmp4, ptr1, ptr2, ptr3, ptr4
	.macpack	longbranch
	.forceimport	__STARTUP__
	.import		_pal_bg
	.import		_pal_spr
	.import		_ppu_wait_nmi
	.import		_ppu_off
	.import		_ppu_on_all
	.import		_oam_clear
	.import		_oam_spr
	.import		_sfx_play
	.import		_pad_poll
	.import		_vram_adr
	.import		_vram_unrle
	.export		_gameRes
	.export		_pad
	.export		_palette
	.export		_sceneSetup
	.export		_getInput
	.export		_main

.segment	"RODATA"

_gameRes:
	.byte	$37
	.byte	$00
	.byte	$37
	.byte	$FE
	.byte	$00
	.byte	$37
	.byte	$68
	.byte	$01
	.byte	$37
	.byte	$0F
	.byte	$00
	.byte	$37
	.byte	$0E
	.byte	$02
	.byte	$03
	.byte	$04
	.byte	$37
	.byte	$03
	.byte	$05
	.byte	$06
	.byte	$37
	.byte	$03
	.byte	$07
	.byte	$04
	.byte	$37
	.byte	$03
	.byte	$08
	.byte	$09
	.byte	$00
	.byte	$37
	.byte	$0D
	.byte	$02
	.byte	$0A
	.byte	$00
	.byte	$37
	.byte	$03
	.byte	$0B
	.byte	$0C
	.byte	$37
	.byte	$03
	.byte	$0D
	.byte	$00
	.byte	$37
	.byte	$03
	.byte	$0E
	.byte	$09
	.byte	$00
	.byte	$37
	.byte	$0D
	.byte	$02
	.byte	$0A
	.byte	$0F
	.byte	$10
	.byte	$11
	.byte	$00
	.byte	$12
	.byte	$13
	.byte	$37
	.byte	$03
	.byte	$14
	.byte	$00
	.byte	$37
	.byte	$03
	.byte	$0E
	.byte	$09
	.byte	$00
	.byte	$37
	.byte	$0D
	.byte	$02
	.byte	$0A
	.byte	$15
	.byte	$16
	.byte	$17
	.byte	$00
	.byte	$18
	.byte	$19
	.byte	$1A
	.byte	$1B
	.byte	$1C
	.byte	$1D
	.byte	$1E
	.byte	$1F
	.byte	$20
	.byte	$21
	.byte	$22
	.byte	$09
	.byte	$00
	.byte	$37
	.byte	$0D
	.byte	$02
	.byte	$0A
	.byte	$00
	.byte	$23
	.byte	$24
	.byte	$00
	.byte	$25
	.byte	$26
	.byte	$27
	.byte	$28
	.byte	$29
	.byte	$2A
	.byte	$2B
	.byte	$2C
	.byte	$2D
	.byte	$2E
	.byte	$2F
	.byte	$09
	.byte	$00
	.byte	$37
	.byte	$0D
	.byte	$02
	.byte	$30
	.byte	$31
	.byte	$37
	.byte	$03
	.byte	$32
	.byte	$33
	.byte	$37
	.byte	$03
	.byte	$34
	.byte	$31
	.byte	$37
	.byte	$03
	.byte	$35
	.byte	$09
	.byte	$00
	.byte	$37
	.byte	$0E
	.byte	$36
	.byte	$37
	.byte	$0F
	.byte	$00
	.byte	$37
	.byte	$FE
	.byte	$00
	.byte	$37
	.byte	$7A
	.byte	$50
	.byte	$37
	.byte	$03
	.byte	$00
	.byte	$37
	.byte	$02
	.byte	$44
	.byte	$55
	.byte	$37
	.byte	$03
	.byte	$11
	.byte	$00
	.byte	$00
	.byte	$04
	.byte	$55
	.byte	$37
	.byte	$03
	.byte	$01
	.byte	$00
	.byte	$37
	.byte	$17
	.byte	$00
	.byte	$37
	.byte	$00
_palette:
	.byte	$0F
	.byte	$30
	.byte	$15
	.byte	$10
	.byte	$0F
	.byte	$04
	.byte	$1C
	.byte	$3D
	.byte	$0F
	.byte	$32
	.byte	$07
	.byte	$07
	.byte	$0F
	.byte	$16
	.byte	$16
	.byte	$16

.segment	"BSS"

_pad:
	.res	1,$00

; ---------------------------------------------------------------
; void __near__ sceneSetup (void)
; ---------------------------------------------------------------

.segment	"CODE"

.proc	_sceneSetup: near

.segment	"CODE"

;
; ppu_off();
;
	jsr     _ppu_off
;
; pal_bg(palette);
;
	lda     #<(_palette)
	ldx     #>(_palette)
	jsr     _pal_bg
;
; pal_spr(palette);
;
	lda     #<(_palette)
	ldx     #>(_palette)
	jsr     _pal_spr
;
; vram_adr(NAMETABLE_A);
;
	ldx     #$20
	lda     #$00
	jsr     _vram_adr
;
; vram_unrle(gameRes);
;
	lda     #<(_gameRes)
	ldx     #>(_gameRes)
	jsr     _vram_unrle
;
; ppu_on_all();
;
	jmp     _ppu_on_all

.endproc

; ---------------------------------------------------------------
; void __near__ getInput (void)
; ---------------------------------------------------------------

.segment	"CODE"

.proc	_getInput: near

.segment	"CODE"

;
; pad = pad_poll(0); // Get Controller Input
;
	lda     #$00
	jsr     _pad_poll
	sta     _pad
;
; ppu_wait_nmi(); // Wait until beginning of frame
;
	jsr     _ppu_wait_nmi
;
; oam_clear(); // Clear buffer
;
	jsr     _oam_clear
;
; if(pad & PAD_A) {
;
	lda     _pad
	and     #$80
	beq     L0109
;
; oam_spr(174,124,56,0); // Push sprite to oam
;
	jsr     decsp3
	lda     #$AE
	ldy     #$02
	sta     (sp),y
	lda     #$7C
	dey
	sta     (sp),y
	lda     #$38
	dey
	sta     (sp),y
	tya
	jsr     _oam_spr
;
; if(pad & PAD_B) {
;
L0109:	lda     _pad
	and     #$40
	beq     L010A
;
; oam_spr(155,124,56,0);
;
	jsr     decsp3
	lda     #$9B
	ldy     #$02
	sta     (sp),y
	lda     #$7C
	dey
	sta     (sp),y
	lda     #$38
	dey
	sta     (sp),y
	tya
	jsr     _oam_spr
;
; if(pad & PAD_START) {
;
L010A:	lda     _pad
	and     #$10
	beq     L010B
;
; oam_spr(115,126,57,0);
;
	jsr     decsp3
	lda     #$73
	ldy     #$02
	sta     (sp),y
	lda     #$7E
	dey
	sta     (sp),y
	lda     #$39
	dey
	sta     (sp),y
	tya
	jsr     _oam_spr
;
; if(pad & PAD_SELECT) {
;
L010B:	lda     _pad
	and     #$20
	beq     L010C
;
; oam_spr(132,126,57,0);
;
	jsr     decsp3
	lda     #$84
	ldy     #$02
	sta     (sp),y
	lda     #$7E
	dey
	sta     (sp),y
	lda     #$39
	dey
	sta     (sp),y
	tya
	jsr     _oam_spr
;
; if(pad & PAD_UP) {
;
L010C:	lda     _pad
	and     #$08
	beq     L010D
;
; oam_spr(84,113,55,0);
;
	jsr     decsp3
	lda     #$54
	ldy     #$02
	sta     (sp),y
	lda     #$71
	dey
	sta     (sp),y
	lda     #$37
	dey
	sta     (sp),y
	tya
	jsr     _oam_spr
;
; if(pad & PAD_DOWN) {
;
L010D:	lda     _pad
	and     #$04
	beq     L010E
;
; oam_spr(84,124,55,0);
;
	jsr     decsp3
	lda     #$54
	ldy     #$02
	sta     (sp),y
	lda     #$7C
	dey
	sta     (sp),y
	lda     #$37
	dey
	sta     (sp),y
	tya
	jsr     _oam_spr
;
; if(pad & PAD_LEFT) {
;
L010E:	lda     _pad
	and     #$02
	beq     L010F
;
; oam_spr(79,118,58,0);
;
	jsr     decsp3
	lda     #$4F
	ldy     #$02
	sta     (sp),y
	lda     #$76
	dey
	sta     (sp),y
	lda     #$3A
	dey
	sta     (sp),y
	tya
	jsr     _oam_spr
;
; if(pad & PAD_RIGHT) {
;
L010F:	lda     _pad
	and     #$01
	beq     L0110
;
; oam_spr(90,118,58,0);
;
	jsr     decsp3
	lda     #$5A
	ldy     #$02
	sta     (sp),y
	lda     #$76
	dey
	sta     (sp),y
	lda     #$3A
	dey
	sta     (sp),y
	tya
	jsr     _oam_spr
;
; if(pad != 0x00) // If pad is not at default state
;
L0110:	lda     _pad
	beq     L0104
;
; sfx_play(0,0); // Play sound
;
	lda     #$00
	jsr     pusha
	jmp     _sfx_play
;
; }
;
L0104:	rts

.endproc

; ---------------------------------------------------------------
; void __near__ main (void)
; ---------------------------------------------------------------

.segment	"CODE"

.proc	_main: near

.segment	"CODE"

;
; sceneSetup();
;
	jsr     _sceneSetup
;
; getInput();
;
L00B6:	jsr     _getInput
;
; while(1) {
;
	jmp     L00B6

.endproc

