;*******************************************************************************
;* File: main.asm
;* Description: Assembly Language Program for PIC16F887 Microcontroller implementing Count Up and Count Down operations.
;* 
;* Author: yasser boutslighoi
;* Date: 20/05/2024
;*
;* This assembly program is designed for a PIC microcontroller. It reads input
;* from PORTD and PORTC. PORTD is used to set the maximum value for the register.
;* If the least significant bit of PORTC is high, it increments a register. If 
;* it's low, it decrements the register. The updated register value is then 
;* output to PORTB. The program also includes two delay routines, TEMP0 and 
;* TEMP1, which are used to introduce delays in the program execution.
;*
;* Note: This program is designed to be loaded onto a PIC microcontroller using
;*       an appropriate programmer and development environment.
;*
;*******************************************************************************

include <p16F887.inc>
ORG 0x00
__CONFIG _CONFIG1, _INTRC_OSC_NOCLKOUT & _PWRTE_ON & _WDT_OFF
LIST p=16F887


;*******************************************************************************
;* Function: setup
;* Description:
;*     This function initializes the ports and registers for the microcontroller.
;*     It clears PORTB, PORTD, and PORTC, and sets the appropriate bits in 
;*     TRISB, TRISC, and TRISD for input and output configuration.
;*******************************************************************************
setup:
	Max EQU 0x21
	Counter EQU 0x22
	BCF STATUS, RP0
	CLRF PORTB
	CLRF PORTD
	CLRF PORTC
	BSF STATUS, RP0
	CLRF TRISB
	BSF TRISC, 0
	MOVLW 0xFF
	MOVWF TRISD
	BCF STATUS, RP0

;*******************************************************************************
;* Function: main
;* Description:
;*     This function sets up the main loop of the program. It initializes the 
;*     counter and sets the maximum value from PORTD. It then enters the main 
;*     program loop.
;*******************************************************************************
main:
	BCF STATUS, RP0
	MOVLW B'00000000'
	MOVWF Counter
	MOVF PORTD, W
	BTFSC STATUS, Z
	goto main
	MOVWF Max

;*******************************************************************************
;* Function: loop
;* Description:
;*     This function is the main program loop. It reads from PORTC and increments
;*     or decrements the counter based on the input. It also checks if the counter
;*     has reached the maximum value, and if so, resets it to zero.
;*******************************************************************************
loop:
	BCF STATUS, RP0
	MOVF PORTC, W
	BTFSS PORTC, 0
	goto decrement

;*******************************************************************************
;* Function: increment
;* Description:
;*     This function increments the Counter register. If the Counter exceeds the
;*     Max value, it resets the Counter and goes back to the main function. 
;*     Otherwise, it updates PORTB with the Counter value, calls the TEMP1 delay 
;*     function, and goes back to the loop.
;*******************************************************************************
increment:
	INCF Counter, F
	MOVF Max, W
	SUBWF Counter, W
	BTFSC STATUS, 2
	goto main
	MOVF Counter, W
	MOVWF PORTB
	CALL TEMP1
	goto loop

;*******************************************************************************
;* Function: decrement
;* Description:
;*     This function decrements the Counter register. If the Counter is zero, it
;*     goes back to the main function. Otherwise, it updates PORTB with the 
;*     Counter value, calls the TEMP1 delay function, and goes back to the loop.
;*******************************************************************************
decrement:
	MOVF Counter, W
	BTFSC STATUS, Z
	goto main  
	DECF Counter, F
	MOVF Counter, W
	MOVWF PORTB
	CALL TEMP1
	goto loop

;*******************************************************************************
;* Function: decrement
;* Description:
;*     This function decrements the Counter register. If the Counter is zero, it
;*     goes back to the main function. Otherwise, it updates PORTB with the 
;*     Counter value, calls the TEMP1 delay function, and goes back to the loop.
;*******************************************************************************
TEMP0:
	MOVLW 0xFF
	MOVWF 0x23

loop0:
	DECFSZ 0x23, 1
	goto loop0
	RETURN

;*******************************************************************************
;* Function: TEMP1
;* Description:
;*     This function initializes a memory location (0x24) with the value 0xFF,
;*     then calls the TEMP0 function and decrements the value at 0x24 until
;*     it reaches 0. It then returns to the calling function.
;*******************************************************************************
TEMP1:
	MOVLW 0xFF
	MOVWF 0x24

loop1:
	CALL TEMP0
	DECFSZ 0x24, 1
	goto loop1
	RETURN

done:
	goto done

END   