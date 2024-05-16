.equ F_CPU = 16000000

; Include the necessary device definition file
.include "m328pbdef.inc"

; Start of the program
.org 0x0000

main:
    ; Set PORTD as output
    ldi r16, 0xFF
    out DDRD, r16

    ; Initialize PORTD to 0
    clr r16
    out PORTD, r16

    ; Start with only the LSB on
    ldi r18, 0x01
    out PORTD, r18
    call Delay_2sec
    call Delay_1sec  ; Additional 1 sec delay at the start (corner)

    ; Begin the main loop with direction set to forward (0)
    ldi r17, 0

main_loop:
    ; Check direction
    tst r17
    brne shift_right

shift_left:
    ; Shift left (LSB to MSB), light up one LED at a time
    ldi r20, 7       ; Iterate through 7 more LEDs (total 8)

left_loop:
    lsl r18          ; Logical shift left
    out PORTD, r18   ; Output to LEDs
    call Delay_2sec  ; Call the delay function
    dec r20
    brne left_loop

    ; Extra delay at the corner (MSB)
    call Delay_1sec

    ; After reaching MSB, change direction
    ldi r17, 1
    rjmp main_loop

shift_right:
    ; Shift right (MSB to LSB), light up one LED at a time
    ldi r20, 7       ; Iterate through 7 more LEDs (total 8)

right_loop:
    lsr r18          ; Logical shift right
    out PORTD, r18   ; Output to LEDs
    call Delay_2sec  ; Call the delay function
    dec r20
    brne right_loop

    ; Extra delay at the corner (LSB)
    call Delay_1sec

    ; After reaching LSB, change direction
    clr r17
    rjmp main_loop

; Subroutine for a delay of approximately 2 seconds
Delay_2sec:
    ; Implement delay here, placeholder values
    ldi r25, 160      ; Outer loop counter
    ldi r24, 255     ; Inner loop counter

delay_outer_2sec:
    ldi r23, 255     ; Innermost loop counter
delay_inner_2sec:
    dec r23
    brne delay_inner_2sec
    dec r24
    brne delay_inner_2sec
    dec r25
    brne delay_outer_2sec
    ret

; Subroutine for a delay of approximately 1 second
Delay_1sec:
    ; Implement delay here, placeholder values
    ldi r25, 80      ; Outer loop counter
    ldi r24, 255     ; Inner loop counter

delay_outer_1sec:
    ldi r23, 255     ; Innermost loop counter
delay_inner_1sec:
    dec r23
    brne delay_inner_1sec
    dec r24
    brne delay_inner_1sec
    dec r25
    brne delay_outer_1sec
    ret

; End of program
