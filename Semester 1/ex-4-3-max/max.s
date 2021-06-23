  .syntax unified
  .cpu cortex-m4
  .thumb
  .global  Main

Main:

   @ Calculate the maximum of two values a and b
  @ a is in R1, b is in R2

  CMP R1, R2          @comparing the contents of a and b, a>=b
  BLT ElseMaxB        @when b is the maximum value, we branch to ElseMaxB
  MOV R0, R1          @otherwise, a is the maximum value so we store the result of a in R0
  B EndMax            @we then branch to EndMax so that the program skips over the part wherwe b is max

  ElseMaxB:
  MOV R0, R2          @when b is max, we move the value of b into the result R0

  EndMax:

  @ End of program ... check your result

End_Main:
  BX    lr

.end
