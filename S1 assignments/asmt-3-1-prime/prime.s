  .syntax unified
  .cpu cortex-m4
  .thumb
  .global  Main

Main:

  @
  @ Write an ARM Assembly Language Program that will determine
  @   whether the unsigned number in R1 is a prime number
  @
  @ Output:
  @   R0: 1 if the number in R1 is prime
  @       0 if the number in R1 is not prime
  @

  
  @WHATS IN MY REGISTERS
  @R1 the number we are testing
  @R2 = 2 (to divide by 2, if the answer has no remainder, it is even and so not a prime)
  @R3 = Stored the number while dividing by 2
  @R4 = Stored the count (quotient) while dividing FOR ALL NUMBERS
  @R5 = Stored the result of subtraction to see remainder on division
  @R6 = Where I initialised the number for the further division looP
  @R7 = Stored the number for the divide further loop
  
  MOV R2, #0
  MOV R3, #0
  MOV R4, #0
  MOV R5, #0
  MOV R6, #0
  MOV R7, #0     @initialing registers 

  @ *** your solution goes here ***
  CMP R1, #0
  BEQ IsNotPrime     @if the number is 0 it is not a prime number so branch to IsNotPrime
  CMP R1, #1
  BEQ IsNotPrime     @if the number is 1 it is a not prime number so branch to IsNotPrime
  CMP R1, #2
  BEQ IsPrime       @if the number is 2 it is a prime number so branch to IsPrime
  MOV R2, #2        @ t = 2 , to be used on division by 2 
  MOV R3, R1        @ temp register for value as to not destory it 
WhileLabelDivisionBy2:
  CMP R3, R2       @ while (number > 2)
  BLO CheckDivisionBy2 @{
  SUB R3, R3, R2   @number = number - 2 
  ADD R4, R4, #1   @count += 1 (quotient)
  B WhileLabelDivisionBy2 @} 
CheckDivisionBy2:
  MUL R4, R4, R2   @quotient*2
  SUB R5, R1, R4   @result = number - qoutient*2
  CMP R5, #1       @ if (result == 1) {
  BEQ DivideFurther @ it's not an even number so we will try other factors}
  BNE IsNotPrime   @if (result == 0){ it is an even number and so not a prime}
DivideFurther:
  MOV R6, #3       @for (@i=3
DivideFurther1: 
  MOV R7, R1
  MOV R4, #0
  MOV R5, #0      @new loop for these registers to be reset for each new value of i
DivideFurtherLoop: 
  CMP R6, R7      @ ; i < number ; (+=2 will come later)
  BLS DivideFurtherLoop2
  BHI CheckDivisionLoop 
DivideFurtherLoop2: 
  CMP R7, #0       @if number was 0, it has more than likely reached the input value so will be tested to make sure
  BEQ CheckDivisionLoop
  SUB R7, R7, R6   @number = number - i
  ADD R4, R4, #1   @count += 1 (quotient)
  B DivideFurtherLoop @ }
CheckDivisionLoop:
  MUL R4, R4, R6 @quotient = quotient * i
  SUB R5, R1, R4 @result = number - quotient * i
  CMP R5, #0     @ if ( result == 0) { the number was a factor and therefore it's not a prime}
  BEQ IsNotPrime
  ADD R6, R6, #2 @ i = 1 + 2
  CMP R6, R1
  BEQ IsPrime
  B DivideFurther1
IsPrime:
  MOV R0, #1
  B EndPrime
IsNotPrime:
  MOV R0, #0
EndPrime:




  @ End of program ... check your result

End_Main:
  BX    lr

.end
