#include <pic16f887.h>

void main(void) 
{
	PORTD = 0x0;
	TRISD = 0xFF;
	TRISB = 0x00;
	TRISA = 0x00;

	while (1)
	{
		PORTA = PORTD % 10;
		PORTB = (PORTD / 100 % 10) << 4 | PORTD / 10 % 10;
	}
}
