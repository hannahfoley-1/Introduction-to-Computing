  .syntax unified
  .cpu cortex-m4
  .fpu softvfp
  .thumb

  .global Init_Test
  .global sequence

  .section  .text

  .type     Init_Test, %function
Init_Test:

  @ Set R1 to the start address of values in memory
  @ Set R2 to the number of values in the sequence
  LDR   R1, =sequence
  LDR   R2, =8

  @ Copy sequence from ROM to RAM
  LDR   R7, =init_sequence
  MOV   R6, R1
  MOV   R4, #0
Copy:
  CMP   R4, R2
  BEQ   EndCopy
  LDR   R5, [R7], #4
  STR   R5, [R6], #4
  ADD   R4, R4, #1
  B     Copy
EndCopy:

  BX    LR


  @ ROM
  .section  .rodata

init_sequence:
  .word  5, 3, 7, 5, 3, 5, 1, 9


  @ RAM
  .section  .data

sequence:
  .space    256

.end