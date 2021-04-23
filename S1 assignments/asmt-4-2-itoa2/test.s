  .syntax unified
  .cpu cortex-m4
  .fpu softvfp
  .thumb

  .global Init_Test
  .global strA

  .section  .text

  .type     Init_Test, %function
Init_Test:
  LDR   R0, =strA
  LDR   R1, =-356
  BX    LR
  

  .section  .data

strA:
  .space  256

.end