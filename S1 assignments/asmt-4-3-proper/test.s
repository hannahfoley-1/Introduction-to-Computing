  .syntax unified
  .cpu cortex-m4
  .fpu softvfp
  .thumb

  .global Init_Test
  .global strA

  .section  .text

  .type     Init_Test, %function
Init_Test:

  LDR   R4, =initStrA
  LDR   R5, =strA

  @ Set R1 to the start address of the test string in RAM
  MOV   R1, R5

  @ Copy the test string from ROM to RAM
Loop:
  LDRB  R6, [R4], #1
  STRB  R6, [R5], #1
  CMP   R6, #0
  BNE   Loop
  BX    LR


  .section  .rodata

initStrA:
  .asciz  "HELLO world"


  .section  .data

strA:
  .space  256

.end