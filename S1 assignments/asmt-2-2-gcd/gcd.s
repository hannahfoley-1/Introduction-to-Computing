  .syntax unified
  .cpu cortex-m4
  .thumb
  .global  Main

Main:

  @ Write an ARM Assembly Language Program that will compute
  @   the GCD (greatest common divisor) of two numbers in R2 and R3.
  
  @pseudo code on assignment sheet 
While:
  CMP R2, R3
  BEQ EqualBranch @while (a!=b)
  CMP R2, R3 @{if (a>b)
  BLS ElseBranch @{
  SUB R2,R2, R3 @a=a-b ;
  MOV R0, R2 
  B While @}
ElseBranch: @else {
  SUB R3, R3, R2 @b=b-a;
  MOV R0, R3
  B While @}
  @}
  B EndWhile
EqualBranch:
  @If a=b the greatest common divider is a which is also b
  MOV R0, R2 @
EndWhile:

  @ End of program ... check your result

End_Main:
  BX    lr

.end
