  .syntax unified
  .cpu cortex-m4
  .fpu softvfp
  .thumb
  .global  Main

Main:
  

  @
  @ write your program here
  @


  @
  @ Debugging tips:
  @
  @ If using the View Memory window
  @   - view originalString using address "&originalString" and size 32
  @   - view newString using address "&newString" and size 32
  @
  @ If using a Watch Expression (array with ASCII character codes)
  @   view originalString using expression "(char[32])originalString"
  @   view newString using expression "(char[32])newString"
  @
  @ If using a Watch Expression (just see the string)
  @   view originalString using expression "(char*)&originalString"
  @   view newString using expression "(char*)&newString"
  @


  @ End of program ... check your result

End_Main:
  BX    lr

