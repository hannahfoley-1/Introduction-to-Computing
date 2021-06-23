  .syntax unified
  .cpu cortex-m4
  .thumb
  .global  Main

Main:

  @ Write an ARM Assembly Language Program that will convert
  @    a sequence of four ASCII characters, each representing a
  @    decimal digit, into tje to the value represented by the
  @    sequence.
  
  @ e.g. '2', '0', '3', '4' (or 0x32, 0x30, 0x33, 0x34) to 2034 (0x7F2)

  @CONVERTING INTO THEIR READ TOGETHER VALUE
  @total=0
  @R1=hexidecimal value - 30 to convert to decimal value
  @total=total=decimal value 
  @repeat for each value

  @name registers [R0=result, R1=first value, R2=seonnd value, R3=third value, R4=fourth value] 
  @test.s says that 
  @  R1, =0x34   @ '4'
  @  R2, =0x33   @ '3'
  @  R3, =0x30   @ '0'
  @  R4, =0x32   @ '2'

  MOV R0, #0       @total=0
  LDR R5, =0x30    @loading register 5 with the hexidecimal value 0x30
  SUB R6, R4, R5   @some temp register = hexidecimal value 1 - 0x30
  ADD R0, R0, R6   @add this value onto the result

  LDR R7, =10      @loading the value of 10 onto the temp register R6
  MUL R0, R0, R7   @total*10
  SUB R6, R3, R5   @some temp register = hexidecimal value 2 - 0x30
  ADD R0, R0, R6   @add this value onto the result

  MUL R0, R0, R7  @total=total*10
  SUB R6, R2, R5  @temp register + hexidecimal value 3 - 0x30
  ADD R0, R0, R6  @adding value onto result

  MUL R0, R0, R7  @total=total*10
  SUB R6, R1, R5  @temp register = hexidecimla value 4 - 0x30
  ADD R0, R0, R6  @adding this value onto resultsb to gte total result  

  @ End of program ... check your result

End_Main:
  BX    lr

.end
