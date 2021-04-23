  .syntax unified
  .cpu cortex-m4
  .fpu softvfp
  .thumb

  .global Init_Test
  .global setA
  .global setB
  .global setC


  .section  .text

  .type     Init_Test, %function
Init_Test:
  @ Set R1 to the start address of the test string
  LDR   R1, =setA   @ address of set A
  LDR   R2, =setB   @ address of set B
  LDR   R0, =setC   @ address to store set C
  BX    LR


  .section  .rodata

setA:
  .word  10                                       @ size A
  .word  32, 57, -18, 81, 99, -5, 0, 13, -70, 7   @ elems A

setB:
  .word  8                                        @ size B
  .word  -7, 14, 44, 81, -5, 15, 0, 2             @ elems B


  .section  .data

setC:
  .space    4                                     @ size C
  .space    64                                    @ elems C

.end