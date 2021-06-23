  .syntax unified
  .cpu cortex-m4
  .thumb
  .global  Main

Main:

  
  @ binary value is in r1
  @ result in r0
  
  MOV R2, #0          @ highest1Count = 0
  MOV R3, #0          @ current1Count = 0
  MOV R4, #0          @ loopCount = 0

While:   
  CMP R4, #32         @ while (loopCount <= 32)
  BHS EndWhile        @{
  MOVS R1, R1, LSL #1 @ get currentDigit 
  BCC lastDigitWas0   @ if currentDigit != 0 {
  ADD R3, R3, #1      @ current1Count = current1Count + 1
  B IncLoopCount      @}
  @ else // (if currentDigit == 0)
lastDigitWas0:  
  CMP R3, R2         @ if current1Count > highest1Count
  BLO IncLoopCount   @{
  MOV R2, R3         @ highest1Count = current1Count
  MOV R3, #0         @ current1Count = 0 }
IncLoopCount: 
  ADD R4, R4, #1     @ loopCount += 1
  B While            @}

EndWhile:
  CMP R3, R2         @if currentCount > highestCount
  BLO Store          @{
  MOV R2, R3         @ highestCount = currentCount
Store:               @}
  MOV R0, R2         @store result



  @ End of program ... check your result

End_Main:
  BX    lr

.end
