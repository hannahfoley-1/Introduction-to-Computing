  .syntax unified
  .cpu cortex-m4
  .thumb

  .global  Init_Test

  .section  .text

  .type     Init_Test, %function
Init_Test:
  @ Test with -12
  LDR   R3, =-12      @ 0xFFFFFFF4

  bx    lr

.end