/*
 * File:   main.c
 * Author: yasser
 *
 * Created on May 5, 2024, 10:40 AM
 */


#include <xc.h>

#pragma config FOSC = INTRC_NOCLKOUT    // Oscillator Selection bits
#pragma config WDTE = OFF   // Watchdog Timer disabled
#pragma config PWRTE = ON   // Power-up Timer enabled


void main(void)
{
	OSCCONbits.IRCF = 0b010; // Set internal oscillator frequency to 250 kHz
	OPTION_REGbits.PS = 0b111; // Set Timer0 prescaler to 1:256
	OPTION_REGbits.PSA = 0; // Assign prescaler to Timer0
	OPTION_REGbits.T0CS = 0; // Set Timer0 clock source to internal clock
	INTCONbits.GIE = 1; // Enable global interrupts
	INTCONbits.T0IE = 1; // Enable Timer0 overflow interrupt

	TRISB = 0; // Configure PORTB as output
	PORTB = 0; // Initialize PORTB to 0

	while (1)
	{
		if (INTCONbits.T0IF) // Check Timer0 overflow interrupt flag
		{
			INTCONbits.T0IF = 0; // Clear Timer0 overflow interrupt flag
			TMR0 = 0;	// Reset Timer0 to 0
			PORTB++;
		}
	}
	return;
}