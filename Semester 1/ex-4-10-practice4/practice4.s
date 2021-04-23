  .syntax unified
  .cpu cortex-m4
  .thumb
  .global  Main

Main:

  @ if (ch >= 'A' && ch <= 'Z') {
  @ 	ch = ch + 0x20;
  @ }

  @ *** your solution goes here ***

  @ End of program ... check your result

End_Main:
  BX    lr

.end