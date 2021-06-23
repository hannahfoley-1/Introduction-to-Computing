  .syntax unified
  .cpu cortex-m4
  .thumb
  .global  Main

Main:

  @ if (ch >= 'A' && ch <= 'Z') {
  @ 	ch = ch + 0x20;
  @ }

  CMP R0, #'A'  @ if (ch >= 'A' && ch <= 'Z') {
  BLT NotCap
  CMP R0, #'Z'
  BGT NotCap
  ADD R0, R0, 0x20 @ 	ch = ch + 0x20;
NotCap: 
  MOV R0, R0 @ }

  @ End of program ... check your result

End_Main:
  BX    lr

.end
