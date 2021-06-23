  .syntax unified
  .cpu cortex-m4
  .thumb
  .global  Main

Main:

  @ Calculate n!, where n is stored in R1
  @ Store the result in R0

  MOV R0, #1 @result=1
  MOV R2, R1 @temp=n
 
  WhileMul: 
  CMP R2, #1     @while temp>1
  BLS EndWhile   @{
  MUL R0, R0, R2 @  result=result*n
  SUB R2, R2, #1 @  temp=temp-1
  B WhileMul     @} branch back to top
 
  EndWhile: @when temp<1

  @ End of program ... check your result

End_Main:
  BX    lr

.end
