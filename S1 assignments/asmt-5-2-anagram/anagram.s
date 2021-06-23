  .syntax unified
  .cpu cortex-m4
  .fpu softvfp
  .thumb
  .global  Main

Main:

  @my plan : change both strings completely to lower case
  @ compare like in stcmp

  @Change both to lower case completely
  
  MOV R4, R1
  MOV R5, R2      @As to not destrot original starting addresses
  @first change r1
Lwr1:  
  LDRB R3, [R4]    @ ch = byte [address1]
  CMP R3, #0       @ while (character != 0)
  BEQ Lwr2         @{ 
  CMP R3, #'A'     @if (ch >= 'A' && ch <= 'Z')
  BLO EndLwr1
  CMP R3, #'Z'
  BHI EndLwr1      @{
  ADD R3, R3, 0x20 @ch = ch + 0x20
  STRB R3, [R4]    @ byte [address1] = ch
EndLwr1:           @}
  ADD R4, R4, #1   @address1 = address1 + 1
  B Lwr1          
  
  @again but for r2
Lwr2:  
  LDRB R3, [R5]    @ ch = byte [address2]
  CMP R3, #0       @ while (character != 0)
  BEQ FindLength1  @{ 
  CMP R3, #'A'     @if (ch >= 'A' && ch <= 'Z')
  BLO EndLwr2   
  CMP R3, #'Z'     
  BHI EndLwr2      @{
  ADD R3, R3, 0x20 @ch = ch + 0x20
  STRB R3, [R5]    @ byte [address2] = ch
EndLwr2:  @}
  ADD R5, R5, #1   @address2 = address2 + 1
  B Lwr2

  @ find the length pf the two strings using stlength
FindLength1:
  MOV R4, R1
  MOV R5, R2       @back to beginning addresses
  MOV R7, #0       @count1 = 0
FindLength1Loop:  
  LDRB R6, [R4]    @ch = byte [address1]
  CMP R6, #0       @while string value != 0
  BEQ FindLength2  @{
  ADD R7, R7, #1   @count += 1
  ADD R4, R4, #1   @address1 += 1
  B FindLength1Loop @}

@again for r2
FindLength2:
  MOV R8, #0        @count2 = 0
FindLength2Loop:
  LDRB R6, [R5]     @ ch = byte [address2]
  CMP R6, #0        @while string value != 0
  BEQ CompareIntitialisation     @{
  ADD R8, R8, #1    @count += 1
  ADD R5, R5, #1    @address2 += 1
  B FindLength2Loop    @}

  @now compare two strings @count of R1 in R7, count of R2 in R8 
CompareIntitialisation:  
  @if their lengths were different then they cannot be anagrams
  MOV R0, #0
  CMP R7, R8
  BNE EndAnagram 
  MOV R11, #0        @count11 = 0;
  MOV R4, R1
  LDR R3, =0x2D       @ IF THERES A LETTER IN R1 THAT ISNT IN R2 AT ALL THEN RESULT WILL BE 0
  
  @MY  IDEA IS TO COMPARE THE LETTER IN R1 WITH EVERY LETTER IN R2
  @ AS SOON AS A MATCH IS FOUND, SET THAT DIGIT TO '-' AND DO A BOOLEAN REGISTER TO SAY 'TRUE', WE CAN MOVE ONTO INCREMENT R1 AND START AGAIN
  @AT THE END WE COMPARE STRING R2 WITH - AND IF ANY OF THE ELEMENTS AREN'T EQUAL TO DASH, THE RESULT IS 0, OTHERWISE, THE WORDS ARE ANAGRAMS AND THE RESULT IS 1
CompareLoop:
  CMP R11, R7        @while count11 <= count1
  BHS EndCompare     @{
  LDRB R6, [R4]      @ ch1 = word [address1]
  MOV R12, #0        @ count22 = 0
  MOV R5, R2         @move back to start addressin R2 

Compare2:
  CMP R12, R8        @ while (count22 <= count2)
  BHI Increment1     @{
  LDRB R9, [R5]      @ ch2 = word [addressB] 
  CMP R6, R9         @ if ch1 == ch2 
  BNE Increment2     @{ 
  STRB R3, [R5]      @ byte [address2] = '-' ,  go to increments 
  B Increment1       @jump to increment1  
Increment2:  
  ADD R12, R12, #1   @ count2 = count2 + 1 
  ADD R5, R5, #1     @ address2 = address2 + 4
  B Compare2 @} AFTER GOING THROUGH ALL ELEMENTS IN R2, INCREMENT R1 AND START AGAIN
Increment1:
  ADD R11, R11, #1   @ count11 = count11 + 1
  ADD R4, R4, #1     @ address1 = address1 + 4
  B CompareLoop      @}
  
EndCompare:

  @This will be a loop to check if all of r2 is dashes and if so, the two words are anagrams of eachother
  MOV R12, #0          @ count22 = 0
  MOV R5, R2           @ move back to first address in r2
CompareDash:  
  CMP R12, R8          @ while (count22 < count2)
  BHS EndAnagram       @{
  LDRB R9, [R5]        @ ch = byte [address2]
  CMP R9, #0           @if (ch=0)
  BEQ EndAnagram       @{end}
  CMP R9, R3           @ if (ch != '-')
  BEQ Result1          @{
  MOV R0, #0           @ result = 0
  B EndAnagram         @ break   @} else
Result1:               @{
  MOV R0, #1           @ result = 1 }
  ADD R12, R12, #1     @ count22 ++
  ADD R5, R5, #4       @ address2 = address2 + 4
  B CompareDash        @}

EndAnagram:



  @ End of program ... check your result

End_Main:
  BX    lr

