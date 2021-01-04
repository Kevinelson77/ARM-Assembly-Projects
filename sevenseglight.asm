 ; This code takes control of a seven segment display through the use of a lookup table.
 ; Loops are utilized to increment through the table, allowing for a countdown timer to
 ; be output. This project utilizes Port B on the STM32-board.
 
 EXPORT  __Vectors
 EXPORT  Reset_Handler
 AREA    vectors, CODE, READONLY


__Vectors   DCD     0x10010000  ; 0x20008000    ; Top of Stack
            DCD     Reset_Handler               ; Reset Handler


RCC_AHB1ENR equ 0x40023830
GPIOB_MODER equ 0x40020400
GPIOB_ODR   equ 0x40020414


            AREA    PROG, CODE, READONLY
Reset_Handler							; Initialization
            LDR     r0, =RCC_AHB1ENR    ; enable GPIOB clock
            MOV     r1, #2
            STR     r1, [r0]
               
            LDR     r0, =GPIOB_MODER    ; set pins to output mode
            LDR     r1, =0x55555555
            STR     r1, [r0]

			MOV		r0, #0
			ADR		r1, LOOKUP			; point to LOOKUP
			LDR     r2, =GPIOB_ODR
			MOV		r3, #13				; set compare value as # of index values
L1			LDRB	r4, [r1, r0]
			STR		r4, [r2]			; display value
			B 		delay				; branch to delay
			ADD		r0, r0, #1
			SUBS	r3, r3, #1
			BNE		FINISH
			B		L1	
FINISH		B		FINISH

delay       MOV     r5, #2
DL1         SUBS    r5, r5, #1
            BNE     DL1
            BX      LR

LOOKUP  	DCB 	0x6F, 0x7F, 0x07, 0x7D, 0x6D, 0x66, 0x4F, 0x5B, 0x06, 0x3F, 0x00, 0x3F, 0x00, 0x3F		;13 index values
			END