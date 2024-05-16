#define F_CPU 16000000UL
#include <avr/io.h>
#include <avr/interrupt.h>
#include <util/delay.h>

volatile int ledCounter = 0; // Counter for the timing of LED operations


ISR(INT1_vect) // External INT1 ISR
{
    if (ledCounter == 0) {
        PORTB = (1 << PB0); // Only turn on PB0
        } else {
        PORTB = 0xFF; // Turn on all LEDs of PORTB
    }
    ledCounter = 0; // Reset counter to zero on each interrupt
    EIFR = (1 << INTF1); // Clear the flag of interrupt INTF1
}

int main(void) {
    // Configure interrupt on rising edge of INT0 and INT1 pins
    EICRA = (1 << ISC11) | (1 << ISC10);
    // Enable the INT0 and INT1 interrupts (PD2 and PD3)
    EIMSK = (1 << INT0) | (1 << INT1);
    sei(); // Enable global interrupts

    DDRB = 0xFF; // Set PORTB as output

    while (1) {
        // Check the ledCounter and manage timing for PB0
        if (ledCounter < 3000) {
            if (ledCounter == 0) {
                PORTB = (1 << PB0); // Only turn on PB0
            }
            if(ledCounter == 1000)
            {
                PORTB = 0x01;
            }
            _delay_ms(1); // Delay 1 ms
            ledCounter++; // Increment counter
            } else {
            PORTB = 0x00; // Turn off all LEDs on PORTB after 3000 ms
        }
    }
}