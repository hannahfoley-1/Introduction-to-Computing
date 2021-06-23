  .syntax unified
  .cpu cortex-m4
  .fpu softvfp
  .thumb
  .global  Main

Main:

  MOV R2, R1         @store beginning address in a register to easily access

  @IT IS READ ONLY MEMORY, YOU CANNOT CHANGE 
  @count elements (null terminated string)

  MOV R4, #0         @ count = 0
CountLoop:
  LDRB R3, [R1]      @ ch = byte [address1]
  CMP R3, #0         @ while (ch != 0)
  BEQ EndCount       @{
  ADD R4, R4, #1     @ count = count + 4
  ADD R1, R1, #1     @ address1 = address1 + 1
  B CountLoop        @}

  @set one address to last element
EndCount:
  MOV R1, R2         @ set address1 back to first character
  ADD R5, R1, R4     @ address2 = address1 + count - 1
  SUB R5, R5, #1     

  LDRB R8, =2
  UDIV R4, R4, R8    @ halfLength = length / 2 
  
  @compare beginning address with end address 
  MOV R6, #0        @ count -0 
isPalindromeLoop:  
  CMP R6, R4        @ while count != half length
  BEQ IsPalindrome  @{
  LDRB R3, [R1]     @ ch1 = byte [address1]
  LDRB R7, [R5]     @ ch2 = byte [address2]    
  CMP R3, #'A'      @ if (ch1 < 'A' || ch1 > 'Z')
  BLO Inc1
  CMP R3, #'Z'
  BLS Convert1ToLwr @if character is a capital letter, convert to lower case 
  CMP R3, #'a'      @if (ch1 >= 'a' && ch1 <= 'z') 
  BLO Inc1
  CMP R3, #'z'
  BHI Inc1          @if ch 1 not in range, inc that
  B CompareCh2      @{
Convert1ToLwr:
  ADD R3, R3, #0x20    @ ch = ch + 0x20
CompareCh2:
  CMP R7, #'A'        @ if (ch2 <'A' || ch2 > 'Z')
  BLO Dec2
  CMP R7, #'Z'
  BLS Convert2ToLwr   @ if not a capital letter, cnvert to lower
  CMP R7, #'a'
  BLO Dec2
  CMP R7, #'z'        @if ch2 not in range dec that
  BHI Dec2
  B CompareChs        @{
Convert2ToLwr:
  ADD R7, R7, #0x20   @ Ch2 = 2 - 1 }
CompareChs:
  CMP R3, R7          @ if (ch1 != ch2)
  BEQ IncAndDec       @{
  MOV R0, #0          @ result = 0, not palindrome,
  B EndPalindrome     @ break }

IncAndDec:
  ADD R6, R6, #1      @count = count + 1
Inc1:
  ADD R1, R1, #1      @ address1 = address1 + 1
  CMP R3, #'a'        @ if it was incrementing because it was not a letter then it should skip over dec2
  BLO isPalindromeLoop
  CMP R3, #'z'
  BHI isPalindromeLoop@ if (ch1 >= 'a' && ch1 <= 'z' )
Dec2:
  SUB R5, R5, #1      @ address2 = address2 - 1
  B isPalindromeLoop  @}

IsPalindrome:
  MOV R0, #1          @ result = 1, is a palindrome 

EndPalindrome: 



  @ End of program ... check your result

End_Main:
  BX    lr

