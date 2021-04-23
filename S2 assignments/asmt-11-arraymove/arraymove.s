  .syntax unified
  .cpu cortex-m4
  .fpu softvfp
  .thumb
  .global  Main

Main:

 @ R0 = START ADDRESS OF THE ARRAY
  @ R1 = OLD ELEMENT INDEX
  @ R2 = NEW ELEMENT INDEX
  @1. ACCESS OLD ELEMENT INDEX AND LOAD THAT VALUE
  @2. FIND OUT THE DIFFERENCE BETWEEN THE OLD INDEX AND THE NEW INDEX
  @ WILL IT ONLY EVER MOVE BACKWARD?
  @ 3. MOVE ELEMENTS 1 FORWARD/ 1 BACK USING A FOR LOOP FOR THE AMOUNT 
  @ 4. ONCE ALL HAVE BEEN MOVED THERE SHOULD BE AN EMPTY SPACE IN THE NEW ELEMENT LOCATION
  @ 5. STORE IN NEW LOCATION
  @
  
  
  LDR R3, [R0, R1, LSL #2]        @ element = word [base address + (offset*4)]

  CMP R2, R1                      @ if (new index > old index)
  BLS MoveBack                    @{
  SUB R4, R2, R1                  @  spaceBetween = new index - old index
  MOV R5, #1                      @ for (i = 1; i <= spaceBetween; i++)
ForwardLoop:
  CMP R5, R4 
  BHI StoreElement                @ {
  ADD R7, R1, R5                  @ old index + i
  LDR R6, [R0, R7, LSL #2]        @ element2 = array[old index + i]
  SUB R8, R5, #1                  @ new storage = old index + (i-1)
  ADD R8, R8, R1
  STR R6, [R0, R8, LSL #2]        @ array[old index] = element2;
  ADD R5, R5, #1                 
  B ForwardLoop                   @ }
  

MoveBack:
  CMP R2, R1
  BEQ EndArrayMove                 @ else if (new index < old index) {
  SUB R4, R1, R2                   @ spaceBetween = old index - new index
  MOV R5, #1                       @ for (i = 1; i <= spaceBetween; i++)
BackwardLoop:
  CMP R5, R4          
  BHI StoreElement                 @  {
  SUB R7, R1, R5                   @ old index - i
  LDR R6, [R0, R7, LSL #2]         @    element2 = array[old index-i]
  SUB R8, R5, #1                   @ new storage = old index - (i - 1)
  SUB R8, R1, R8
  STR R6, [R0, R8, LSL #2]         @    array[old index] = element 2
  ADD R5, R5, #1                   @  }
  B BackwardLoop

StoreElement:
  STR R3, [R0, R2, LSL #2]         @ array[new index] = element 

EndArrayMove:


  @ End of program ... check your result

End_Main:
  BX    lr

