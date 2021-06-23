  .syntax unified
  .cpu cortex-m4
  .fpu softvfp
  .thumb
  
  .global  get9x9
  .global  set9x9
  .global  average9x9
  .global  blur9x9


@ get9x9 subroutine
@ Retrieve the element at row r, column c of a 9x9 2D array
@   of word-size values stored using row-major ordering.
@
@ Parameters:
@   R0: address - array start address
@   R1: r - row number
@   R2: c - column number
@
@ Return:
@   R0: element at row r, column c
get9x9:
  PUSH {R4-R7, LR}                      @ add any registers R4...R12 that you use
  @ moving parameters into other registers (r4, r5, r6)
  MOV R4, R0   @ address
  MOV R5, R1   @ row number
  MOV R6, R2   @ col number

  MOV R7, #9               @ index = row * 9
  MUL R7, R5, R7          
  ADD R7, R7, R6           @ index += col
  LDR R0, [R4, R7, LSL #2] @ element = word [array + index(element size)]

  POP {R4-R7, PC}                      @ add any registers R4...R12 that you use

@ set9x9 subroutine
@ Set the value of the element at row r, column c of a 9x9
@   2D array of word-size values stored using row-major
@   ordering.
@
@ Parameters:
@   R0: address - array start address
@   R1: r - row number
@   R2: c - column number
@   R3: value - new word-size value for array[r][c]
@
@ Return:
@   none
set9x9:
  PUSH {R4-R8, LR}                      @ add any registers R4...R12 that you use
  
  @ moving parameters into other registers (r4, r5, r6, r7)
  MOV R4, R0   @address
  MOV R5, R1   @ row number
  MOV R6, R2   @col number
  MOV R7, R3   @new value to replace with

  MOV R8, #9                @ index = row * 9
  MUL R8, R8, R5    
  ADD R8, R8, R6            @ index += col
  STR R7, [R4, R8, LSL #2]  @ word [array + index(element size)] = new value

  POP {R4-R8, PC}                      @ add any registers R4...R12 that you use



@ average9x9 subroutine
@ Calculate the average value of the elements up to a distance of
@   n rows and n columns from the element at row r, column c in
@   a 9x9 2D array of word-size values. The average should include
@   the element at row r, column c.
@
@ Parameters:
@   R0: address - array start address
@   R1: r - row number
@   R2: c - column number
@   R3: n - element radius
@
@ Return:
@   R0: average value of elements
average9x9:
  PUSH {R4-R12, LR}                      @ add any registers R4...R12 that you use

  @moving parameters into new registers (r4, r5, r6, r7)
  MOV R4, R0   @ address
  MOV R5, R1   @ row number
  MOV R6, R2   @ col number
  MOV R7, R3   @ radius

  RSB R8, R7, #0  @ for (int i = -n; i <= n; i++)
RowLoop:
  CMP R8, R7
  BGT averageCalc @ {
  
  RSB R9, R7, #0  @ for (int j = -n; j <= n; j++)
colLoop:
  CMP R9, R7
  BGT incRow      @ {

  ADD R10, R5, R8 @ CurrentRow = row + i
  CMP R10, #0     @ if (currentRow >= 0 && currentRow < 9) //making sure row number is valid
  BLT incRow
  CMP R10, #9 
  BGE averageCalc @{

  ADD R11, R6, R9 @ CurrentCol = col + j
  CMP R11, #0     @ if (currentCol >= 0 && currentCol < 9) //making sure col number is valid
  BLT incCol
  CMP R11, #9     
  BGE incRow      @ {

  @ element = [currentRpw][currentCol] //do this by sending to get 9x9 subroutine
  MOV R0, R4
  MOV R1, R10
  MOV R2, R11
  BL get9x9
  ADD R12, R12, R0 @ sum += element
  @ }}
  
incCol:  
  ADD R9, R9, #1    @ } // inc j
  B colLoop

incRow:
  ADD R8, R8, #1   @ } // inc i
  B RowLoop

averageCalc:
  MOV R4, #0
  @calculate minimum index

  SUB R8, R5, R7  @minRow = row - radius
  SUB R9, R6, R7  @minCol = col - radius
  CMP R8, #0      @if (minrow < 0) 
  BGE minCol      @ {
  MOV R8, #0      @ minRow = 0 }
minCol:
  CMP R9, #0      @ if (minCol < 0)
  BGE maxCalc     @ {
  MOV R9, #0      @ minCol = 0 }

maxCalc:
  @calculate maximum index

  ADD R10, R5, R7     @maxRow = row + radius
  ADD R11, R6, R7     @maxCol = col + radius

  @count the elements between minimum and maximum index
  @for (i = minRow; minRow < 9 && minRow <= maxRow; minRow ++)
rowLoopAverage:
  CMP R8, #9
  BGE calculate 
  CMP R8, R10
  BGT calculate       @ {
colLoopAverage:
  @ for (j = minCol; minCol < 9 && minCol <= maxCol; minCol++)
  CMP R9, #9
  BGE incRowAverage
  CMP R9, R11       
  BGT incRowAverage    @ {
  ADD R4, R4, #1       @ count = count + 1
  ADD R9, R9, #1       @ }
  B colLoopAverage
incRowAverage:
  ADD R8, R8, #1       @ }
  SUB R9, R6, R7
  CMP R9, #0           @ if (minCol < 0)
  BGE rowLoopAverage   @ {
  MOV R9, #0           @ minCol = 0 }
  B rowLoopAverage

calculate:
  UDIV R0, R12, R4   @ average = sum/count
  
  POP {R4-R12, PC}    @ add any registers R4...R12 that you use



@ blur9x9 subroutine
@ Create a new 9x9 2D array in memory where each element of the new
@ array is the average value the elements, up to a distance of n
@ rows and n columns, surrounding the corresponding element in an
@ original array, also stored in memory.
@
@ Parameters:
@   R0: addressA - start address of original array
@   R1: addressB - start address of new array
@   R2: n - radius
@
@ Return:
@   none
blur9x9:
  PUSH    {R4-R9, LR}                      @ add any registers R4...R12 that you use

  @ moving parameters into new registers (r4, r5, r6)
  MOV R4, R0   @addressA 
  MOV R5, R1   @addressB
  MOV R6, R2   @ n 

  MOV R7, #0   @for (row = 0; row < 9; row ++)
rowLoopBlur:
  CMP R7, #9   
  BHS endBlur  @ {
  MOV R8, #0   @ for (col = 0; col < 9; col++)
colLoopBlur:
  CMP R8, #9   
  BHS incRowBlur   @ {
  @ average = average9x9(addressA, row, col, n)
  @ prepare parameters to send to average subroutine
  
  MOV R0, R4   @ array start address
  MOV R1, R7   @ row number 
  MOV R2, R8   @ col number 
  MOV R3, R6   @ radius 

  @ call average subroutine
  BL average9x9
  MOV R9, R0   @store result in r9 for a moment

  @ set9x9(addressB, row, col, average)
  @ prepare parameters to send to set subroutine
  MOV R0, R5   @ new array start address
  MOV R1, R7   @ row number
  MOV R2, R8   @ column number
  MOV R3, R9   @ average

  BL set9x9

  ADD R8, R8, #1  @ } // inc col
  B colLoopBlur
incRowBlur:
  ADD R7, R7, #1 @ } // inc row
  B rowLoopBlur

endBlur:
  POP     {R4-R9, PC}                      @ add any registers R4...R12 that you use

.end