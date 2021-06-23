  .syntax unified
  .cpu cortex-m4
  .thumb
  .global  Main

Main:

  @ Write an ARM Assembly Language Program that will divide a
  @   value, a, in R2 by another value, b, in R3.
  
  @a/b 
  @store quotient in R0
  @Store remainder in R1

  @subtract b from a until b>a
  @each time b is subtracted add one to the value stored in quoient
  @value remaining in a is the remainder
  @BE CAREFUL OF A VALUES,AND IF VALUES ARE 0
  @IF A IS LESS THAN B
  
  MOV R0, #0
  MOV R1, #0
 
  CMP R2, #0
  CMP R3, #0
  BEQ EndWhile
 
  WhileLabel: @while (b<a)
  CMP R3, R2 
  BHI EndWhile @{
  SUB R2, R2, R3 @a=a-b
  ADD R0, R0, #1 @quoteint=quoteint+1
  B WhileLabel @}
  EndWhile:
  @quotient=R0
  MOV R1, R2 @a=R1

  @ End of program ... check your result

End_Main:
  BX    lr

.end
