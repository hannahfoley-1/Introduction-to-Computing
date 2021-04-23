  .syntax unified
  .cpu cortex-m4
  .fpu softvfp
  .thumb

  .global Init_Test
  .global originalString
  .global newString


  .section  .text

  .type     Init_Test, %function
Init_Test:

  LDR   R0, =newString        @ start address for new lowerCamelCase string
  LDR   R1, =originalString   @ start address for original string

  BX    LR


  .section  .rodata           @ store original string in Read Only Memory (ROM)

originalString:               @ original NULL-terminated ASCII string
  .asciz  "TRINITY COLLEGE, DUBLIN."


  .section  .data             @ store new string in Random Access Memory (RAM)

newString:                    @ space for new string
  .space  256

.end