  .syntax unified
  .cpu cortex-m4
  .fpu softvfp
  .thumb
  .global  Main

Main:
  
  MOV R2, #0                    @ch = 0; 
  LDRB R2, [R1]                 @ch = word[address]
  MOV R10, #1                   @boolean register initially set to true (1) because we want first letter to be upper case

While: 
  CMP R2, #0                    @while (ch != 0)
  BEQ EndProperCase             @{
 
  @ if character is upper case 
  CMP R2, #'A'                  @ if (ch >= 'A' && ch <= 'Z')
  BLO NotALetter                
  CMP R2, #'Z'
  BHI LowerCase
  CMP R10, #1                   @ if boolean register r10 = 1
  BNE ChangeToLowerCase         @{ leave as upper case and store }
  STRB R2, [R1] 
  MOV R10, #0                   @change boolean register r10 = 0 (the next character should not be butter case)
  B UpdateAddress
  @ else {
  @ ie when boolean register r10 = 0 (the next character should not be upper case) 
ChangeToLowerCase: 
  ADD R2, R2, #0x20             @ ch = ch + 0x20
  STRB R2, [R1]                 @ store
  MOV R10, #0                   @ boolean register = false (0)
  B UpdateAddress               @}
 
  @ if character is lower case 
LowerCase:
  CMP R2, #'a'                  @ if (ch >= 'a' && ch <= 'z')
  BLO NotALetter
  CMP R2, #'z'
  BHI NotALetter
  CMP R10, #0                   @ if boolean register r10 = false (0)
  BNE ChangeToUpperCase         @{
  STRB R2, [R1]                 @ leave as lower case and store, boolean will stay at false for now
  B UpdateAddress               @}
ChangeToUpperCase:
  @ ie. if boolean register r10 = true (1)
  SUB R2, R2, #0x20             @ change to upper case BY ch = ch - 0x20
  STRB R2, [R1]                 @ store
  MOV R10, #0                   @ boolean register r10 = false 
  B UpdateAddress               @}
  
  @ if the ch is not a letter 
NotALetter: 
  STRB R2, [R1]                 @ leave as is and store
  MOV R10, #1                   @ next letter should be upper case SO set boolean register r10 to 1 (true)
                               
UpdateAddress:
  ADD R1, R1, #1                @ address = address + 1 (move onto next value in original string) 
  LDRB R2, [R1]                 @ ch = word[address]
  B While                       @ loop back to top

EndProperCase:

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

