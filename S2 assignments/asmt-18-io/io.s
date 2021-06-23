  .syntax unified
  .cpu cortex-m4
  .thumb
  .global Main
  .global SysTick_Handler
  .global EXTI0_IRQHandler
  .global flashx4
  .global allOff
  .global allOn

  @ Definitions are in definitions.s to keep this file "clean"
  .include "definitions.s"

  .equ    BLINK_PERIOD, 1000
  .equ    BLINK_PERIOD1, 200
  .equ    BLINK_PERIOD2, 900
  .equ    BLINK_DELAY_LOSS, 2000

@
@ To debug this program, you need to change your "Run and Debug"
@   configuration from "Emulate current ARM .s file" to "Graphic Emulate
@   current ARM .s file".
@
@ You can do this is either of the followig two ways:
@
@   1. Switch to the Run and Debug panel ("ladybug/play" icon on the left).
@      Change the dropdown at the top of the Run and Debug panel to "Graphic
@      Emulate current ARM .s file".
@
@   2. ctrl-shift-P (cmd-shift-P on a Mac) and type "Select and Start Debugging".
@      When prompted, select "Graphic Emulate ...".
@



Main:
  PUSH    {R4-R5,LR}
  
  @global booleans
  MOV R10, #1 @boolean state = true (active)
  MOV R11, #0 @boolean redOn = false

  @ Enable GPIO port D by enabling its clock
  LDR     R4, =RCC_AHB1ENR
  LDR     R5, [R4]
  ORR     R5, R5, RCC_AHB1ENR_GPIODEN
  STR     R5, [R4]

  @BUTTON CODE:
  @ Enable (unmask) interrupts on external interrupt Line0
  LDR     R4, =EXTI_IMR
  LDR     R5, [R4]
  ORR     R5, R5, #1
  STR     R5, [R4]

  @ Set falling edge detection on Line0
  LDR     R4, =EXTI_FTSR
  LDR     R5, [R4]
  ORR     R5, R5, #1
  STR     R5, [R4]

  @ Enable NVIC interrupt #6 (external interrupt Line0)
  LDR     R4, =NVIC_ISER
  MOV     R5, #(1<<6)
  STR     R5, [R4]


  @ Configure LD3 for output
  @ by setting bits 27:26 of GPIOD_MODER to 01 (GPIO Port D Mode Register)
  @ (by BIClearing then ORRing)
  LDR     R4, =GPIOD_MODER
  LDR     R5, [R4]                  @ Read ...
  BIC     R5, #(0b11<<(LD3_PIN*2))  @ Modify ...
  ORR     R5, #(0b01<<(LD3_PIN*2))  @ write 01 to bits 
  STR     R5, [R4]                  @ Write

  @ Configure LD4 for output
  @ by setting bits 27:26 of GPIOD_MODER to 01 (GPIO Port D Mode Register)
  @ (by BIClearing then ORRing)
  LDR     R4, =GPIOD_MODER
  LDR     R6, [R4]                  @ Read ...
  BIC     R6, #(0b11<<(LD4_PIN*2))  @ Modify ...
  ORR     R6, #(0b01<<(LD4_PIN*2))  @ write 01 to bits 
  STR     R6, [R4]                  @ Write

  @ Configure LD5 for output
  @ by setting bits 27:26 of GPIOD_MODER to 01 (GPIO Port D Mode Register)
  @ (by BIClearing then ORRing)
  LDR     R4, =GPIOD_MODER
  LDR     R7, [R4]                  @ Read ...
  BIC     R7, #(0b11<<(LD5_PIN*2))  @ Modify ...
  ORR     R7, #(0b01<<(LD5_PIN*2))  @ write 01 to bits 
  STR     R7, [R4]                  @ Write

  @ Configure LD6 for output
  @ by setting bits 27:26 of GPIOD_MODER to 01 (GPIO Port D Mode Register)
  @ (by BIClearing then ORRing)
  LDR     R4, =GPIOD_MODER
  LDR     R8, [R4]                  @ Read ...
  BIC     R8, #(0b11<<(LD6_PIN*2))  @ Modify ...
  ORR     R8, #(0b01<<(LD6_PIN*2))  @ write 01 to bits 
  STR     R8, [R4]                  @ Write

  @ We'll blink the LEDs every 1s
  @ Initialise the first countdown to 1000 (1000ms)
  LDR     R4, =count
  LDR     R5, =BLINK_PERIOD
  STR     R5, [R4]  

  @ Configure SysTick Timer to generate an interrupt every 1ms
  LDR   R4, =SYSTICK_CSR            @ Stop SysTick timer
  LDR   R5, =0                      @   by writing 0 to CSR
  STR   R5, [R4]                    @   CSR is the Control and Status Register
  
  LDR   R4, =SYSTICK_LOAD           @ Set SysTick LOAD for 1ms delay
  LDR   R5, =0x3E7F                 @ Assuming a 16MHz clock,
  STR   R5, [R4]                    @ 16x10^6 / 10^3 - 1 = 15999 = 0x3E7F

  LDR   R4, =SYSTICK_VAL            @   Reset SysTick internal counter to 0
  LDR   R5, =0x1                    @     by writing any value
  STR   R5, [R4]

  LDR   R4, =SYSTICK_CSR            @   Start SysTick timer by setting CSR to 0x7
  LDR   R5, =0x7                    @     set CLKSOURCE (bit 2) to system clock (1)
  STR   R5, [R4]                    @     set TICKINT (bit 1) to 1 to enable interrupts
                                    @     set ENABLE (bit 0) to 1

  @ Nothing else to do in Main
  @ Idle loop forever (welcome to interrupts!)
