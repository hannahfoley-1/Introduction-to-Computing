  .syntax unified
  .cpu cortex-m4
  .fpu softvfp
  .thumb
  .global  Main

Main:
  
MOV R3, #0       @ upperCase boolean = false
  LDRB R4, [R1]    @ ch = byte [address]

WhileCamelCase:  
  CMP R4, #0       @ while (ch != 0)
  BEQ EndCamelCase @ {
  
  @ //IF CHARACTER IS UPPERCASE
  CMP R4, #'A'       @   if (ch >= 'A' || ch <= 'Z')
  BLO isSpace       
  CMP R4, #'Z'  
  BHI isLwrCase      @   {
  CMP R3, #1         @     if (boolean = true)
  BNE ChangetoLwr    @     {
  STRB R4, [R0]      @       byte [ResultAddress] = ch 
  MOV R3, #0         @       boolean = false
  B IncrementResult  @      }
ChangetoLwr:         @    else  { //boolean == 0
  ADD R4, R4, #0x20  @    ch = ch + 0x20
  STRB R4, [R0]      @    byte [ResultAddress] = ch 
  B IncrementResult  @     }    }

isLwrCase: @ //IF CHARACTER IS LOWER CASE:
  CMP R4, #'a'       @   if (ch >='a' || ch <= 'z')
  BLO IncrementOriginal
  CMP R4, #'z'
  BHI IncrementOriginal @   {
  CMP R3, #1         @      if (boolean = true)
  BNE RemainLwr      @      {
  SUB R4, R4, #0x20  @        ch = ch - 0x20
  STRB R4, [R0]      @        byte [ResultAddress] = ch 
  MOV R3, #0         @         boolean = false
  B IncrementResult  @      }
RemainLwr:           @      else  { (remains as lowercase as boolean is false)
  STRB R4, [R0]      @      byte [ResultAddress] = ch 
  B IncrementResult  @       }     }
   
isSpace: @ //IF CHARACTER IS A SPACE:
  CMP R4, #0x20      @ else if (ch == ' ')
  BNE IncrementOriginal @  {
  MOV R3, #1         @  boolean = true   } 
  B IncrementOriginal 

IncrementResult:
  ADD R0, R0, #1     @ resultAdress += 1
IncrementOriginal:   @ //INCREMENT
  ADD R1, R1, #1     @ address = address + 1
  LDRB R4, [R1]      @ ch = byte[address]
  B WhileCamelCase   @ }

EndCamelCase:


  @
  @ Debugging tips:
  @
  @ If using the View Memory window
  @   - view originalString using address "&originalString" and size 32
  @   - view newString using address "&newString" and size 32
  @
  @ If using a Watch Expression (array with ASCII character codes)
  @   view originalString using expression "(char[32])originalString"
  @   view newString using expression "(char[32])newString"
  @
  @ If using a Watch Expression (just see the string)
  @   view originalString using expression "(char*)&originalString"
  @   view newString using expression "(char*)&newString"
  @


  @ End of program ... check your result

End_Main:
  BX    lr

