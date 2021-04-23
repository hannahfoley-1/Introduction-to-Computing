  .syntax unified
  .cpu cortex-m4
  .thumb

  .global  Init_Test

  .section  .text

  .type     Init_Test, %function
Init_Test:
  @ Evaluate for 2034 (0x7F2)
  LDR   R1, =0x34   @ '4'
  LDR   R2, =0x33   @ '3'
  LDR   R3, =0x30   @ '0'
  LDR   R4, =0x32   @ '2'

  @ Alternatively, you can initialise this way ...
  @ LDR   R1, ='4'
  @ LDR   R2, ='3'
  @ LDR   R3, ='0'
  @ LDR   R4, ='2'

  bx    lr

.end