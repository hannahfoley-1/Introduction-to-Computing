  .syntax unified
  .cpu cortex-m4
  .thumb
  .global  Main

Main:

  @ Write an ARM Assembly Language program to evaluate
  @   x^3 - 4x^2 + 3x + 8

  @X IS IN R1
   
  @indices
  @get x^3
  MUL R2, R1, R1
  MUL R2, R2, R1
  
  @indices, multiplication
  @get 4x^2
  MUL R3, R1, R1
  LDR R4, =4
  MUL R5, R4, R3

  @multiplication
  @get 3x
  LDR R6, =3
  MUL R7, R6, R1

  @addition
  @get 3x+8
  ADD R8, R7, #8

  @subtraction
  SUB R9, R2, R5

  @addition
  ADD R0, R9, R8


  @ End of program ... check your result

End_Main:
  BX    lr

.end
