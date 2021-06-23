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

  @Stored in R1
  @result in R0
  
  CMP R1, #'a'     @ if (ch=='a' || ch=='e' || ch=='i' || ch=='o' || ch=='u')
  BEQ Vowel 
  CMP R1, #'e'
  BEQ Vowel 
  CMP R1, #'i'
  BEQ Vowel 
  CMP R1, #'o'
  BEQ Vowel
  CMP R1, #'u'
  BEQ Vowel 
  B NotVowel        @ {
Vowel:
  MOV R0, #1        @v=1;
  B EndVowel        @{
NotVowel:           @else {
  MOV R0, #0        @v=0;
EndVowel:         @}

  @ End of program ... check your result

End_Main:
  BX    lr

.end
