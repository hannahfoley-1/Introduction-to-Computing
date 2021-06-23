  .syntax unified
  .cpu cortex-m4
  .fpu softvfp
  .thumb
  .global  Main

Main:
  

  @ STORE SIZE AT BEGINNING
  @ A IN R1
  @ B IN R2
  @ C IN R0 (address stored in r0)
  

  LDR R3, [R1]     @ lengthA = word [addressA]
  LDR R4, [R2]     @ lengthB = word [addressB]
  MOV R5, #0       @ lengthC = 0
  MOV R6, R1       @ addressA = tempRegisterA
  MOV R7, R2       @ addressB = tempRegisterB
  MOV R8, R0       @ addressC = tempRegisterC
  
  CMP R3, #0       @ If (lengthA != 0 && lengthB != 0)
  BEQ AisNull      
  CMP R4, #0        
  BEQ BisNull      @ { 
  @ //compare all elements of A with B (outerLoop goes through A and innerLoop through B)
  ADD R1, R1, #4   @  addressA = addressA + 4
  LDR R9, [R1]     @  elementA = word [addressA]
  MOV R10, #0      @  countA = 0 
OuterALoop:
  CMP R10, R3      @  While (countA < lengthA)
  BHS CompareBtoA  @  {
  ADD R2, R2, #4   @    addressB = addressB + 4 
  LDR R11, [R2]    @    elementB = word [addressB]
  MOV R12, #0      @    countB = 0
InnerLoopB1:
  CMP R12, R4      @    While (countB < lengthB)
  BHS StoreA1  @    {
  CMP R9, R11      @     If (elementA == elementB)
  BNE IncrementB1  @     {
  B IncrementA1    @      Branch to incrementA }

IncrementB1:       @     //incrementB
  ADD R2, R2, #4   @      addressB = addressB + 4
  ADD R12, R12, #1 @      countB = countB + 1
  LDR R11, [R2]    @      elementB = word[addressB]
  B InnerLoopB1    @  }
  @  //now elementA has been compared to all elements in B, 
  @  and hasn’t found a match as it hasn’t branched to the incrementA, 
  @  so the program will store elementA into C
StoreA1:
  ADD R0, R0, #4   @  addressC = addressC + 4
  STR R9, [R0]     @  word[addressC] = elementA
  ADD R5, R5, #1   @  lengthC = lengthC + 1
IncrementA1: @   //incrementA
  ADD R1, R1, #4   @     addressA + addressA + 4
  ADD R10, R10, #1 @ countA = countA + 1
  LDR R9, [R1]     @ elementA = word [addressA]
  MOV R2, R7       @addressB = tempRegisterB
  B OuterALoop     @ }


CompareBtoA:
  @ //now loop through B in the same way
  MOV R1, R6       @ addressA  = tempRegisterA
  MOV R2, R7       @ addressB = tempRegisterB
  MOV R10, #0      @ countA = 0
  MOV R12, #0      @ countB = 0
  ADD R2, R2, #4   @     addressB = addressB + 4 
  LDR R11, [R2]    @     elementB = word [addressB]
OuterBLoop:
  CMP R12, R4      @ While (countB < lengthB)
  BHS StoreCountC  @   {
  ADD R1, R1, #4   @ addressA = addressA + 4 
  LDR R9, [R1]     @ elementA = word [addressA]
  MOV R10, #0      @     countA = 0
InnerLoopA:
  CMP R10, R3      @     While (countA < lengthA)
  BHS StoreB1      @     {
  CMP R11, R9      @       If (elementB == elementA)
  BNE IncrementA2  @       {
  B IncrementB2    @        Branch to incrementB       }
IncrementA2:       @       //incrementA
  ADD R1, R1, #4   @        addressA = addressA + 4
  ADD R10, R10, #1 @        countA = countA + 1
  LDR R9, [R1]     @ elementA = word [addressA]
  B InnerLoopA     @     }
  @//now elementB has been compared to all elements in A , and hasn’t found a match as
  @ it hasn’t branched to the incrementB , so the program will store elementB into C
StoreB1:
  ADD R0, R0, #4   @   addressC = addressC + 4
  STR R11, [R0]    @   word[addressC] = elementB
  ADD R5, R5, #1   @   lengthC = lengthC +1 
IncrementB2:       @ //incrementB
  ADD R2, R2, #4   @   addressB + addressB + 4
  ADD R12, R12, #1 @ countB  = countB  + 1
  LDR R11, [R2]    @ elementB = word [addressB]
  MOV R1, R6       @ addressA = tempRegisterA
  B OuterBLoop     @ }
  
StoreCountC:       @ //store count
  MOV R0, R8       @ addressC = tempRegisterC
  STR R5, [R0]     @ Word [addressC] = lengthC  
  B EndSymDiff     @ }
  

AisNull:
  @ Else if (lengthA == 0) //symmetricDifference = B so Transfer all elements of B into C
  @ {
  MOV R9, #0       @   For (int = 0 ; int < lengthB ; int ++)
StoreBintoC:
  CMP R9, R4  
  BHS StoreCountCB @   {
  ADD R0, R0, #4   @   addressC = addressC + 4
  ADD R2, R2, #4   @   addressB = addressB + 4
  LDR R10, [R2]    @   elementB = word [addressB]
  STR R10, [R0]    @   Word [addressC] = elementB
  ADD R9, R9, #1   
  B StoreBintoC    @   }
StoreCountCB:       @ //store count of C into C, count of c will just be length B 
  MOV R0, R8       @   addressC = tempRegisterC
  STR R4, [R0]     @   Word [addressC] = lengthB
  B EndSymDiff     @ }
  


BisNull:
  @ Else if (lengthB == 0) //symmetricDifference = A, so transfer all elements of A into C
  @ {
  MOV R9, #0       @   For (int = 0 ; int < lengthA ; int ++)
StoreAintoC:       
  CMP R9, R3       
  BHS StoreCountCA @   {
  ADD R0, R0, #4   @   addressC = addressC + 4
  ADD R1, R1, #4   @   addressA = addressA + 4
  LDR R10, [R1]    @   elementA = word [addressA]
  STR R10, [R0]    @   Word [addressC] = elementA
  ADD R9, R9, #1 
  B StoreAintoC    @   }
StoreCountCA:       @ //store count of C into C, count of c will just be length A 
  MOV R0, R8       @addressC = tempRegisterC
  STR R3, [R0]     @   Word [addressC] = lengthA
  B EndSymDiff     @ }
 
EndSymDiff:

  @
  @ REMEMBER: Sets are stored in memory in the format ...
  @
  @   size, element1, element2, element3, etc.
  @
  @ where size is the number of elements in the set, element1 is
  @   the first element, element2 is the second element, etc.
  @ 


  @
  @ Debugging tips:
  @
  @ If using the View Memory window
  @   - view set A using address "&setA" and size 64
  @   - view set B using address "&setB" and size 64
  @   - view set C using address "&setC" and size 64
  @
  @ If using a Watch Expression
  @   view set A using expression "(int[16])setA"
  @   view set B using expression "(int[16])setB"
  @   view set C using expression "(int[16])setC"
  @
  @ BUT REMEMBER, the first value you see should be the size, 
  @  the second value will be the first element, etc. (see above!)

  @ End of program ... check your result

End_Main:
  BX    lr

