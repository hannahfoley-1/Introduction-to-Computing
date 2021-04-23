  .syntax unified
  .cpu cortex-m4
  .fpu softvfp
  .thumb

  .global Init_Test
  .global stringA

  .section  .text

  .type     Init_Test, %function
Init_Test:

  @ submitty will put some random initial value in R0
  LDR   R0, =0x00BADBAD

  @ Set R1 to the start address of the test string
  @ Test with various strings defined below
  LDR   R1, =stringA

  BX    LR


  .section  .rodata

stringA:
  .asciz  "Able was I ere I saw Elba"

stringB:
  .asciz  "A man, a plan, a canal - Panama"

stringC:
  .asciz  "Madam, I'm Adam"


.end