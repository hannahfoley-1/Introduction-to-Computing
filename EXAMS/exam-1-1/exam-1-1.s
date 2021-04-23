  .syntax unified
  .cpu cortex-m4
  .fpu softvfp
  .thumb
  .global  Main

Main:
  

  @
  @ Write your program here
  @

  @
  @ REMEMBER: Sets are stored in memory in the format ...
  @
  @   size, element1, element2, element3, etc.
  @
  @ where size is the number of elements in the set, element1 is
  @   the first element, element2 is the second element, etc.
  @ 


  @
  @ Debugging tips:
  @
  @ If using the View Memory window
  @   - view set A using address "&setA" and size 64
  @   - view set B using address "&setB" and size 64
  @   - view set C using address "&setC" and size 64
  @
  @ If using a Watch Expression
  @   view set A using expression "(int[16])setA"
  @   view set B using expression "(int[16])setB"
  @   view set C using expression "(int[16])setC"
  @
  @ BUT REMEMBER, the first value you see should be the size, 
  @  the second value will be the first element, etc. (see above!)

  @ End of program ... check your result

End_Main:
  BX    lr