Idle_Loop:
  B     Idle_Loop
  
End_Main:
  POP   {R4-R5,PC}


@
@ SysTick interrupt handler
@
  .type  SysTick_Handler, %function
SysTick_Handler:

  PUSH  {R4, R5, LR}

  CMP R10, #1
  BNE .LendIfDelay                  @ if (state = active)

  LDR   R4, =count                  @ if (count!= 0) {
  LDR   R5, [R4]                    @
  CMP   R5, #0                      @
  BEQ   .LelseFire                  @

  SUB   R5, R5, #1                  @   count = count - 1;
  STR   R5, [R4]                    @

  B     .LendIfDelay                @ }

.LelseFire:       
  LDR     R4, =GPIOD_ODR            @   Invert LD3
  LDR     R5, [R4]                  @
  EOR     R5, #(0b1<<(LD3_PIN))     @   GPIOD_ODR = GPIOD_ODR ^ (1<<LD3_PIN);
  STR     R5, [R4]                  @
  MOV     R0, BLINK_PERIOD1         @   slight delay before next led is lit
  BL      delay_ms
  EOR     R5, #(0b1<<(LD4_PIN))     @   GPIOD_ODR = GPIOD_ODR ^ (1<<LD4_PIN);
  STR     R5, [R4]                  @ }
  MOV     R0, BLINK_PERIOD1         @   slight delay before next led is lit
  BL      delay_ms
  EOR     R5, #(0b1<<(LD6_PIN))     @   GPIOD_ODR = GPIOD_ODR ^ (1<<LD6_PIN);
  STR     R5, [R4]                  @ }
  MOV     R0, BLINK_PERIOD1         @   slight delay before next led is lit
  BL      delay_ms
  EOR     R5, #(0b1<<(LD5_PIN))     @   GPIOD_ODR = GPIOD_ODR ^ (1<<LD5_PIN);
  STR     R5, [R4]                  @ 
  MOV     R0, BLINK_PERIOD1         @   slight delay before next led is lit
  BL      delay_ms

  CMP     R11, #0                   @ if (!redOn) 
  BNE     .LredNotOn                @ {
  MOV     R11, #1                   @ redOn = true
  B       .Lcounttdown
.LredNotOn:                         @ else 
  MOV     R11, #0                   @ redOn = false

.Lcounttdown:
  @ We'll blink the LEDs every 1s
  @ Initialise the first countdown to 1000 (1000ms)
  LDR     R4, =count
  LDR     R5, =BLINK_PERIOD
  STR     R5, [R4]  

  @ Configure SysTick Timer to generate an interrupt every 1ms
  LDR   R4, =SYSTICK_CSR            @ Stop SysTick timer
  LDR   R5, =0                      @   by writing 0 to CSR
  STR   R5, [R4]                    @   CSR is the Control and Status Register
  
  LDR   R4, =SYSTICK_LOAD           @ Set SysTick LOAD for 1ms delay
  LDR   R5, =0x3E7F                 @ Assuming a 16MHz clock,
  STR   R5, [R4]                    @ 16x10^6 / 10^3 - 1 = 15999 = 0x3E7F

  LDR   R4, =SYSTICK_VAL            @   Reset SysTick internal counter to 0
  LDR   R5, =0x1                    @     by writing any value
  STR   R5, [R4]

  LDR   R4, =SYSTICK_CSR            @   Start SysTick timer by setting CSR to 0x7
  LDR   R5, =0x7                    @     set CLKSOURCE (bit 2) to system clock (1)
  STR   R5, [R4]                    @     set TICKINT (bit 1) to 1 to enable interrupts
                                    @     set ENABLE (bit 0) to 1

.LendIfDelay:                       @ }
@ } // end of if state = active

  LDR     R4, =SCB_ICSR             @ Clear (acknowledge) the interrupt
  LDR     R5, =SCB_ICSR_PENDSTCLR   @
  STR     R5, [R4]                  @

  @ Return from interrupt handler
  POP  {R4, R5, PC}

