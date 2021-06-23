  .syntax unified
  .cpu cortex-m4
  .fpu softvfp
  .thumb
  .global  Main

Main:
 MOV R3, R0      @as to not destroy original address at c   

  @first add one to address in c for storage so we can go back and put firdt element as length
  ADD R0, R0, #4  @addressc = addressc + 4

  @extract lengths of a and b 
  LDR R4, [R1]     @ lengthA = word [addressA]
  ADD R1, R1, #4   @addressA = addressA + 4
  LDR R5, [R2]     @ lengthB = word [addressB]
  ADD R2, R2, #4   @addressB = addressB + 4 
  
  CMP R4, #0 
  BEQ MoveBintoC  @if A is null, move past this section 

  @add every element of A into C to 
  MOV R6, #0       @countA = 0;
MoveAintoC:  
  CMP R6, R4       @while countA < lengtA
  BHS CompareCandB @{
  LDR R7, [R1]     @ elementA = word [addressA]
  STR R7, [R0]     @ word [addressC] = elementA
  ADD R0, R0, #4   @ addressC = addressC + 4
  ADD R1, R1, #4   @ addressA = addressA + 4
  ADD R6, R6, #1 
  B MoveAintoC     @ } 

MoveBintoC:
  MOV R6, #0       @countB = 0;
MoveBintoC1:  
  CMP R6, R5       @while countB < lengtB
  BHS StoreCountSpecialCase @{
  LDR R7, [R2]     @ elementB = word [addressB]
  STR R7, [R0]     @ word [addressC] = elementB
  ADD R0, R0, #4   @ addressC = addressC + 4
  ADD R2, R2, #4   @ addressB = addressB + 4
  ADD R6, R6, #1 
  B MoveBintoC1     @ } 


CompareCandB:
  MOV R12, R0      @ store current address in C as this is where we will begin storage for B elements
  MOV R0, R3       @bring c address back to start address
  ADD R0, R0, #4   
  MOV R6, #0       @ countB = 0
StoreBintoC:  
  CMP R6, R5       @ while countB < lengthB
  BHS StoreCount       @}
  LDR R7, [R2]     @ elementB = word [addressB]  
  MOV R8, #0       @ countC = 0
  MOV R9, R4       @ lengthC = lengthA
InnerLoop:  
  CMP R8, R9       @ while countC < length C
  BHS StoreintoC2  @{
  LDR R10, [R0]    @ elementC = word [addressC]
  CMP R7, R10      @ if (elementB != elementC)
  BEQ IncrementB   @ {

IncrementC: 
  ADD R0, R0, #4   @ addressC = addressC + 4
  ADD R8, R8, #1   @ countC = countC + 1
  B InnerLoop 
StoreintoC2:  
  @MOV R11, R0      @ store current address of C for a minute
  MOV R0, R12      @ change our c address to the one where elements are being stored
  STR R7, [R0]     @ word [addressC] = elementB
  ADD R9, R9, #1   @ countc = countc + 1
  ADD R0, R0, #4   @ addressC = addressC + 4
  MOV R12, R0      @ store back into temp register 
  MOV R0, R3       @ mov STARTING comparing address back into C
  ADD R0, R0, #4   @ addressC = addressC + 4
  
IncrementB:
  ADD R2, R2, #4   @ addressB = addressB + 4
  ADD R6, R6, #1   @ countB = countB + 1
  B StoreBintoC


StoreCount:
  MOV R0, R3
  SUB R12, R12, R0
  LSR R12, #2
  SUB R12, R12, #1 
  STR R12, [R0]    @ lengthC = word [addressC]
  B End

StoreCountSpecialCase:
  MOV R0, R3
  STR R5, [R0]     @ store length of B 

End:

  

  @ End of program ... check your result

End_Main:
  BX    lr

