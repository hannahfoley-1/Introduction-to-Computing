  .syntax unified
  .cpu cortex-m4
  .thumb
  .global  Main

Main:
  
  @ Write a program to swap the contents of R0 and R1

  @r2 is empty
  MOV R2, R0
  MOV R0, R1
  MOV R1, R2

  @ End of program ... check your result

End_Main:
  BX    lr

.end
