  .syntax unified
  .cpu cortex-m4
  .thumb
  .global  Init_Test

  .section  .text

  .type     Init_Test, %function
Init_Test:
  @ Set up a, b, c and d with some test values
  MOV   R1, #6          @ a=6
  MOV   R2, #7          @ b=7
  MOV   R3, #8          @ c=8
  MOV   R4, #9          @ d=9
  bx    lr

.end

@ Hello Elliot and Kevin!
