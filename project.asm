;licznik 0-9 7seg
;atmega32a zl3avr
;timer1 przerwania
;rafal

.include "m32def.inc"

.def t=r16
.def d=r17

.org 0x0000
rjmp RESET

.org TIMER1_COMPAaddr
rjmp T1_ISR

RESET:
ldi t,HIGH(RAMEND)
out SPH,t
ldi t,LOW(RAMEND)
out SPL,t

;portb segmety
ldi t,255
out DDRB,t

;start 0
ldi d,0
rcall DISP

;timer1 ctc
ldi t,HIGH(976)
out OCR1AH,t
ldi t,LOW(976)
out OCR1AL,t

;ctc
ldi t,(1<<WGM12)
out TCCR1B,t

;presk 1024
ori t,(1<<CS12)|(1<<CS10)
out TCCR1B,t

;irq
ldi t,(1<<OCIE1A)
out TIMSK,t
sei

LOOP:
rjmp LOOP

T1_ISR:
inc d
cpi d,10
brlo OK
ldi d,0
OK:
rcall DISP
reti

DISP:
ldi ZH,HIGH(TAB<<1)
ldi ZL,LOW(TAB<<1)
add ZL,d
adc ZH,__zero_reg__
lpm t,Z
out PORTB,t
ret

;katoda wspulna
TAB:
.db 0b00111111
.db 0b00000110
.db 0b01011011
.db 0b01001111
.db 0b01100110
.db 0b01101101
.db 0b01111101
.db 0b00000111
.db 0b01111111
.db 0b01101111
