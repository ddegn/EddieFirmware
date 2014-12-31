Con

  CLK_FREQ = 80_000_000

  MOTOR_L_B     = 19
  MOTOR_L_PWM   = 20
  MOTOR_L_A     = 21
  MOTOR_R_B     = 22
  MOTOR_R_PWM   = 23
  MOTOR_R_A     = 24

  FORWARD       = %100
  REVERSE       = %001

  FREQUENCY     = 10_000
  MIN_OFF_TIME  = CLK_FREQ * 6 / 1_000_000              ' 6 microseconds
  MAX_ON_TIME   = CLK_FREQ / FREQUENCY - MIN_OFF_TIME

  ' At 80 MHz, MAX_ON_TIME is 7520


Var

  byte  Id


Dat

Power
RightPower    word      0
LeftPower     word      0


Pub Start

  if !result := Id := cognew(@Entry, @Power)
    dira := constant(|< MOTOR_L_A | |< MOTOR_L_B | |< MOTOR_R_A | |< MOTOR_R_B)
  

Pub Stop

  cogstop(Id)


Pub Left(Value)

  LeftPower~                                            ' Clear left motor power value

  if Value > 0
    outa[MOTOR_L_A..MOTOR_L_B] := FORWARD
  else
    outa[MOTOR_L_A..MOTOR_L_B] := REVERSE
  LeftPower := ||Value
                                                            
  return Value


Pub Right(Value)

  RightPower~

  if Value > 0
    outa[MOTOR_R_A..MOTOR_R_B] := FORWARD
  else                          
    outa[MOTOR_R_A..MOTOR_R_B] := REVERSE
  RightPower := ||Value                             

  return Value


Pub Halt

  Power~


Dat
              org
Entry
              mov       dira, OutputMask        ' set outputs
              mov       ctra, CTRA_Setting
              mov       ctrb, CTRB_Setting
              mov       frqa, #1                ' frq is added to phs every clock cycle
              mov       frqb, #1                ' so it takes -phs clockcycles to generate a falling edge

              mov       NextCnt, cnt            ' initialize NextCnt
              add       NextCnt, Period
Loop
              mov       Address, par            ' read motor power levels
              rdword    MotorRPower, Address                                                  
              add       Address, #2
              rdword    MotorLPower, Address

              max       MotorLPower, MaxOnTime  ' limit their max
              max       MotorRPower, MaxOnTime  ' to ensure H-bridges' minimum off time

              waitcnt   NextCnt, Period         ' 
              neg       phsa, MotorLPower
              neg       phsb, MotorRPower
              jmp       #Loop

Period        long      CLK_FREQ / FREQUENCY
MaxOnTime     long      MAX_ON_TIME
OutputMask    long      |< MOTOR_L_A | |< MOTOR_L_PWM | |< MOTOR_L_B | |< MOTOR_R_A | |< MOTOR_R_PWM | |< MOTOR_R_B
CTRA_Setting  long      %00100 << 26 | MOTOR_L_PWM
CTRB_Setting  long      %00100 << 26 | MOTOR_R_PWM
Half          long      MAX_ON_TIME / 2
Quarter       long      MAX_ON_TIME / 4


MotorLPower   res       1
MotorRPower   res       1
NextCnt       res       1
Address       res       1