  .syntax unified
  .cpu cortex-m4
  .thumb
  .global  Main

Main:

  @ Write an ARM Assembly Language Program that will convert
  @   a signed value (integer) in R3 into three ASCII characters that
  @   represent the integer as a decimal value in ASCII form, prefixed
  @   by the sign (+/-).
  @ The first character in R0 should represent the sign
  @ The second character in R1 should represent the most significaint digit
  @ The third character in R2 should represent the least significant digit
  @ Store 'N', '/', 'A' if the integer is outside the range -99 ... 0 ... +99

  
  LDR R11, =0x30

CMP R3, #0                  @ if (R3==0)
BNE NotZero                 @{
LDR R0, =0x20              @SIGN = " "
LDR R1, =0x30                 @MSB = 0
LDR R2, =0x30                @LSB = 0
B EndItoA                   @}

NotZero:
CMP R3, #1                  @ if (R3 >= 1 && R3 <= 9)
BLT LessThan0 
CMP R3, #9
BHI GreaterThan9            @{
LDR R0, =0x2B               @ SIGN = +
LDR R1, =0x30               @ MSB = 0
ADD R3, R3, R11             @convert number to ascii code 
MOV R2, R3                  @ LSB = R3
B EndItoA                   @}

LessThan0:
LDR R0, =0x2D               @ SIGN = "-"
RSB R4, R3, #0              @get absolute value of number for result later
LDR R5, =-9 
CMP R3, R5                  @if R3 <= -9
BLT LessThanNeg9            @{
LDR R1, =0x30               @ MSB = 0
ADD R4, R4, R11             @convert number to ascii code
MOV R2, R4                  @ LSB = abs R3
B EndItoA                   @}

LessThanNeg9:
LDR R6, =-100
CMP R3, R6                  @ if R3 >= 10 && R3 < 100)
BLE LessThanNeg100          @{
@ MSB = MODULUS ON DIVISION BY 10
@start using absolute value version
MOV R10, R4 
WhileFor2DigitNo:           @while (absolute value > 10)
CMP R10, #10 
BLO EndWhileFor2DigitNo     @{
SUB R10, R10, #10             @ value = value -10
ADD R7, R7, #1              @ quotient = quotient + 1
B WhileFor2DigitNo          @}
EndWhileFor2DigitNo:
ADD R12, R7, R11             @convert number to ascii code
MOV R1, R12                 @ MSB = Quotient
MOV R8, #10 
MUL R8, R7, R8 
SUB R2, R4, R8              @ LSB = abs R3 - MSB*10
ADD R2, R2, R11             @ convert number to ascii code
B EndItoA                   @} 

LessThanNeg100:
@ If R3 >= -100 
@{
LDR R0, =0x4E              @ SIGN = N
LDR R1, =0x2F              @ MSB = /
LDR R2, =0x41              @ LSB = A
B EndItoA                  @}

GreaterThan9:
LDR R9, =100 
CMP R3, R9 @ if (R3 >= 10 && R3 < 100)
BHS GreaterThan100 @ }
LDR R0, =0x2B @ SIGN = +
@ MSB = MODULUS ON DIVISION BY 10
MOV R10, R3
WhileFor2DigitNo2:           @while (absolute value > 10)
CMP R10, #10 
BLO EndWhileFor2DigitNo2     @{
SUB R10, R10, #10             @ value = value -10
ADD R7, R7, #1               @ quotient = quotient + 1
B WhileFor2DigitNo2          @}
EndWhileFor2DigitNo2:
ADD R12, R7, R11             @convert number to ascii code
MOV R1, R12                  @ MSB = Quotient
MOV R8, #10 
MUL R8, R7, R8 
SUB R2, R3, R8              @ LSB = R3 - MSB*10
ADD R2, R2, R11             @convert number to ascii code
B EndItoA                   @} 

GreaterThan100:
@ if (R3 >= 100)
@}
LDR R0, =0x4E                @SIGN = N
LDR R1, =0x2F                @MSB = /
LDR R2, =0x41                @LSB = A
@}

EndItoA:


  @ End of program ... check your result

End_Main:
  BX    lr

.end
