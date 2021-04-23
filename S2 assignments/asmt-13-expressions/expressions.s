  .syntax unified
  .cpu cortex-m4
  .fpu softvfp
  .thumb
  .global  Main

Main:
  @ You can use either
  @
  @   The System stack (R13/SP) with PUSH and POP operations
  @
  @   or
  @
  @   A user stack (R12 has been initialised for this purpose)
  @

  @ 1. Push numbers onto the stack as we find them in the string
  @ 2. When we find an operator, pop the numbers off the stack and carry out the operation
  @ 3. Put the result of this calculation back onto the stack
  @ 4. Repeat these steps until the last operator, only one value should be on the stack, that is the result
  @ 5. Store result

  
While:
  LDRB R2, [R1]       @ELEMENT = ELEMENT [ADDRESS] 
  CMP R2, #0x00       @WHILE (ELEMENT != 0)
  BEQ EndExp          @{
  CMP R2, #0x30       @IF (ELEMENT > 0 && ELEMENT <= 9 && !LASTELWASNO)
  BLO isOperator
  CMP R2, #0x39          
  BHI EndExp          
  CMP R5, #0      
  BNE doubleDigits    @{ 
  SUB R2, R2, #0x30
  PUSH {R2}           @PUSH {ELEMENT}
  MOV R5, #1          @LASTELWASNO = TRUE
  B inc               @}
@ELSE IF (LASTELEMENTWASNO)
@ {
doubleDigits:
  POP {R3}            @POP {PREV ELEMENT}
  MOV R4, #10         @FULL ELEMENT = PREV ELEMENT * 10
  MUL R4, R4, R3   
  ADD R2, R4, R2      @FULL ELEMENT = FULL ELEMENT + ELEMENT
  SUB R2, R2, #0x30
  PUSH {R2}           @PUSH{FULL ELEMENT}
  MOV R5, #1          @LASTELWASNO = TRUE
  B inc               @}
isOperator:
  CMP R2, #0x2D       @ELSE IF (ELEMENT == "-" || ELEMENT == "+" || ELEMENT == "*")
  BEQ subtraction
  CMP R2, 0x2B
  BEQ addition
  CMP R2, #0x2A 
  BEQ multiply
  B isSpace    
addition:       @{
   @IF (ELEMENT = +) { 
  POP {R7, R8}     @POP {PREVIOUS 2 ELEMENTS}
  MOV R5, #0       @ LASTELWASNO = FALSE
  ADD R9, R7, R8   @C = A + B
  PUSH {R9}        @PUSH {C}
  B inc            @}
subtraction:
   @ELSE IF (ELEMENT = - )
   @{ 
  POP {R7, R8}     @POP {PREVIOUS 2 ELEMENTS}
  MOV R5, #0       @ LASTELWASNO = FALSE
  SUB R9, R8, R7   @C = A - B
  PUSH {R9}        @PUSH {C}
  B inc            @}#
multiply:
   @ELSE IF (ELEMENT = *)
   @{
  POP {R7, R8}     @POP {PREVIOUS 2 ELEMENTS}
  MOV R5, #0       @ LASTELWASNO = FALSE
  MUL R9, R7, R8   @C = A* B
  PUSH {R9}        @PUSH {C}
  B inc            @@}
isSpace:
  MOV R5, #0       @ LASTELWASNO = FALSE
  CMP R2, #0x20
  BNE EndExp
inc:
   ADD R1, R1, #1 @INCREMENT ADDRESS : ADDRESS += 1
   B While        @}
   @
   


EndExp:
  POP {R9}
  MOV R0, R9


  @ End of program ... check your result

End_Main:
  BX    lr

