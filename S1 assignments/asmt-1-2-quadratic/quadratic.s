  .syntax unified
  .cpu cortex-m4
  .thumb
  .global  Main

Main:

  @ Write an ARM Assembly Language program to evaluate
  @   ax^2 + bx + c for given values of a, b, c and x

  @name registers [R0=Result, R1=x, R2=a, R3=b, R4=c]
  @get x^2
  @mul result by a
  @mul b by x
  @add ax^2 + b
  @add c to result

  MOV R0, #1      @result=1
  MUL R0, R1, R1  @result=x*x...(x^2)
  MUL R0, R0, R2  @result=x^2*a

  MUL R5, R3, R1  @result=b*x

  ADD R0, R0, R5  @result=ax^2+bx

  ADD R0, R0, R4  @result=ax^2+bx+c


  @ End of program ... check your result

End_Main:
  BX    lr

.end
