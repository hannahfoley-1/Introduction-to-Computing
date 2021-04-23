  .syntax unified
  .cpu cortex-m4
  .fpu softvfp
  .thumb

  .global Init_Test
  .global stringA
  .global stringB

  .section  .text

  .type     Init_Test, %function
Init_Test:
  STMFD SP!, {LR}

  @ Copy stringA into RAM
  LDR   R0, =stringA
  LDR   R1, =init_stringA
  BL    strCpy

  @ Copy stringB into RAM
  LDR   R0, =stringB
  LDR   R1, =init_stringB
  BL    strCpy

  @ Set R1 to the start address of the test string
  LDR   R1, =stringA
  LDR   R2, =stringB

  LDMFD SP!, {PC}


@
@ String Copy subroutine
@
strCpy:
  STMFD   SP!, {R4}
WhCpy:
  LDRB    R4, [R1], #1
  STRB    R4, [R0], #1
  CMP     R4, #0
  BNE     WhCpy
  LDMFD   SP!, {R4}
  BX      LR


  .section  .rodata

init_stringA:
  .asciz  "easts"

init_stringB:
  .asciz  "seats"


  .section  .data
stringA:
  .space  128
stringB:
  .space  128

.end