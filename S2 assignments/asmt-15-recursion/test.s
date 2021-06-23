  .syntax unified
  .cpu cortex-m4
  .fpu softvfp
  .thumb

  .global Main
  .global Init_Test
  .global testArray

  .set hi_testArray, ((size_testArray / 4) - 1)



  .section  .text

Main:
  STMFD   SP!, {LR}

  LDR     R0, =testArray
  LDR     R1, =0
  LDR     R2, =hi_testArray
  BL      quicksort

End_Main:
  LDMFD   SP!, {PC}


  .type     Init_Test, %function
Init_Test:
  PUSH    {LR}
  BL      InitRam
  POP     {PC}


@ InitRam subroutine
@ Utility subroutine to initialise RAM from ROM
InitRam:

  STMFD   SP!, {R4-R7,LR}
  
  LDR   R4, =init_start    @ start address of initialisation data
  LDR   R5, =init_end      @ end address of initialisation data
  LDR   R6, =data_start    @ start oddress of RAM data

.LwhInit:
  CMP   R4, R5            @ copy word-by-word from init_start
  BHS   .LewhInit         @   to init_end in ROM, storing in RAM
  LDR   R7, [R4], #4      @   starting at data_start
  STR   R7, [R6], #4      @
  B     .LwhInit          @
.LewhInit:                @

  LDMFD   SP!, {R4-R7,PC}


  .section  .rodata

init_start:

init_testArray:
  .word  7,1,3,9,0,2,6,8,4,5
  .equ   size_testArray, .-init_testArray

init_end:


  .section  .data

data_start:

testArray:
  .space  size_testArray  @ enough space for a copy of testArray above


.end
