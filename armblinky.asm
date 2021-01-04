/* Assembly program using ODR instructions to toggle different groups of LEDs
 * between states of being on and off on STM32F446RE Nucleo64 board at 1 Hz
 */  	
			
			EXPORT  __Vectors
            EXPORT  Reset_Handler
            AREA    vectors, CODE, READONLY

__Vectors   DCD     0x10010000  ; 0x20008000    ; Top of Stack
            DCD     Reset_Handler               ; Reset Handler

RCC_AHB1ENR equ 0x40023830
GPIOA_MODER equ 0x40020000
GPIOA_ODR	equ 0x40020014

            AREA    PROG, CODE, READONLY
Reset_Handler
            ldr     r4, =RCC_AHB1ENR    ; enable GPIOA clock
            mov     r5, #1
            str     r5, [r4]
            
            ldr     r4, =GPIOA_MODER    ; set pin to output mode
			mov		r5, #0
            str     r5, [r4]
            ldr     r5, =0x00005555
            str     r5, [r4]

L1          ldr     r4, =GPIOA_ODR
            ldr     r5, =0x000000C0    ; turn on NSG & EWR
            str     r5, [r4]
            mov     r0, #5000
            bl      delay
			
			ldr     r4, =GPIOA_ODR
            ldr     r5, =0x00000082    ; turn on NSY & EWR
            str     r5, [r4]
            mov     r0, #2000
            bl      delay
            
			
			ldr     r4, =GPIOA_ODR
            ldr     r5, =0x00000021    ; turn on NSR & EWG
            str     r5, [r4]
            mov     r0, #5000
            bl      delay
            
            ldr     r4, =GPIOA_ODR
            ldr     r5, =0x00000011    ; turn off NSR & EWY
            str     r5, [r4]
            mov     r0, #2000
            bl      delay
            b       L1                 ; loop forever

; delay milliseconds in R0
delay       ldr     r1, =5325
DL1         subs    r1, r1, #1
            bne     DL1
            subs    r0, r0, #1
            bne     delay
            bx      lr
            
            end
			