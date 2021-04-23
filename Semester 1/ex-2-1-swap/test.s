  .syntax unified
  .cpu cortex-m4
  .thumb

  .global  Init_Test

  .section  .text

  .type     Init_Test, %function
Init_Test:
  @ Test with R0=3 and R1=6
  MOV   R0, #3
  MOV   R1, #6
  bx    lr

.end