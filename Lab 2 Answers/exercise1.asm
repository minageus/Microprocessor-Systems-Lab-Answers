 .include "m328PBdef.inc"
.def counter=r16

.org 0x0
    rjmp reset

.org 0x4
    rjmp isr1

reset:
    ;initialize stack pointer
    ldi r24,LOW(RAMEND)
    out SPL,r24
    ldi r24,HIGH(RAMEND)
    out SPH,r24

    ;I/O port setup
    ser r24        ;set register
    out DDRC,r24                    ;port C output

    clr r24        ;clear register
    out DDRD,r24                    ;port D input

    ldi r24, (1<<ISC11) | (1<<ISC10)
    sts EICRA, r24                    ;Interrupt on rising edge of INT1 pin

    ldi r24, (1<<INT1)
    out EIMSK, r24                    ;Enable the INT1 interrupt

    sei                                ;Enable general flag of interrupts

main:
    rjmp main

isr1:
    in r18,PIND
    sbrs r18,7                        ;if PD7 Not pressed (input=1) skip next instruction
    rjmp isr_exit                    ;if input=0 (PD7 pressed) continue displaying the current number of interupts

    ldi r17,0x0F
    inc counter
    and counter,r17
    ;cpi counter, 16                    ;if counter=16 --> Z=1
    ;brne isr_exit                    ;if Z=0 <=> counter<>16

    ;ldi counter,0                    ;else clear counter

isr_exit:
    ;com counter                        ;reverse logic transformation
    out PORTC, counter
    ;com counter                        ;return to normal logic

    ;Delay100 mS
    ldi r24, low(16100)  ; Init r25, r24 for delay 100 mS
    ldi r25, high(16100) ; CPU frequency = 16 MHz
    delay1:
    ldi r23, 249 ; (1 cycle)
    delay2:
    dec r23 ; 1 cycle
    nop ; 1 cycle
    brne delay2 ; 1 or 2 cycles
    sbiw r24, 1 ; 2 cycles
    brne delay1 ; 1 or 2 cycles

    ldi r24, (1 << INTF1)
    out EIFR, r24                    ;Clear external interrupt 1 flag

    reti