@
@ External interrupt line 0 interrupt handler, BUTTON PRESSED
@
  .type  EXTI0_IRQHandler, %function
EXTI0_IRQHandler:

  PUSH  {R4,R5,LR}

  LDR     R4, =GPIOD_ODR            @   
  LDR     R5, [R4]                  @
  LDR     R6, =0x00004000           @   MASK WITH 1 IN THE BIT POSTION WE WANT TO KEEP UNCHANGED AND 0S IN WHERE WE WANT TO CLEAR
  AND     R5, R5, R6                @   ISOLATE BIT 14 
  LSR     R5, R5, #14               @   LOGICAL SHIFT RIGHT 
  CMP     R5, #1
  BNE     .Llose                    @ if (redOn) {
  
  BL flashx4                        @ flash lights
  BL allOn                          @ allOn, keep on and continue 
  B .LendofButton

.Llose:
  @ else
  BL allOff                         @ turn off
  MOV R0, BLINK_DELAY_LOSS          @ wait 2 seconds then begin sequence again
  BL delay_ms 
  
@  CMP R10, #1                       @ if (state = active)
@  BNE .LstateOff                    
@  MOV R10, #0                       @   state = inactive
@  BL allOff                    
@  B .LendofButton                   @ }
@
@.LstateOff: 
@  MOV R10, #0                      @ state = inactive
@  BL allOn                          @ }

.LendofButton:
  @ We'll blink the LEDs every 1s
  @ Initialise the first countdown to 1000 (1000ms)
  LDR     R4, =count
  LDR     R5, =BLINK_PERIOD
  STR     R5, [R4]  

  @ Configure SysTick Timer to generate an interrupt every 1ms
  LDR   R4, =SYSTICK_CSR            @ Stop SysTick timer
  LDR   R5, =0                      @   by writing 0 to CSR
  STR   R5, [R4]                    @   CSR is the Control and Status Register
  
  LDR   R4, =SYSTICK_LOAD           @ Set SysTick LOAD for 1ms delay
  LDR   R5, =0x3E7F                 @ Assuming a 16MHz clock,
  STR   R5, [R4]                    @ 16x10^6 / 10^3 - 1 = 15999 = 0x3E7F

  LDR   R4, =SYSTICK_VAL            @   Reset SysTick internal counter to 0
  LDR   R5, =0x1                    @     by writing any value
  STR   R5, [R4]

  LDR   R4, =SYSTICK_CSR            @   Start SysTick timer by setting CSR to 0x7
  LDR   R5, =0x7                    @     set CLKSOURCE (bit 2) to system clock (1)
  STR   R5, [R4]                    @     set TICKINT (bit 1) to 1 to enable interrupts
                                    @     set ENABLE (bit 0) to 1

  LDR   R4, =EXTI_PR                @ Clear (acknowledge) the interrupt
  MOV   R5, #(1<<0)                 @
  STR   R5, [R4]                    @

  @ Return from interrupt handler
  POP  {R4,R5,PC}

@ subroutine : allOn
@
@ this subroutine turns on all the LEDs and keeps them from flashing
@
allOn:
  PUSH {R4-R6, LR}

  @ change LEDs to be on
  LDR  R4, =GPIOD_ODR              @   Invert LD
  LDR  R5, [R4]                  
  LDR  R6, =0x0000f000
  ORR  R5, R5, R6
  STR  R5, [R4]                     @ }

  POP {R4-R6, PC}


