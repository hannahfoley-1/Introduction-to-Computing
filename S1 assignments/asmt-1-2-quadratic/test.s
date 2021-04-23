  .syntax unified
  .cpu cortex-m4
  .thumb

  .global  Init_Test

  .section  .text

  .type     Init_Test, %function
Init_Test:
  @ Evaluate 4x^2+3x+7 with x=3
  LDR   R1, =3
  LDR   R2, =4
  LDR   R3, =3
  LDR   R4, =7

  bx    lr

.end