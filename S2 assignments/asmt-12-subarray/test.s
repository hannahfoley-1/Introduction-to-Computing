  .syntax unified
  .cpu cortex-m4
  .fpu softvfp
  .thumb

  .global Init_Test
  .global arrayA
  .global arrayB

  .section  .text


  .type     Init_Test, %function
Init_Test:
  STMFD   SP!, {LR}

  BL      InitRam         @ utility subroutine to initialise RAM from ROM

  LDR     R0, =arrayA     @ start address of arrayA
  LDR     R1, =8          @ size of arrayA (rows/cols)
  LDR     R2, =arrayB     @ start address of arrayB
  LDR     R3, =3          @ size of arrayB (rows/cols)

  LDMFD   SP!, {PC}


@
@ Utility subroutine to initialise RAM from ROM
@
InitRam:

  STMFD   SP!, {R4-R7,LR}
  
  LDR   R4, =init_start    @ start address of initialisation data
  LDR   R5, =init_end      @ end address of initialisation data
  LDR   R6, =data_start    @ start oddress of RAM data

whInit:
  CMP   R4, R5            @ copy word-by-word from init_start
  BHS   ewhInit           @   to init_end in ROM, storing in RAM
  LDR   R7, [R4], #4      @   starting at data_start
  STR   R7, [R6], #4      @
  B     whInit            @
ewhInit:                  @

  LDMFD SP!, {R4-R7,PC}   @ return


  .section  .rodata

init_start:
init_arrayA:
  .word   3,  6, 12,  9,  0, 17,  2,  8
  .word  14, 45,  8, 13, 19, 23, 31,  3
  .word   5, 16, 37, 32, 74,  1, 66, 43
  .word   9, 13, 53, 27, 72, 43, 17, 19
  .word  15, 33, 65, 22,  4, 13, 12,  8
  .word  48, 16, 32, 96,  8,  4, 48,  0
  .word  27, 88, 92, 14,  6, 22, 77, 39
  .word  60, 71, 40, 91, 83, 22, 17, 13
  .equ   size_arrayA, .-init_arrayA

init_arrayB:
  .word  15, 33, 65
  .word  48, 16, 32
  .word  27, 88, 92
  .equ   size_arrayB, .-init_arrayB
init_end:


  .section  .data
data_start:

arrayA:
  .space  size_arrayA    @ enough space for the initial arrayA contents above

arrayB:
  .space  size_arrayB    @ enough space for the initial arrayB contents above

.end
