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

  @ Set R1 and R2 to the start addresses of Sets A and B
  LDR   R1, =setA   @ address of set A
  LDR   R2, =setB   @ address of set B

  @ Set R0 to the address where your program should store Set C
  LDR   R0, =setC   @ address to store set C

  BX    LR



  .section  .rodata             @ store original sets in Read Only Memory (ROM)

  .align 8                      @ you can ignore this - it just forces A to
                                @   start at some address 0x??????00
setA:
  .word  4                      @ number of elements in A
  .word  10, 12, -14, 16        @ elements in A

  .align 8                      @ you can ignore this - it just forces B to
                                @   start at some address 0x??????00
setB:
  .word  4                      @ number of elements in B
  .word  8, 12, 18, 16          @ elements in B



  .section  .data               @ store new set in Random Access Memory (RAM)

setC:
  .space    4                   @ space to sture number of elements in C
  .space    64                  @ space to store elements in C


.end