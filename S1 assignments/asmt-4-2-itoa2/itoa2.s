  .syntax unified
  .cpu cortex-m4
  .fpu softvfp
  .thumb
  .global  Main

Main:

 @ADDRESS IN NEW MEMEORY STARTS AT R0
@FIRST ADDRESS OF OLD MEMORY STARTS AT R1

@if 0 just store 0
@1st find sign and store
@2nd find out how many times it divides into ten
@a loop which will take each value and move it into R0 after converting to ascii code

@IS IT EQUAL TO ZERO/ WHAT IS ITS SIGN

CMP R1, #0      @if value == 0
BEQ IsZero      @{ (branches for signs)
BLT IsNegative
BHI IsPositive

IsZero:
MOV R3, #0        @ storedValue = 0
ADD R3, R3, 0x30  @ 0 + 0x30 (change to ascii)
STRB R3, [R0]     @ store value
B EndItoA

IsNegative:
LDR R4, =0x2D     @ Sign = '-'
STRB R4, [R0]     @ storedSign = '-' 
ADD R0, R0, #1    @ storedAddress = storedAddress + 1
RSB R1, R1, #0    @ getting absolute value of number
B TenLoop

IsPositive:
LDR R4, =0x2B     @ sign = '+'
STRB R4, [R0]     @ storedSign = '+' 
ADD R0, R0, #1    @ storedAddress = storedAddress + 1

@THIS PART WILL STORE THE NUMBERS IN NEW MEMORY @NUMBER IS IN R3 
@Start by finding the largest power of 10 that is just smaller than the original value

TenLoop:
MOV R10, #10       @ a = 10
MOV R9, R10        @ b = 10 (power of 10
PowerOfTen:
CMP R1, R9         @ while (value >= b)
BLO NumberLoop     @ {
MUL R9, R9, R10    @ b = b * a
B PowerOfTen       @ }

NumberLoop:        @ while (
@divide by this largest power of 10
UDIV R9, R9, R10   @ b = b/a
CMP R9, #0         @ b > 0
BEQ EndItoA	       @ {
MOV R6, R1         @ c = value
UDIV R3, R6, R9    @ value (C) / power of 10 (b)
ADD R7, R3, 0x30   @ ascii = result + 0x30
STRB R7, [R0]      @ store the msb into the result memory string
ADD R0, R0, #1     @ increment result memory string addrese by 1
MUL R5, R3, R9     @ value * power of 10 
SUB R5, R6, R5     @ value - (value * power of 10) finding the remainder       
MOV R1, R5         @ move remainder into the register that were using for computations
B NumberLoop       @ }

EndItoA:  


  @
  @ TIP: To view memory when debugging your program you can ...
  @
  @   Add the following watch expression: (unsigned char [64]) strA
  @
  @   OR
  @
  @   Open a Memory View specifying the address 0x20000000 and length at least 11
  @   You can open a Memory View with ctrl-shift-p type view memory (cmd-shift-p on a Mac)
  @

  @ End of program ... check your result

End_Main:
  BX    lr