@ subroutine : allOff
@
@ this subroutine turns off all the LEDs and keeps them from flashing
@
allOff:
  PUSH {R4-R6, LR}

  @ turn leds off by using BIC
  LDR  R4, =GPIOD_ODR               @   Invert LED
  LDR  R5, [R4]                     
  LDR  R6, =0x0000f000
  BIC  R5, R5, R6
  STR  R5, [R4]                     

  POP {R4-R6, PC}
  

@ subroutine : flashx4
@
@ this subroutine flashes the LEDs on times quickly to indicate the player has won
@
flashx4:
  PUSH {R4-R6, LR}

  MOV     R6, #0                    @ for (int i = 0; i < 4; i++) {
.LforFlash4:
  CMP     R6, #4
  BGE     .LendFlash4

  LDR     R4, =GPIOD_ODR            @   Invert LEDs
  LDR     R5, [R4]                  @
  EOR     R5, #(0b1<<(LD3_PIN))     @   GPIOD_ODR = GPIOD_ODR ^ (1<<LD3_PIN);
  EOR     R5, #(0b1<<(LD4_PIN))     @   GPIOD_ODR = GPIOD_ODR ^ (1<<LD4_PIN);
  EOR     R5, #(0b1<<(LD6_PIN))     @   GPIOD_ODR = GPIOD_ODR ^ (1<<LD6_PIN);#
  EOR     R5, #(0b1<<(LD5_PIN))     @   GPIOD_ODR = GPIOD_ODR ^ (1<<LD5_PIN);
  STR     R5, [R4]                  @  
  LDR     R0, =200
  BL      delay_ms                  @  wait 200ms by sending to delat subroutine
  ADD     R6, R6, #1
  B       .LforFlash4

.LendFlash4:
  POP {R4-R6, PC}
  
@ delay_ms subroutine
@ Use the Cortex SysTick timer to wait for a specified number of milliseconds
@
@ See Yiu, Joseph, "The Definitive Guide to the ARM Cortex-M3 and Cortex-M4
@   Processors", 3rd edition, Chapter 9.
@
@ Parameters:
@   R0: delay - time to wait in ms
@
@ Return:
@   None
delay_ms:
  PUSH  {R4-R5,LR}

  LDR   R4, =SYSTICK_CSR            @ Stop SysTick timer
  LDR   R5, =0                      @   by writing 0 to CSR
  STR   R5, [R4]                    @   CSR is the Control and Status Register
  
  LDR   R4, =SYSTICK_LOAD           @ Set SysTick LOAD for 1ms delay
  LDR   R5, =15999                  @ Assuming a 16MHz clock,
  STR   R5, [R4]                    @   16x10^6 / 10^3 - 1 = 15999
  
  LDR   R4, =SYSTICK_VAL            @ Reset SysTick internal counter to 0
  LDR   R5, =0x1                    @   by writing any value
  STR   R5, [R4]  

  LDR   R4, =SYSTICK_CSR            @ Start SysTick timer by setting CSR to 0x5
  LDR   R5, =0x5                    @   set CLKSOURCE (bit 2) to system clock (1)
  STR   R5, [R4]                    @   set ENABLE (bit 0) to 1

.LwhDelay:                          @ while (delay != 0) {
  CMP   R0, #0  
  BEQ   .LendwhDelay  
  
.Lwait:
  LDR   R5, [R4]                    @   Repeatedly load the CSR and check bit 16
  AND   R5, #0x10000                @   Loop until bit 16 is 1, indicating that
  CMP   R5, #0                      @     the SysTick internal counter has counted
  BEQ   .Lwait                      @     from 0x3E7F down to 0 and 1ms has elapsed 

  SUB   R0, R0, #1                  @   delay = delay - 1
  B     .LwhDelay                   @ }

.LendwhDelay:

  LDR   R4, =SYSTICK_CSR            @ Stop SysTick timer
  LDR   R5, =0                      @   by writing 0 to CSR
  STR   R5, [R4]                    @   CSR is the Control and Status Register
  

  POP   {R4-R5,PC}

  .section .data

count:
  .space  4


  .end
