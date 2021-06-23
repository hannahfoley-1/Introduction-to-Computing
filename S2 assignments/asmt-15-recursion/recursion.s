  .syntax unified
  .cpu cortex-m4
  .fpu softvfp
  .thumb
  
  .global   quicksort
  .global   partition
  .global   swap

@ quicksort subroutine
@ Sort an array of words using Hoare's quicksort algorithm
@ https://en.wikipedia.org/wiki/Quicksort 
@
@ Parameters:
@   R0: Array start address
@   R1: lo index of portion of array to sort
@   R2: hi index of portion of array to sort
@
@ Return:
@   none
quicksort:
  PUSH    {R4-R8, LR}                      @ add any registers R4...R12 that you use

  @ *** PSEUDOCODE ***
  @ Moving parameters into new registers
  MOV R4, R0 @ start aaddress
  MOV R5, R1 @ lo index
  MOV R6, R2 @ hi index
 
  CMP R5, R6              @ if (lo < hi) { // !!! You must use signed comparison (e.g. BGE) here !!!
  BGE endQuicksort
  @ prepare parameters to be send into partition subroutine
  MOV R0, R4              @   R0: array start address
  MOV R1, R5              @   R1: lo index of partition to sort
  MOV R2, R6              @   R2: hi index of partition to sort
  BL partition            @   p = partition(array, lo, hi);
 
  @ P IS IN R0
  MOV R7, R0               @ MOVE P INTO NEW REGISTER

  @ prepare parameters to be send into quicksort subroutine
  MOV R0, R4               @   R0: Array start address
  MOV R1, R5               @   R1: lo index of portion of array to sort
  SUB R8, R7, #1           @   R2: hi index of portion of array to sort
  MOV R2, R8 
  BL quicksort             @   quicksort(array, lo, p - 1);

  @ prepare parameters to be send into quicksort subroutine
  MOV R0, R4               @   R0: Array start address
  ADD R8, R7, #1           @   R1: lo index of portion of array to sort
  MOV R1, R8
  MOV R2, R6               @   R2: hi index of portion of array to sort
  BL quicksort             @   quicksort(array, p + 1, hi);
  @ }

endQuicksort:
  POP     {R4-R8, PC}      @ add any registers R4...R12 that you use


@ partition subroutine
@ Partition an array of words into two parts such that all elements before some
@   element in the array that is chosen as a 'pivot' are less than the pivot
@   and all elements after the pivot are greater than the pivot.
@
@ Based on Lomuto's partition scheme (https://en.wikipedia.org/wiki/Quicksort)
@
@ Parameters:
@   R0: array start address
@   R1: lo index of partition to sort
@   R2: hi index of partition to sort
@
@ Return:
@   R0: pivot - the index of the chosen pivot value
partition:
  PUSH    {R4-R10, LR}                      @ add any registers R4...R12 that you use

  @ *** PSEUDOCODE ***
  @ MOVE PARAMETERS INTO NEW REGISTERS
  MOV R4, R0 @ array start address
  MOV R5, R1 @ lo index
  MOV R6, R2 @ hi index

  LDR R7, [R0, R6, LSL #2]   @ pivot = array[hi];
  MOV R8, R5                 @ i = lo;
  MOV R9, R5                 @ for (j = lo; j <= hi; j++) 
For:
  CMP R9, R6
  BGT EndFor                 @ {
  LDR R10, [R0, R9, LSL #2]  @   if (array[j] < pivot) {
  CMP R10, R7
  BGE endIf
  
  @ prepare parameters to send into swap subroutine
  MOV R0, R4                 @   R0: array - start address of an array of words
  MOV R1, R8                 @   R1: a - index of first element to be swapped
  MOV R2, R9                 @   R2: b - index of second element to be swapped
  BL swap                    @     swap (array, i, j);
  ADD R8, R8, #1             @     i = i + 1;
  @   }

endIf:
  ADD R9, R9, #1              @ } //end of for loop remember to inc j
  B For

EndFor:
  @ prepare parameters to send into swap subroutine
  MOV R0, R4                 @   R0: array - start address of an array of words
  MOV R1, R8                 @   R1: a - index of first element to be swapped
  MOV R2, R6                 @   R2: b - index of second element to be swapped
  BL swap                    @ swap(array, i, hi);
  
  MOV R0, R8                 @ return i;


  POP     {R4-R10, PC}                      @ add any registers R4...R12 that you use



@ swap subroutine
@ Swap the elements at two specified indices in an array of words.
@
@ Parameters:
@   R0: array - start address of an array of words
@   R1: a - index of first element to be swapped
@   R2: b - index of second element to be swapped
@
@ Return:
@   none
swap:
  PUSH    {R4-R9, LR}

  @ putting parameters into new registers
  MOV R4, R0 @ start address of array
  MOV R5, R1 @ index 1 a
  MOV R6, R2 @ index 2 b

  LDR R7, [R4, R5, LSL #2]  @ array[a] = element1
  LDR R8, [R4, R6, LSL #2]  @ array[b] = element2
  
  STR R8, [R4, R5, LSL #2]  @ element2 = element[a]
  STR R7, [R4, R6, LSL #2]  @ element1 = element[b]

  POP     {R4-R9, PC}


.end