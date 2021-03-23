  .syntax unified
  .cpu cortex-m4
  .thumb
  .global  Main

Main:

  @ Compute x^y where x is in R1 and y is in R2

  MOV     R0, #1          @ result = 1
While:
  CMP     R2, #0
  BEQ     EndWh           @ while (y != 0) {
  MUL     R0, R0, R1      @  result = result × x
  SUB     R2, R2, #1      @  y = y - 1
  B       While           @ }
EndWh:

  @ End of program ... check your result

End_Main:
  BX    lr

.end