  .syntax unified
  .cpu cortex-m4
  .thumb
  .global  Main

Main:

  @ Compute absolute value of value in R1

  @result = value
  @if value is less than 0, 
  @result = 0 - value
  @if value is greater than 0, end code

  MOV R0, R1
  CMP R0, #0
  BGE  EndIfPos  @End If Greater Than/Equal To 0
  RSB R0, R0, #0
  EndIfPos:

  @ End of program ... check your result

End_Main:
  BX    lr

.end