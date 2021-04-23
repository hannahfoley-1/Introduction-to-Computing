  .syntax unified
  .cpu cortex-m4
  .thumb
  .global  Main

Main:

  @ if (ch=='a' || ch=='e' || ch=='i' || ch=='o' || ch=='u')
  @ {
  @ 	v = 1;
  @ }
  @ else {
  @ 	v = 0;
  @ }

  @ *** your solution goes here ***

  @ End of program ... check your result

End_Main:
  BX    lr

.end