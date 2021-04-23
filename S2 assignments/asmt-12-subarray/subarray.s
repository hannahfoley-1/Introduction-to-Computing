  .syntax unified
  .cpu cortex-m4
  .fpu softvfp
  .thumb
  .global  Main

Main:

  @ R0 = A
  @ R1 = A SIZE
  @ R2 = B
  @ R3 = B SIZE
  @ R0 = RESULT

  @IF SIZE OF A OR B IS 0, RESULT = 0
  CMP R1, #0         @ if (sizeA == 0 || sizeB == 0) {
  BEQ Result0
  CMP R3, #0 
  BHI BgtA           @  result = 0 }

BgtA:
  @IF SIZE OF B IS BIGGER THAN A, THEN RESULT = 0
  CMP R1, R3         @ if (sizeA < sizeB) {
  BLO Result0        @  result = 0;  }

  @ else {
  @CALCULATE LIMIT
  SUB R5, R1, R3    @ aLim = sizeA - sizeB
  MOV R6, #0        @ boolean = false
  MOV R7, #0        @ for (rowA = 0; rowA <= aLim && boolean = false; rowA++)
RowALoop:
  CMP R6, #0
  BNE Results 
  CMP R7, R5
  BHI Results       @ {
  MOV R8, #0        @ for (colA = 0; colA <= aLim && boolean = false; colA++)
ColALoop:
  CMP R6, #0        
  BNE IncRowA       @ {
  CMP R8, R5
  BHI IncRowA
  MOV R6, #1        @ boolean = true;
  MOV R9, #0        @ for (rowB = 0; rowB <=sizeB && boolean = true; rowB++)
RowBLoop:
  CMP R9, R3
  BHS IncColA
  CMP R6, #1
  BNE IncColA       @ {
  MOV R10, #0       @ for (colB = 0; colB <= sizeB && boolean = true; colB++)
ColBLoop:
  CMP R10, R3
  BHS IncRowB
  CMP R6, #1
  BNE IncRowB       @ {
  PUSH {R5}     @ PUSH (R5)
  MOV R5, #0
  ADD R5, R7, R9    @ indexA = (rowA+rowB)*sizeA
  MUL R5, R5, R1
  ADD R5, R5, R8    
  ADD R5, R5, R10   @ indexA += colA + colB
  LDR R11, [R0, R5, LSL #2] @ elementA = A[rowA+rowB][colA+colB]
  MOV R5, #0 
  MUL R5, R9, R3            @ indexB = (rowB)*sizeB
  ADD R5, R5, R10           @ indexB += colB
  LDR R12, [R2, R5, LSL #2] @ elementB = B[rowB][colB]
  POP {R5}                  @ POP (R5)
  CMP R11, R12              @ if (elementA != elementB)
  BEQ IncColB               @ {
  MOV R6, #0                @ boolean = false; } 
IncColB:
  ADD R10, R10, #1            @ } // end for col B remember to inc colB
  B ColBLoop 
IncRowB:
  ADD R9, R9, #1               @ } // end of row b for loop, remember to inc row b
  B RowBLoop
IncColA:
  ADD R8, R8, #1               @ } // end of colA for loop remember to inc col a
  B ColALoop
IncRowA:
  ADD R7, R7, #1               @ } // end of rowA for loop remember to inc row a
  B RowALoop

Results:
  CMP R6, #1     @if boolean = 1 {
  BNE Result0
Result1:
  MOV R0, #1       @result = 1 
  B EndSubArray    @ }

@ else {
Result0:
  MOV R0, #0       @ result = 0}

EndSubArray:
  



  @ End of program ... check your result

End_Main:
  BX    lr

