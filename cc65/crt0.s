; Startup code for cc65 (6502 BrainFuck emulator version)

.P02

.export   	_init, _exit
.export   	__STARTUP__ : absolute = 1        ; Mark as startup
.import 	__MAIN_START__, __MAIN_SIZE__
.import    	copydata, zerobss, initlib, donelib, _main
.import   	_irq_int, _nmi_int
.importzp	sp

; TODO zeropage.inc is taken from cc65 source tree and 6502bf.lib is a copy of none.lib.
; These should be updated when a new version of the compilr comes out.

.include  "6502bf.inc"

; ---------------------------------------------------------------------------
; Place the startup code in a special segment

.segment  "STARTUP"

; ---------------------------------------------------------------------------
; A little light 6502 housekeeping

_init:  
		LDX     #$FF                 ; Initialize stack pointer to $01FF
        TXS
        CLD                          ; Clear decimal mode

; ---------------------------------------------------------------------------
; Set cc65 argument stack pointer right below 6502 vectors

        LDA     #<(__MAIN_START__ + __MAIN_SIZE__)
        STA     sp
        LDA     #>(__MAIN_START__ + __MAIN_SIZE__)
        STA     sp+1

; ---------------------------------------------------------------------------
; Set interrupt vectors
; IRQ/BRK	FFFE	FFFF 
; NMI		FFFA	FFFB ; this can be ignored, as no interrups are generated in code 
; RESET		FFFC	FFFD ; this is set up at emulator start by the emu itself

        LDA     #<_irq_int			 
        STA     $FFFE
        LDA     #>_irq_int
        STA     $FFFF

; ---------------------------------------------------------------------------
; Initialize memory storage

        JSR     zerobss              ; Clear BSS segment
        JSR     copydata             ; Initialize DATA segment
        JSR     initlib              ; Run constructors

; ---------------------------------------------------------------------------
; Call main()

        JSR     _main

; ---------------------------------------------------------------------------
; Back from main (this is also the _exit entry): 

_exit:	
		JSR     donelib              ; Run destructors
        EMU_QUIT