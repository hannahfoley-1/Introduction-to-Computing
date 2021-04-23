  .syntax unified
  .cpu cortex-m4
  .thumb

  .global  Init_Test

  .section  .text

  .type     Init_Test, %function
Init_Test:
  @ submitty will put some random initial value in R0
  LDR   R0, =0x00BADBAD

  @ test value from the assignment handout (result = 6)
  LDR   R1, =0b10000111111001001011010001000011

  bx    lr

.end