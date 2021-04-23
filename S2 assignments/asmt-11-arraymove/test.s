  .syntax unified
  .cpu cortex-m4
  .fpu softvfp
  .thumb

  .global Init_Test
  .global init_array
  .global array

  .section  .text


  .type     Init_Test, %function
Init_Test:
  STMFD   SP!, {R4-R7,LR}

  BL      InitRam         @ utility subroutine to initialise RAM from ROM

  LDR     R0, =array      @ start address of array
  LDR     R1, =6          @ move element from this index
  LDR     R2, =3          @ move element to this index

  LDMFD   SP!, {R4-R7, PC}


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
init_array:
  .word   3, 6, 1, 9, 0, 7, 2, 8, 6, 4
  .equ   size_array, .-init_array
init_end:


  .section  .data
data_start:
array:
  .space  size_array    @ enough space for the initial array contents above

.end
