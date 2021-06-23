  .syntax unified
  .cpu cortex-m4
  .fpu softvfp
  .thumb
  
  .global   fp_exp
  .global   fp_frac
  .global   fp_enc



@ fp_exp subroutine
@ Obtain the exponent of an IEEE-754 (single precision) number as a signed
@   integer (2's complement)
@
@ Parameters:
@   R0: IEEE-754 number
@
@ Return:
@   R0: exponent (signed integer using 2's complement)
fp_exp:
  PUSH    {R1, LR}                      @ add any registers R4...R12 that you use

  @PUTTING PARAMETERS INTO NEW REGISTERS
  MOV R1, R0

  @1. isolate 8 exponent bits (23-30 inclusive)
  LSL R1, #1  @ shifting out sign bit LSL #1
  LSR R1, #24 @ shifting out fraction LSR #24, now the exponent is at the rhs 

  @2. sub result from 127, ie e-127
  SUB R0, R1, #127

  POP     {R1, PC}                      @ add any registers R4...R12 that you use



@ fp_frac subroutine
@ Obtain the fraction of an IEEE-754 (single precision) number.
@
@ The returned fraction will include the 'hidden' bit to the left
@   of the radix point (at bit 23). The radix point should be considered to be
@   between bits 22 and 23.
@
@ The returned fraction will be in 2's complement form, reflecting the sign
@   (sign bit) of the original IEEE-754 number.
@
@ Parameters:
@   R0: IEEE-754 number
@
@ Return:
@   R0: fraction (signed fraction, including the 'hidden' bit, in 2's
@         complement form)
fp_frac:
  PUSH    {R1-R4, LR}                      @ add any registers R4...R12 that you use

  @ move parmeter into new register
  MOV R1, R0

  @ find the sign (msb = 1 = negative)
  MOVS R2, R1, LSL #1        @ carry = lsl by 1
  BCC .LclearSignAndExponent @ if (carry set) {
  MOV R3, #1                 @   negative = true; }

.LclearSignAndExponent:
  @ use a mask to clear the sign bit and exponent bit, this will have just the fraction left
  LDR R4, =0xff800000     @ mask = 0xff800000 (1s in the positions I want to clear)
  BIC R1, R1, R4          @ Clear to only have fraction left 

  @ set the hidden bit to be 1, ie normalise the number
  LDR R4, =0x00800000     @ mask = 0x00400000 (1s in the position I want to set)
  ORR R1, R1, R4          @ set the bit

  @ if the sign bit was 1, then negate the fraction before returning it
  CMP R3, #1              @ if (negative)
  BNE .LendFrac           @ {
  NEG R1, R1              @  fraction = 0 - fraction
  @ }

.LendFrac:
  MOV R0, R1

  POP     {R1-R4, PC}                      @ add any registers R4...R12 that you use



@ fp_enc subroutine
@ Encode an IEEE-754 (single precision) floating point number given the
@   fraction (in 2's complement form) and the exponent (also in 2's
@   complement form).
@
@ Fractions that are not normalised will be normalised by the subroutine,
@   with a corresponding adjustment made to the exponent.
@
@ Parameters:
@   R0: fraction (in 2's complement form)
@   R1: exponent (in 2's complement form)
@
@ Return:
@   R0: IEEE-754 single precision floating point number
fp_enc:
  PUSH    {R1-R5, LR}                      @ add any registers R4...R12 that you use
  
  MOV R2, R0    @parameters into new registers
  MOV R3, R1

  @ 1. check if the fraction is negative, if so set sign bit
  MOV R4, #0        @ sign = 0
  CMP R0, #0        @ if (fraction < 1)
  BGE checkNormal   @ {
  MOV R4, #1        @     set sign bit to 1
  LSL R4, #31       @     logical left shift the sign bit by 31
  NEG R2, R2        @     negate the fraction } 

checkNormal:
  @ 2. check if the fraction is normalised by counting leading zeros, normalise if not
  CLZ R5, R2        @ n = count leading zeros
  CMP R5, #8        @ if (n < 8)
  BGT toNormal      @ {
  BEQ alreadyNormal
  RSB R5, R5, #8    @   n = 8 - n
  LSR R2, R5        @   logical shift fraction right by n
  ADD R3, R3, R5    @   exponent += n
  B alreadyNormal   @ }
toNormal:           @ else if (n > 8) {
  SUB R5, R5, #8    @   n = n - 8
  LSL R2, R5        @   logical shift fraction left by n
  SUB R3, R3, R5    @   exponent = exponent - n }

alreadyNormal:
  @ 3. Hide the hidden bit (at position 24)
  @ using a mask, set that to 0
  MOV R5, #0
  LDR R5, =0xff7fffff @ mask = ff7fffff (0 in the psoition we want to clear)
  AND R2, R2, R5      @ clear

  @ 4. add 127 tp the exponent
  ADD R3, R3, #127  @ exponent += 127

  @ 5. shift the exponent out by 23 bits
  LSL R3, #23      @ lsl by 23 bits

  @ 5. Merge sign bit, exponent bit and fraction bit
  ADD R0, R4, R3   @ sign and exponent
  ADD R0, R0, R2   @ + fraction

  @return result 

  POP     {R1-R5, PC}                      @ add any registers R4...R12 that you use



.end