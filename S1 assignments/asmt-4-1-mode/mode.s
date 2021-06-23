  .syntax unified
  .cpu cortex-m4
  .fpu softvfp
  .thumb
  .global  Main

Main:

 @RESULT IN R0
  @R1 = START ADDRESS
  @R2 = NUMBER OF VALUES IN THE STRING

  MOV R3, #0 @modeCount = 0;
  MOV R0, #0 @mode = 0; 

  MOV R5, #0 @i1 = 0; (i1 is count of value we are on in string)
While1:  
  CMP R5, R2 @while (i1 < N)
  BHS EndWhile1 @{
  LDRB R6, [R1] @value1 = word[address1]
  MOV R7, #0 @count = 0;
  ADD R8, R1, #4 @address2 = address1 + 4 (next value in string)
  ADD R9, R5, #1 @i2 = i1 + 1 

While2: 
  CMP R9, R2 @while (i2 < N)
  BHS EndWhile2 @{
  LDRB R10, [R8] @value2 = word[address2]
  CMP R6, R10 @if (value1 == value2)
  BNE EndIf @{
  ADD R7, R7, #1 @count = count + 1
  @}

EndIf:
  ADD R9, R9, #1 @i2 = i2 + 1;
  ADD R8, R8, #4 @address2 = address2 + 4;
  B While2 

EndWhile2:
 @}
  CMP R7, R3 @if (count > modeCount)
  BLS EndIf2 @{
  MOV R0, R6 @mode = value1;
  MOV R3, R7 @modeCount = count;
  @}
EndIf2:
  ADD R5, R5, #1 @i1 = i1 + 1;
  ADD R1, R1, #4 @address1 = address 1 + 4;
  B While1 @}

EndWhile1: 
@(we've gone through all values in the string and compared to i1, now we increment i1 and start again)



  @ End of program ... check your result

End_Main:
  BX    lr

