;--------------------------------------------------------
; Counter 0–9 on 7-segment display
; Microcontroller: ATmega32A
; Board: ZL3AVR
; Timer1 in CTC mode with interrupt
; Author: Rafal Małycha 3BT 
;--------------------------------------------------------

.include "m32def.inc"

;--------------------------------------------------------
; Register definitions
;--------------------------------------------------------
.def t=r16
.def d=r17

;--------------------------------------------------------
; Interrupt vector table
;--------------------------------------------------------
.org 0x0000
rjmp RESET

.org TIMER1_COMPAaddr
rjmp T1_ISR

;--------------------------------------------------------
; Reset routine – initialization
;--------------------------------------------------------
RESET:
ldi t,HIGH(RAMEND)
out SPH,t
ldi t,LOW(RAMEND)
out SPL,t

ldi t,0xFF
out DDRB,t

ldi d,0
rcall DISP

;--------------------------------------------------------
; Timer1 configuration – CTC mode
;--------------------------------------------------------
ldi t,HIGH(976)
out OCR1AH,t
ldi t,LOW(976)
out OCR1AL,t

ldi t,(1<<WGM12)
out TCCR1B,t

ori t,(1<<CS12)|(1<<CS10)
out TCCR1B,t

ldi t,(1<<OCIE1A)
out TIMSK,t

sei

;--------------------------------------------------------
; Main loop
;--------------------------------------------------------
LOOP:
rjmp LOOP

;--------------------------------------------------------
; Timer1 Compare Match A Interrupt Service Routine
;--------------------------------------------------------
T1_ISR:
inc d
cpi d,10
brlo OK
ldi d,0
OK:
rcall DISP
reti

;--------------------------------------------------------
; Display routine
;--------------------------------------------------------
DISP:
ldi ZH,HIGH(TAB<<1)
ldi ZL,LOW(TAB<<1)
add ZL,d
adc ZH,__zero_reg__
lpm t,Z
out PORTB,t
ret

;--------------------------------------------------------
; 7-segment display lookup table (common cathode)
; Bit order:
;--------------------------------------------------------
TAB:
.db 0b00111111 ; 0
.db 0b00000110 ; 1
.db 0b01011011 ; 2
.db 0b01001111 ; 3
.db 0b01100110 ; 4
.db 0b01101101 ; 5
.db 0b01111101 ; 6
.db 0b00000111 ; 7
.db 0b01111111 ; 8
.db 0b01101111 ; 9
