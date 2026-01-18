; autor: Rafał Małycha

.include "m32def.inc"
.cseg
.org 0x0000
rjmp start

.org 0x0020
przerwanie_timer0:
    inc cyfra
    cpi cyfra,10
    brlo koniec
    ldi cyfra,0
koniec:
    rjmp RETI
RETI: reti

start:
    ; stos
    ldi r16,HIGH(RAMEND)
    out SPH,r16
    ldi r16,LOW(RAMEND)
    out SPL,r16

    ; DDRD - segmenty
    ldi r16,0xFF
    out DDRD,r16
    ldi r16,0
    out PORTD,r16

    ; Timer0 CTC, prescaler 256
    ldi r16,0b00001100
    out TCCR0,TCCR0_CS02+TCCR0_WGM01
    ldi r16,61
    out OCR0,r16
    ldi r16,(1<<OCIE0)
    out TIMSK,r16
    sei

    ldi cyfra,0

glowna_petla:
    rcall wyswietl
    rjmp glowna_petla

wyswietl:
    ldi r16,0
    out PORTD,r16
    mov r17,cyfra
    cpi r17,0
    breq zero
    cpi r17,1
    breq jeden
    cpi r17,2
    breq dwa
    cpi r17,3
    breq trzy
    cpi r17,4
    breq cztery
    cpi r17,5
    breq piec
    cpi r17,6
    breq szesc
    cpi r17,7
    breq siedem
    cpi r17,8
    breq osiem
    cpi r17,9
    breq dziewiec
    ret

zero:  ldi r16,0b00111111
       out PORTD,r16
       ret
jeden: ldi r16,0b00000110
       out PORTD,r16
       ret
dwa:   ldi r16,0b01011011
       out PORTD,r16
       ret
trzy:  ldi r16,0b01001111
       out PORTD,r16
       ret
cztery:ldi r16,0b01100110
       out PORTD,r16
       ret
piec:  ldi r16,0b01101101
       out PORTD,r16
       ret
szesc: ldi r16,0b01111101
       out PORTD,r16
       ret
siedem:ldi r16,0b00000111
       out PORTD,r16
       ret
osiem: ldi r16,0b01111111
       out PORTD,r16
       ret
dziewiec:ldi r16,0b01101111
         out PORTD,r16
         ret

.def cyfra = r18
