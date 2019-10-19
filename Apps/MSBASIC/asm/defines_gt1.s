; configuration
CONFIG_2A := 1                  ; Base on CBMBASIC2
CONFIG_CBM_ALL := 1

CONFIG_DATAFLG := 1
CONFIG_EASTER_EGG := 1          ; WAIT-6502 Easter egg
CONFIG_NO_CR := 1               ; Terminal has automatic line wrap
CONFIG_NO_LINE_EDITING := 1     ; Terminal doesn't have "@", "_", BEL etc.
CONFIG_NO_READ_Y_IS_ZERO_HACK := 1
CONFIG_PEEK_SAVE_LINNUM := 1
CONFIG_SCRTCH_ORDER := 2

; zero page
SCRATCH = $19                   ; Use vACH as scratch location
ZP_START1 = $38                 ; 10 bytes
ZP_START2 = ZP_START1+10        ; 6 bytes
ZP_START3 = ZP_START1+3         ; 11 bytes
ZP_START4 = ZP_START1+16        ; 94 bytes incl. gap at $80

; extra/override ZP variables
POSX            := $30          ; X position for POS() and TAB()
CURDVC          := SCRATCH      ; Current device
Z17             := SCRATCH      ; WIDTH
Z18             := SCRATCH      ; WIDTH2
Z96             := SCRATCH      ; System file status variable ST
TXPSV           := LASTOP       ; Text pointer (2 bytges)
USR             := GORESTART    ; Trampoline for USR()
STACK_BOT       := <(GENERIC_CHRGET_END-GENERIC_CHRGET + CHRGET); CHKMEM

STACK           := $0000        ; v6502 has its stack in zero page
STACK2          := $7100        ; Floating point buffer (13+3 bytes)

; inputbuffer
INPUTBUFFER     := $2400        ; Will use INPUTBUFFER-5 and up!
CONFIG_INPUTBUFFER_0200 := 1

; constants
NUMLEV          := 5            ; (Originally 23) Max internal stack levels
SPACE_FOR_GOSUB := STACK_BOT + 2*NUMLEV
STACK_TOP       := $FF          ; Was $FA because INPUTBUFFER-5
WIDTH           := 40           ; Value put in Z17, but never used
WIDTH2          := 30           ; Value put in Z18, but never used
RAMSTART2       := $7200        ; User space

; magic memory locations
ENTROPY = $06

; monitor functions
CHROUT          := $2900        ; Send char or newline to video terminal
GETIN           := $2A00        ; Get key stroke, update TI$
ISCNTC          := $2B00        ; Check for Ctrl-C, update TI$
CLALL           := $2C00        ; Close all devices in init
TISTR           := $2D00        ; 60 Hz 24hr clock TI$ (3+1 bytes)
MONCOUT         := CHROUT
MONRDKEY        := GETIN
LOAD            := SYNERR       ; Not implemented
SAVE            := SYNERR       ; Not implemented
VERIFY          := SYNERR       ; Not implemented

; patches

.segment "CODE"

; update 3-byte timer with latest frameCount before exporting to BASIC
GETTIM:
                lda     $0e     ; frameCount
                tay
                sec
                sbc     TISTR+3
                sty     TISTR+3
                clc
                adc     TISTR+2
                sta     TISTR+2
                lda     #0
                adc     TISTR+1
                sta     TISTR+1
                lda     #0
                adc     TISTR+0
                sta     TISTR+0
                sec             ; for FLOAT3
                jmp     GETTIM1
