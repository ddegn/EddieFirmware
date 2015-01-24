CON{{ ****** Public Notes ******

  As part of Parallax's Open Propeller Project #8, the code originally used
  by the "Eddie" robot platform and control board is being converted for use
  with the Arlo platform using the Propeller Activity Board as the controller.

  The HB-25 Motor Controller replace the H-bridge circuit on the original Eddie
  Control Board.

  In order to make upgrading the firmware of both the versions using the Eddie
  control board and the Activity Board with the HB-25 motor controllers, some
  of the objects have been moved into a Header object. This allows one to
  select the hardward used my selecting the appropriate header file.

  Presently there are two possible header files to choose from. The file
  "HeaderEddieAbHb25Encodersxxxxxxx" is to be used with an Activity Board
  and HB-25 motor controllers. The header file "HeaderEddieHbridgeEncodersxxxxxxx"
  should be used when using the Eddie Control board.

  Programs named "EddieBxxxxxxx" will have firmware configured for the Eddie
  Control Board and Programs named "EddieCxxxxxxx" will have firmware configured
  for the Propeller Activity Board and HB-25 motor controllers.
  
  In order to make it easier to experiment with different settings used by the
  control algorithm, additonal commands have been added to the software.

  The encoder object "FourQuadratureMotors141224a" should make it possible to
  measure the speed of the wheels with greater accuracy than was possible with
  earlier versions of the firmware. The features of the object allowing greater
  accuracy are presently not used.

  Also to aid in the debugging process, some parameters will become "active
  parameters" when their corresponding command is issued. When a parameter is
  considered "active" the characters "+", "-", "*" and "/" may be used to
  adjust these parameters.

  The "active parameter" feature as well as many of the newly added commands
  will likely be removed once the software changes have been finalized.

  For more information about the Open Propeller Project #8 see the following
  thread in the Parallax forums.

  http://forums.parallax.com/showthread.php/158030
  
  List of Commands:
  Commands recently added include a brief discription of the commands'
  purpose. 

  "ACC": Used to set maxPosAccel. The array "activePositionAcceleration" is
  set using "maxPosAccel" for the fastest motor and scalling the acceleration
  to the slow motor proportional to the speed difference between the two motors. 
  "ADC": Returns the four ADC channels of the Activity Boards ADC chip twice or all
  eight ADC of the Eddie control board's ADC.
  When used with the Activity Board, the second set of values are based on a separate
  reading from the chip. The two sets of readings may not be identical. 
  "ARC": <degrees><radius><speed> Positive degree values (while radius and speed are
  positive) will cause the robot to travel in a clockwise arc. Negative degree values
  (with radius and speed positive) will cause the robot to travel in a counter clockwise
  arc. Negative radius or speed values will cause the robot to drive the arc backward.
  The radius is in units of encoder ticks and must be a non-zero value. (The speed
  travelled is computed from the center of the robot. The equations don't make sense when
  applied to an arc of zero radius.)
  Use the "TURN" command to rotate the robot in place.
  The radius and speed parameters apply to the center of the robot. The outside wheel
  will travel faster than the set speed and the inside wheel will travel slower than the
  set speed.
  To make robot travel backwards, use a negative speed value or a negative radius value.
  Note, the "TRVL" command does not allow negative speed values.
  When the radius is set to a value less than the bot's radius, the inside
  wheel will travel in the opposite direction as the outside wheel.
  "ARCMM": <degrees><radius(in millimeters)><speed> Similar to the "ARC" command but
  with the radius expessed in units of millimeters.
  "BIG": Set the amount the active parameter will change when using the
  "*" and "/" keys. Used to make tuning PID easier.
  "BLNK" 
  "BRT": <brightness> Set the brightness of the WS2812x LEDs. Range from zero (off) to
  $FF (full brightness). 
  "COLOR": <channel><color in hexadecimal> Set the color of a single WS2812x LEDs. The range
  for the channel parameter is from zero to MAX_LED_INDEX. The range for the color parameter
  is zero to $FFFFFF. The color is received in hexadecimal notation even if the decInFlag
  has been set. The colors will be adjusted by the value of "brightness" before being sent
  to the WS2811 driver. The red value is the most significant byte. To set the first LED
  to read use the command "COLOR 0 FF0000", to set the second LED green use "COLOR 1 FF00".
  To set the third LED blue use "COLOR 2 FF".
  "COLORS": <first channel><last channel><color in hexadecimal> Set the color of multiple
  WS2812x LEDs. The range for the two channel parameters is from zero to MAX_LED_INDEX.
  The range for the color parameter is the same for the command "COLOR".
  To set the second through fifth LED white use the command "COLORS 1 4 FFFFFF". As with
  the "COLOR" command the color parameter is received in hexadecimal notation even if the
  decInFlag has been set.  
  "DEBUG": Set the debugFlag value. When debugFlag is set extra data will
  be sent to the PC.
  "DECIN": When set, the program will accept decimal input rather than hexadecimal.
  "DECOUT": When set, the program will output decimal values rather than hexadecimal values.
  "DEMO": Set the number of times to call the method "ScriptedProgram". If a negative number
  is entered, the demo will run continuously. 1..$7F for finite number of calls or
  $FF for continuous opperation. (Use -1 instead of FF when using decimal input.)
  "DEMOID": Set the value for "activeDemo". When the value of demoFlag is greater than zero,
  the course associated with the value of "activeDemo" will be executed by the robot.
  The range is determined by the number of routes programmed into the "ScriptedProgram"
  method.
  "DIFF", "DIST"
  "GO", "GOSPD": Sets targetSpeed. Values between -100 and 100.
  "GOX": Set the power to each motor using a range between -7520 and 7520 for greater
  control than "GO".
  "HEAD", "HIGH", "HIGHS", "HWVER", "IN", "INS" 
  "KI": Used to set kI. (Becomes "active parameter" when used.)
  "KID": <endFlag><value> Used to set kIntegralDenominator. (Becomes "active parameter"
  when used.) "endFlag" may be either zero or one.
  "KILL": Set kill switch timer in milliseconds. Range $0000 to $6784.
  ($6784 = 26,500 (26.5 seconds) = MAX_KILL_SWITCH_TIME)
  If the time is set to zero, no communication is necessary to keep motors
  running. If a non-zero value is used, it should probably be larger
  than 50 so the overhead of parsing commands doesn't cause the
  motors to shutdown. Use "WATCH" to set timer with seconds.
  "KIN": <endFlag><value> Used to set kIntegralNumerator. (Becomes "active parameter" when
  used.) "endFlag" may be either zero or one.
  "KP": Used to set adjustableKP. (Both left and right adjustableKP variables become
  "active parameter" when used.) 
  "L": Similar to GOX but used to set only the left power.
  (targetPower[LEFT_MOTOR] becomes "active parameter" when used.)
  "LS": Similar to GOSPD but used to set only the right speed.
  (targetSpeed[LEFT_MOTOR] becomes "active parameter" when used.)
  "LOW", "LOWS", "MIDV"
  "MM": <distance in millimeters><speed> Similar to "TRVL" command but distance is received
  in units of millimeters rather than encoder ticks.
  "OUT", "OUTS"
  "PATH": <distance left><distance right><speed> Similar to "TRVL" command but the distance
  travelled by the two wheels my differ. The speed (and acceleration) of the slower wheel
  will be reduced proportionally to the distance travelled. The speed must be postive, use
  negative distance to travel backward.
  "PATHMM": <distance left><distance right><speed> Similar to "PATH" command but the distances
  travelled are expressed in units of millimeters.
  "PING": Response: <value1.[<value2>...<valueN>] The values returned for each sensor are
  12-bit hex values. One measurement is returned for each pin configured as a PING)) sensor
  pin.
  The Ping sensors are continuously read unless the "pausePingFlag" has been set with the
  PNGP command. A zero returned value indicates the sensor was not read successful. If not
  zero, the reading will be between $00A and $CC6 (10 and 3270). The readings are in units
  of millimeters.
  "PNGD": Used to set the delay used between triggering the Ping sensors. The delay value
  has the units of milliseconds. Delay values will be limited to the minimum of 9
  millisecond and a maximum 26,843 ($68DB) milliseconds.
  "PNGP": Used to set the state of the "pausePingFlag". When set, the Ping sensor will not
  be triggered. This could be useful when the ultrasound pulses may cause problems when
  listening for sounds. When the "pausePingFlag" is set to zero, the Ping sensors will be
  active. When non-zero, the Ping sensors will be inactive.
  Any commands which effect the Ping sensors will clear the "pausePingFlag".
  "PWR": Response: <left><right> The values returned are 32-bit hex values indicating the
  power setting for each motor. While the value returned in a 23-bit hex, the range of
  valid values will be between -500 and 500. This value is not the same as the "targetPower"
  value which may be set with GOX.
  "R": Similar to GOX but used to set only the right power.
  (targetPower[RIGHT_MOTOR] becomes "active parameter" when used.)
  "RS": Similar to GOSPD but used to set only the right speed.
  (targetSpeed[RIGHT_MOTOR] becomes "active parameter" when used.)
  "READ", "RST"
  "SERVO": Sets the pin and pulse length to control a servo. The servo pin
  does not need to be setup before hand. This command can not be used to
  set the two HB-25 controllers used to control the motors.
  (The "pin" parameter becomes the "activeServo" value and the pluse length
  parameter becomes the "active parameter". Using the "+", "-", "*" and "/"
  keys will change the position of the servo attached to the pin given in
  the last "SERVO" command. This can be useful in finding the center position
  of a servo.)
  "SETV", "SGP"
  "SMALL": Set the amount the active parameter will change when using the
  "+" and "-" keys. Used to make tuning PID easier.
  disabled(141215a)"SONG": Requests a song to be played. Songs are numbered 0 through 11.
  "SPD"
  "SPNG", "STOP"
  "TEMPO": Set the "tempo" variable. Used with "SONG" command.
  "TRVL", "TURN"
  "USE": Set speedToUse.
  "VER", "VERB"

  disabled(141215a)"VOL": Set volume used for sound commands. Range of 0 through 100.
  "WATCH": Set kill switch timer in seconds. Range $0 to $001A.
  ($001A = 26 (26 seconds) = MAX_KILL_SWITCH_SECONDS)
  If the time is set to zero, no communication is necessary to keep motors
  running. Use "KILL" to set timer with milliseconds. 
  "X": Turns off both motors.
  
}}
CON 
  
  _CLKMODE = XTAL1 + PLL16X
  _CLKFREQ = 80_000_000

  MICROSECOND = _CLKFREQ / 1_000_000
  ' Settings
  BUFFER_LENGTH = 255           ' Input Buffer Length must fit within input/output 'Index' ranges (currently a byte)
  ERROR_BUFFER_SIZE = 128        ' Size of buffer to save bad commands. (Most commands aren't long.)
  OUTPUT_COPY_BUFFER_SIZE = ERROR_BUFFER_SIZE
  PREVIOUS_BUFFER_SIZE = ERROR_BUFFER_SIZE
  VERSION = 14

  SCALED_MULTIPLIER = 1000
  SCALED_TAU = 6_283            ' circumfrence / radius
  SCALED_CIRCLE = 360 * SCALED_MULTIPLIER
  SMALL_ARC_THRESHOLD = posx / (SCALED_MULTIPLIER * SCALED_TAU) '341 
     
  SCALED_ROBOT_CIRCUMFERENCE = Header#POSITIONS_PER_ROTATION * SCALED_MULTIPLIER / 2

  ' Motor names
  #0
  LEFT_MOTOR
  RIGHT_MOTOR

  ' Motor control modes
  #0
  POWER
  SPEED
  STOPPING
  POSITION

  ' Pin assignments
  ' Ping))) sensors
  PING_0 = 0
  PING_1 = 1
 
  ' I2C EEPROM
  SCL = 28
  SDA = 29
  
  ' PC COMMUNICATION
  USB_TX = 30 
  USB_RX = 31

  XBEE_TX = 5
  XBEE_RX = 4
   
  
  ' Master GPIO mask (Only high pins can be set as outputs)
  OUTPUTABLE = Header#OUTPUTABLE
  PINGABLE = Header#PINGABLE
  SERVOABLE = Header#SERVOABLE
  MAX_ALLOWED_PINGS = Header#MAX_ALLOWED_PINGS
  PING_INTERVAL = 20            ' in milliseconds
  '**141220e MIN_PING = Ping#MIN_PING
  '**141220e MAX_PING = Ping#MAX_PING
  INITIAL_PING = Header#INITIAL_PING
  INITIAL_GPIO = Header#INITIAL_GPIO
  
  ' Terminal Settings
  BAUDMODE = Header#BAUDMODE
  USB_BAUD = Header#USB_BAUD
  XBEE_BAUD = 9_600
  
  'PROCESSRATE = _CLKFREQ / 16_000
  'TIMEOUT       = 10

  ' ASCII commands
  NUL           = $00           ' Null character
  SOH           = $01           ' Start of Header
  STX           = $02           ' Start of Text
  ETX           = $03           ' End of Text
  EOT           = $04           ' End of Transmission
  ENQ           = $05           ' Enquiry
  ACK           = $06           ' Acknowledgment
  BEL           = $07           ' Bell
  BS            = $08           ' Backspace
  HT            = $09           ' Horizontal Tab
  LF            = $0A           ' Line feed
  VT            = $0B           ' Vertical Tab
  FF            = $0C           ' Form feed
  CR            = $0D           ' Carriage return
  SO            = $0E           ' Shift Out
  SI            = $0F           ' Shift In
  DLE           = $10           ' Data Link Escape
  DC1           = $11           ' Device Control 1 (i.e. XON)
  DC2           = $12           ' Device Control 2
  DC3           = $13           ' Device Control 3 (i.e. XOFF)
  DC4           = $14           ' Device Control 4
  NAK           = $15           ' Negative Acknowledgment
  SYN           = $16           ' Synchronous idle
  ETB           = $17           ' End of Transmission Block
  CAN           = $18           ' Cancel
  EM            = $19           ' End of Medium
  SB            = $1A           ' Substitute
  ESC           = $1B           ' Escape
  FS            = $1C           ' File Separator
  GS            = $1D           ' Group Separator
  RS            = $1E           ' Record Separator
  US            = $1F           ' Unit Separator
  DEL           = $7F           ' Delete

  ' EEPROM constants
  I2C_ACK       = 0
  I2C_NACK      = 1
  DEVICE_CODE   = %0110 << 4
  PAGE_SIZE     = 128

  MAX_POWER = Header#MAX_POWER '7520 
  MIN_POWER = -MAX_POWER 
  
  MAX_INPUT_POWER = 127  ' Max allowed by "GO" command
  MIN_INPUT_POWER = -127
  ' "MAX_INPUT_POWER" and "MIN_INPUT_POWER" use
  ' values defined by the "Eddie Command Set"
  ' document published by Parallax.
  ' This is an arbitrary value when using this
  ' version of the firmware. 

  MAX_INPUT_SPEED = 127  ' Max allowed by "GOSPD" command
                         ' It's likely only values up to 100
                         ' will be matched.
  MIN_INPUT_SPEED = -MAX_INPUT_SPEED

  MAX_ARC_SPEED = 100
  ' The motors won't propel the robot faster (at least not much
  ' faster) than 100 encoder transitions per half second (the period
  ' which speed is calculated).
  SCALED_MAX_ARC_SPEED = SCALED_MULTIPLIER * MAX_ARC_SPEED
  '' The motors generally can not produce speeds matching "MAX_INPUT_SPEED".
  '' This can result is deformed arcs as the "fastMotor" does
  '' not reach the desired speed. By limiting the the value
  '' of "MAX_ARC_SPEED" to a realalist speed, the shape of the
  '' arcs should be improved.
           
  CONTROL_FREQUENCY = 50 ' Iterations per second
  HALF_SEC = CONTROL_FREQUENCY / 2   ' Iterations per unit 'dwd 141118b good name?
  'HALF_SEC changed to in some locations.
  POSITION_BUFFER_SIZE = CONTROL_FREQUENCY / 2

  SPEED_NUMERATOR = 2_000_000_000 ' largest manageable number
  ' 25 seconds of clock ticks
  ADJ_TO_TICKS_PER_HALF_SECOND = SPEED_NUMERATOR / (_CLKFREQ / 2)
  MIN_SPEED_RESOLUTION = 1000
  MAX_USABLE_TIME = SPEED_NUMERATOR /  MIN_SPEED_RESOLUTION
  '' The values "SPEED_NUMERATOR" and "MANAGABLE_BIT_ADJUSTMENT" are used to
  '' calculate the speed from the time between encoder ticks.
  '' The value produced from this calculation is a number 100 times
  '' as large as the value of the speed calculated with the original
  '' technique.
  '' Hopefully these extra digits are significant and the speed values
  '' calculated from the time between encoder ticks will allow for
  '' better control of the motors.
  
  'X_BUFFER_BITS = 4
  X_BUFFER_SIZE = HALF_SEC '1 << X_BUFFER_BITS
  'X_BUFFER_LIMIT = X_BUFFER_SIZE - 1

  'BUFFER_BITS = 4
  'SPEED_BUFFER_SIZE = 1 << BUFFER_BITS 'CONTROL_FREQUENCY / 2
  'ACCELERATION_BUFFER_SIZE = SPEED_BUFFER_SIZE
  DEADZONE      = 1 '* FOUR
  SAFEZONE      = 10
  PROMPT_SUM    = $0
  DEFAULT_CONTROL_FREQUENCY = 50
  DEFAULT_CONTROL_INTERVAL = _CLKFREQ / CONTROL_FREQUENCY
  DEFAULT_HALF_INTERVAL = DEFAULT_CONTROL_INTERVAL / 2 ' 1/100 of a second
  'DEFAULT_MAX_USEFUL_SPEED = 470
  CONTROL_CYCLES_TIL_FULL_POWER = CONTROL_FREQUENCY * 2
  CONTROL_CYCLES_TIL_FULL_SPEED = CONTROL_CYCLES_TIL_FULL_POWER
  'MAX_ENCODER_TICKS_PER_S = 200 ' can be 250 but use 200 to keep number managable (round)
  '' 200 encoder ticks per second equates to a measured speed of 10,000
  
  ' **141225c MAX_RAW_MEASURED_SPEED = 100 ' maxRawMeasuredSpeed this figure is not precise
                               ' the raw speed can be high as 125
                               
  ' 141209f This value is corresponds to an adjusted speed of 10,000
  ' This is 100 encoder ticks per half second (or 200 ticks per second).
  ' **141225c MAX_TIME_TO_WAIT_FOR_ENCODER = _CLKFREQ / 4 '_CLKFREQ / 2
  ' **141225c STOPPED_ENCODER_WAIT_TIME = _CLKFREQ / DEFAULT_CONTROL_FREQUENCY

  ' speedToUse enumeration
  #0, EXPERIMENTAL_SPEED, EDDIE_SPEED
  DEFAULT_SPEED_TYPE = EDDIE_SPEED
  
  SECONDS_UNTIL_SHUTDOWN = 2
  '' "SECONDS_UNTIL_SHUTDOWN" limits the time power will be applied to a motor
  '' without movement.

  'LOW_POWER_THRESHOLD = MAX_POWER / 10 ' When to start worrying about motors stopping
                                       ' too soon.
                                       
  'SMALL_DISTANCE_REMAINING_THRESHOLD = 100 ' When to start worrying about motors stopping
                                           ' too soon.   
  'DEFAULT_MAX_POWER_ACCELERATION = 20 'MAX_POWER / CONTROL_CYCLES_TIL_FULL_POWER '4
  'DEFAULT_MAX_SPEED_ACCELERATION = MAX_INPUT_SPEED / 40 'CONTROL_CYCLES_TIL_FULL_SPEED

  'DEFAULT_KPBASE = 11
  'ADJUST_TARGET_SPEED_MULTIPLIER = 100  ' Used to compute "adjustedTargetSpeed"
  'BUFFERED_SPEED_CUTOFF = MAX_INPUT_SPEED / 10 '4
  'SINGLE_CYCLE_SPEED_THRESHOLD = 500 
  
  ' Added motor control constants  
  MILLISECOND = _CLKFREQ / 1000
  MAX_KILL_SWITCH_TIME = 26_500 'posx / MILLISECOND - a few tenths of a second
  MAX_KILL_SWITCH_SECONDS = MAX_KILL_SWITCH_TIME / 1000
  
  #0, DEFAULT_DEMO, CAL_POS_PER_REV_DEMO, CAL_DISTANCE_DEMO, ARC_TEST_DEMO, {
    } TURN_TEST_DEMO, DISTANCE_TEST_DEMO
  
CON '' Debug Levels
'' Use these constants to indicate which sections of code should be debugged.
'' If the value of the "debugFlag" variable is larger than the value assigned to these
'' constants, then the cooresponding section of code will output debug messages.
'' For example, if "debugFlag" is set to "LIGHT_DEBUG" (1) then sections of code with a
'' constant set to "NO_DEBUG" or higher will display debug messages.

  '' debugFlag enumeration
  #0, NO_DEBUG, LIGHT_DEBUG, MODERATE_DEBUG, FULL_DEBUG, DEBUGGING_DEBUG

  '' The various debugging constants allow only certain debug statements to be turn
  '' on. The higher the value of "debugFlag", the more debugging statements will
  '' be displayed. If "debugFlag" is set to zero, none of the debugging statements
  '' will be displayed.
  
  PING_CMD_DEBUG = FULL_DEBUG
  PING_DEBUG = LIGHT_DEBUG
  INTRO_DEBUG = LIGHT_DEBUG ' any debugFlag other than zero will allow debugging
  PROP_CHARACTER_DEBUG = FULL_DEBUG
  KILL_SWITCH_DEBUG = LIGHT_DEBUG
  INPUT_WARNINGS_DEBUG = LIGHT_DEBUG
  SCRIPT_INTRO_DEBUG = LIGHT_DEBUG
  SCRIPT_DEBUG = MODERATE_DEBUG
  SCRIPT_EXECUTE_DEBUG = SCRIPT_DEBUG - 1
  SCRIPT_WARNING_DEBUG = INPUT_WARNINGS_DEBUG
  MAIN_DEBUG = LIGHT_DEBUG
  PARSE_DEBUG = MAIN_DEBUG + 1
  ARC_DEBUG = FULL_DEBUG
  SERVO_DEBUG = FULL_DEBUG
  TURN_DEBUG = FULL_DEBUG
  HEADING_DEBUG = LIGHT_DEBUG
  INTERPOLATE_MID_DEBUG = FULL_DEBUG
  PARSE_DEC_DEBUG = DEBUGGING_DEBUG
  POWER_DEBUG = LIGHT_DEBUG
  PID_DEBUG = LIGHT_DEBUG
  PID_P_DEBUG = PID_DEBUG
  PID_I_DEBUG = PID_DEBUG
  PID_D_DEBUG = PID_DEBUG
  PID_POSITION_DEBUG = PID_DEBUG
  PID_SPEED_DEBUG = PID_DEBUG

CON 

  #0, USB_COM, XBEE_COM, NO_ACTIVE_COM
  DEFAULT_CONTROL_COM = NO_ACTIVE_COM
  DEFAULT_DEBUG_COM = XBEE_COM 'USB_COM
  
  ' kpControlType enumeration
  #0, TARGET_DEPENDENT, CURRENT_SPEED_DEPENDENT

  #-3, NO_ATTEMPT_YET_COG, TURNED_OFF_COG, NO_AVAILABLE_COG

  FILL_LONG = $AA55_55AA   ' used to test stack sizes.
  MOTOR_CONTROL_STACK_SIZE = 36 ' It appears the cog monitoring the motors
  ' use 22 longs of the stack.
  PING_STACK_SIZE = 24 ' It appears the cog monitoring the Pings use 23 longs
  'of the stack.

  ACTIVE_SERVO_POS_IN_SERVOTXT = 8
  DEC_IN_RESTORE_POS = 6

  LED_PIN = 8
  LEDS_IN_USE = 10
  MAX_LED_INDEX = LEDS_IN_USE
  DEFAULT_BRIGHTNESS = $3F
  #0, FROM_INPUT_LED, DISPLAY_POSITION_ERROR_LED
  DEFAULT_LED_MODE = DISPLAY_POSITION_ERROR_LED 'FROM_INPUT_LED '
  DEFAULT_ERROR_SCALER = 100
  
CON '' Cog Usage
{{
  Presently all 8 cogs of the Propeller are used by this program.
  
  The objects, "Com", "Ping", "Servo", "Encoder", "Led" and "Header" each start
  their own cog.
  
  This top object uses two cogs bringing the total of cogs used to 8.
   
  The object "AltCom" is not presently active and requires a cog be freed prior
  to use.

  The objects "Ping", "Music" (included in the Header object) and "Led" are
  optional objects and will not effect the core features of the robot if removed.

  When using HB-25 motor controllers, the "Servo" object is required for motor
  control but if a h-bridge is being used, the "Servo" object is optional.
  
  The "Header" file for hardware configuration using the Activity Board, includes
  a "Music" object. This allows sounds to be played using the Activity Board's
  audio jack. Since the Eddie control board does not include an audio out jack,
  the "Header" file intended for use with the Eddie control board does not include
  the "Music" object.

  If someone requires help adding the "AltCom" object into the program, they are
  welcome to ask Duane Degn for assistance.
  
}}
VAR

  long error                                            ' Error message pointer for verbose responses                        
  long lastUpdated[2]
  long stack[MOTOR_CONTROL_STACK_SIZE]                  ' Stack for cog running position control system
  
  '' Keep variables below in order.
  long pingCount, pingResults[Header#PINGS_IN_USE]
  long pingStack[PING_STACK_SIZE]
  '' Keep variables above in order.

  long activeParameter
  long activeParTxtPtr
 
  long positionDifference[2] 
  long lastComTime, lastPartialTime
  long newPowerTarget[2]
  long rampedPower[Encoders#TOTAL_ENCODERS]
  long encoderDirection[Encoders#TOTAL_ENCODERS] ' Tis will be either 1 or -1 depending on 
                                                 ' which way the motor is turning. I'm not 
                                                 ' surewhy I added this.
  long targetPower[2]
  long integral[2]
  long targetSpeed[2]
  long motorPosition[2], motorSpeed[2]
  long transitionTime[Encoders#TOTAL_ENCODERS]
  
  long motorPositionBuffer[2 * POSITION_BUFFER_SIZE]
  long bufferIndex
  long motPosOffset[2] ' Offset between Physical and internal motor position
  long midPosition[2] ' Position the PD loop is attempting to hold
  long midPosAcc[2] ' fractional part  
  long midVelocity[2] ' Current position change velocity
  long midVelAcc[2] ' fractional part 
  long setPosition[2] ' Position that midPosition is approaching
  long decel[2] ' Deceleration rate 
  
  long previousDifference[2], gDifference[2]
  long stillCnt[2] ' Number of iterations in a row that the motor hasn't moved
  long addressOffsetCorrection
  long activePositionAcceleration[2]
  long fullBrightnessArray[LEDS_IN_USE], gLimit[2]

  long stoppedMotorCount[Encoders#TOTAL_ENCODERS], alternatingEncoder[Encoders#TOTAL_ENCODERS]
  long alternatingTimeStamp[Encoders#TOTAL_ENCODERS]
  long alternatingDeltaTime[Encoders#TOTAL_ENCODERS]
  long previousPosition[Encoders#TOTAL_ENCODERS]
  long previousTimeStamp[Encoders#TOTAL_ENCODERS]
  long positionBuffer[POSITION_BUFFER_SIZE * Encoders#TOTAL_ENCODERS]
  '\long xPositionBuffer[POSITION_BUFFER_SIZE * Encoders#TOTAL_ENCODERS]
  'long xTimeBuffer[POSITION_BUFFER_SIZE * Encoders#TOTAL_ENCODERS]
  'long xPeriodSpeed[Encoders#TOTAL_ENCODERS]
  'long xAverageSpeed[Encoders#TOTAL_ENCODERS], xBufferTotal[Encoders#TOTAL_ENCODERS]
  long deltaPosition[Encoders#TOTAL_ENCODERS], currentSpeed[Encoders#TOTAL_ENCODERS]
  'long xPeriodDistance[Encoders#TOTAL_ENCODERS], xPeriodTime[Encoders#TOTAL_ENCODERS]
  'long xPreviousCycleTime[Encoders#TOTAL_ENCODERS]
  long fullCycleTimeStamp[Encoders#TOTAL_ENCODERS]
  'long xCycleSingleDeltaTime[Encoders#TOTAL_ENCODERS]
  'long xPreviousCycleEncoder[Encoders#TOTAL_ENCODERS]
  long alternatingFullCycle[Encoders#TOTAL_ENCODERS]
  'long xCycleSingleDistance[Encoders#TOTAL_ENCODERS]
  'long xCyclePeriodDistance[Encoders#TOTAL_ENCODERS], xCyclePeriodTime[Encoders#TOTAL_ENCODERS]
  'long alternatingFullCycleBuffer[Encoders#TOTAL_ENCODERS * POSITION_BUFFER_SIZE]
  'long fullCycleTimeStampBuffer[Encoders#TOTAL_ENCODERS * POSITION_BUFFER_SIZE]
  long halfSecondDeltaPosition[Encoders#TOTAL_ENCODERS]
  long halfSecondDeltaTime[Encoders#TOTAL_ENCODERS]
  long timeBuffer[Encoders#TOTAL_ENCODERS * POSITION_BUFFER_SIZE] 
  'long xCyclePeriodSpeed[Encoders#TOTAL_ENCODERS], xCycleSingleSpeed[Encoders#TOTAL_ENCODERS] 
  long altDataPtr[Encoders#TOTAL_ENCODERS]
  long bufferedSpeed[Encoders#TOTAL_ENCODERS]
  long eddieSpeed[Encoders#TOTAL_ENCODERS]
  byte stillStoppedFlag[Encoders#TOTAL_ENCODERS]
  byte positionErrorFlag[2]
  byte pingsInUse, maxPingIndex
  byte inputBuffer[BUFFER_LENGTH], outputBuffer[BUFFER_LENGTH] 
  byte inputIndex, parseIndex, outputIndex
  byte midReachedSetFlag[2]
       
DAT '' variables which my have non-zero initial values 

gpioMask                        long INITIAL_GPIO       ' Pins currently used as GPIO pins
pingMask                        long INITIAL_PING       ' Pins currently running PING))) Sensors
pingInterval                    long PING_INTERVAL
           
maxPowAccel                     long 470        ' Maximum allowed motor power acceleration
maxPosAccel                     long 800        ' Maximum allowed positional acceleration

kProportional                   long 117[2] 
kIntegralNumerator              long Header#DEFAULT_INTEGRAL_NUMERATOR
                                long Header#DEFAULT_INTEGRAL_NUMERATOR_END 
kIntegralDenominator            long Header#DEFAULT_INTEGRAL_DENOMINATOR
                                long Header#DEFAULT_INTEGRAL_DENOMINATOR_E
tempo                           long 1500
smallChange                     long 1
bigChange                       long 10
killSwitchTimer                 long 0 '1000 * MILLISECOND ' default Eddie delay. Set to 0 to turn off.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  
partialComTimeLimit             long 15_000 * MILLISECOND
servoPosition                   long 1500
controlFrequency                long DEFAULT_CONTROL_FREQUENCY
halfInterval                    long DEFAULT_HALF_INTERVAL
directionFlag                   long 1[2], 1[10]
errorScaler                     long DEFAULT_ERROR_SCALER
direction                       long 1[2]
DAT
' todo change this pins to bytes
positiveDirectionPin            long Header#POSITIVE_DIRECTION_PIN_0
                                long Header#POSITIVE_DIRECTION_PIN_1
negativeDirectionPin            long Header#NEGATIVE_DIRECTION_PIN_0
                                long Header#NEGATIVE_DIRECTION_PIN_1
enablePin                       long Header#ENABLE_0, Header#ENABLE_1

encoderPin                      byte Header#ENCODERS_PIN_0, Header#ENCODERS_PIN_1
speedToUse                      byte DEFAULT_SPEED_TYPE
activeDemo                      byte DISTANCE_TEST_DEMO 'TURN_TEST_DEMO 'DEFAULT_DEMO 'ARC_TEST_DEMO 'CAL_POS_PER_REV_DEMO 'CAL_DISTANCE_DEMO '
demoFlag                        byte 0 ' set to 255 or -1 to continuously run demo
                                       ' other non-zero values will instuct the 
                                       ' program the number of times it should execute
                                       ' the method "ScriptedProgram".
                                       
debugFlag                       byte FULL_DEBUG
decInFlag                       byte 1 ' set to 1 to use decimal input rather an hexadecimal
decOutFlag                      byte 1 ' set to 1 for decimal output rather an hexadecimal
volume                          byte 30
pingPauseFlag                   byte 0

controlCom                      byte DEFAULT_CONTROL_COM
debugCom                        byte DEFAULT_DEBUG_COM                      
mode                            byte 0                  ' Current mode of the control system
verbose                         byte true 'false '      ' Verbosity level (Currently nonzero = verbose)

activeServo                     byte 6
brightness                      byte DEFAULT_BRIGHTNESS
ledMode                         byte DEFAULT_LED_MODE

OBJ                             
                                
  Header : "HeaderEddieAbHb25Encoders"                 ' uses one cog for music
  'Header : "HeaderEddieHbridgeEncoders"                 ' uses one cog
  
  Encoders : "QuadratureMotors"                         ' uses one cog
  Com : "Serial4PortLocks"                              ' uses one cog
  Ping : "EddiePingMonitor"                             ' uses one cog
  
  Servo : "Servo32v9Shared"                             ' uses one cog
  Led : "jm_ws2812"                                     ' uses one cog
  
  'AltCom : "Serial4PortLocksA"                         ' uses one cog
  '' The "AltCom" object allows commands to be received from I/O pins
  '' other than the ones used to communicate with the PC.
  '' This would allow communication with other devices such as a microcontroller
  '' or a XBee.
 
PUB Main | rxCheck

  Com.Init
  Com.AddPort(USB_COM, USB_RX, USB_TX, -1, -1, 0, BAUDMODE, USB_BAUD)
  Com.AddPort(XBEE_COM, XBEE_RX, XBEE_TX, -1, -1, 0, BAUDMODE, XBEE_BAUD)
  Com.Start                                             'Start the ports
  {'**141220d  
  AltCom.Init
  AltCom.AddPort(0, Header#ALT_RX, Header#ALT_TX, -1, -1, 0, 0, Header#ALT_BAUD)
  AltCom.Start                                         'Start the ports    
  }'**141220d
  
  Servo.Start
  
  Header.InitAdc           
    
  longfill(@pingStack, FILL_LONG, PING_STACK_SIZE)
  Ping.Start(pingMask, pingInterval, @pingResults)
  ' Continuously trigger and read pulse widths on PING))) pins
  pingsInUse := Ping.GetPingsInUse
  maxPingIndex := pingsInUse - 1
  addressOffsetCorrection := @addressOffsetTest - addressOffsetTest
  longfill(@activePositionAcceleration, maxPosAccel, 2)
  
  Header.InitMusic(volume)
  
  longfill(@stack, FILL_LONG, MOTOR_CONTROL_STACK_SIZE)
  result := cognew(PDLoop, @stack)                      ' Run the position controller in another core  
  Led.start(LED_PIN, LEDS_IN_USE)

  if debugFlag => INTRO_DEBUG
    Com.Strs(debugCom, string(11, 13, "Eddie Firmware"))
   
    Com.Tx(debugCom, 7) ' Bell sounds in terminal to catch reset issues
    waitcnt(clkfreq / 4 + cnt)
    Com.Tx(debugCom, 7)
    waitcnt(clkfreq / 4 + cnt)
    Com.Txe(debugCom, 7)
    
  'ExecuteStoredCommand(@introSong)
    
  activeParameter := @targetPower[RIGHT_MOTOR]
  activeParTxtPtr := @targetPowerRTxt
  lastPartialTime := lastComTime := cnt
  repeat                                                ' Main loop (repeats forever)
    repeat           ' Read a byte from the command UART
      if demoFlag
        ScriptedProgram
        if demoFlag <> $FF
          demoFlag--
          
      rxCheck := CheckCom
            
       
      ' Stop motors if no communication has been received in the allowed time
      ' (dwd 141125b I changed time keeping variables from original code.)
      ' The allowed time (in millieseconds) may be changed with the "KILL" command.
      ' The "WATCH" command will change the time in seconds.
      if killSwitchTimer ' if killSwitchTimer is zero don't check time
        if cnt - lastComTime > killSwitchTimer
          'ifnot pDRunning
          'Header.SetMotorPower(1, 0)
          longfill(@rampedPower, 0, 2)
          Encoders.RefreshPower
          if debugFlag => KILL_SWITCH_DEBUG
            Com.Strse(debugCom, string(13, "Motors Stopped"))
          waitcnt(constant(_clkfreq / CONTROL_FREQUENCY) + cnt)
          targetPower[LEFT_MOTOR] := 0
          targetPower[RIGHT_MOTOR] := 0
          targetSpeed[LEFT_MOTOR] := 0
          targetSpeed[RIGHT_MOTOR] := 0
          longfill(@stillCnt, 0, 2)
          mode := POWER
      if true 
        if debugFlag => MAIN_DEBUG
          TempDebug(debugCom)
    while rxcheck < 0
       
    inputBuffer[inputIndex++] := rxcheck
    ' *** This could be a problem if input is received from two different ports.

    if inputIndex == constant(BUFFER_LENGTH)            ' Check for a full buffer
      OutputStr(@nack)                                  ' Ready error response
      if verbose                                        ' If in verbose mode, add a description
        OutputStr(@overflow)
      inputIndex := 0                                   '   to start receiving a new command
      controlCom := NO_ACTIVE_COM
      {repeat                                            ' Ignore all inputs other than NUL or CR (terminating a command) 
        case Rx(controlCom)                        ' Send the correct error response for the transmission mode
          {
          NUL :                                         '   Checksum mode
            SendChecksumResponse
            quit
          }
          CR :                                          '   Plain text mode
            SendResponse    ' branch # 1 termination 
            quit    }
    else                                                ' If there isn't a buffer overflow...                              
      case inputBuffer[inputIndex - 1]                  ' Parse the character
        
        NUL :                                           ' End command in checksum mode:
          if debugFlag => INPUT_WARNINGS_DEBUG
            Com.Strs(debugCom, string(11, 13, 7, "Error, NUL character received.", 7))
            Com.Stre(debugCom, Error)
            waitcnt(clkfreq * 2 + cnt)

          {if inputIndex > 1                             '   Only parse buffer if it has content
            ifnot Error := \ChecksumParse               '   Run the parser and trap and report errors
              outputIndex~                              '    Handle errors, if they occurred
              OutputStr(@nack)
              if verbose
                OutputStr(Error)
            SendChecksumResponse                        '   Send a response if no error
          else                                          '   For an empty buffer, clear the pointer
            inputIndex~                                 '   to start receiving a new command
           }
        BS :                                            ' Process backspaces
          if --inputIndex                               ' Ignore the BS character itself
            --inputIndex                                ' Ignore previous character if exists
          ifnot inputIndex
            controlCom := NO_ACTIVE_COM
            
        "+" :
          UpdateActive(smallChange)
        "-" :
          UpdateActive(-1 * smallChange)
        "*" :
          UpdateActive(bigChange)
        "/" :
          UpdateActive(-1 * bigChange)
          
        CR:                                             ' End command in plaintext mode:
          if inputIndex > 1                             ' Only parse buffer if it has content
            if error := \Parse                          ' Run the parser and trap and report errors
              outputIndex := 0                          ' Handle errors, if they occurred
              OutputStr(@nack)
             
              if verbose
                OutputStr(error)
                if debugFlag => INPUT_WARNINGS_DEBUG
                  Com.Strs(debugCom, string(11, 13, 7, "Parse Error = "))
                  Com.Stre(debugCom, error)
                  waitcnt(clkfreq * 2 + cnt)
            else
              result := inputIndex <# PREVIOUS_BUFFER_SIZE
                       
            SendResponse                                ' Send a response if no error
           
          else                                          ' For an empty buffer, clear the pointer
            inputIndex := 0                             ' to start receiving a new command
          controlCom := NO_ACTIVE_COM 
        SOH..BEL, LF..FF, SO..US, 127..255 :            ' Ignore invalid characters
          if debugFlag => INPUT_WARNINGS_DEBUG
            Com.Strs(debugCom, string(11, 13, 7, "Invalid Character Error = <$"))
            Com.Hex(debugCom, inputBuffer[inputIndex - 1], 2)
            Com.Txe(debugCom, ">")
            inputIndex--
            waitcnt(clkfreq / 2 + cnt)
                      
PRI CheckCom : rxCheck

  case controlCom
    USB_COM:
      Com.Lock
      rxCheck := Com.RxCheck(USB_COM)
      Com.E ' clear lock 
    XBEE_COM:
      Com.Lock
      rxCheck := Com.RxCheck(XBEE_COM)
      Com.E ' clear lock 
    NO_ACTIVE_COM:
            
      Com.Lock
      rxCheck := Com.RxCheck(USB_COM)
      Com.E ' clear lock
      if rxCheck == -1
        Com.Lock
        rxCheck := Com.RxCheck(XBEE_COM)
        Com.E
        if rxCheck <> -1
          controlCom := XBEE_COM
          debugCom := XBEE_COM
      else
        controlCom := USB_COM
        debugCom := USB_COM
  if rxCheck <> -1
    lastPartialTime := cnt
  elseif cnt - lastPartialTime > partialComTimeLimit
    case controlCom
      USB_COM, XBEE_COM:
        rxCheck := 13 ' force end of communication
        
PRI UpdateActive(changeAmount)

  if inputIndex == 1
    long[activeParameter] += changeAmount
    if activeParameter == @servoPosition
      Servo.Set(activeServo, servoPosition)
    elseif activeParameter == @controlFrequency
      halfInterval := clkfreq / controlFrequency / 2
    elseif activeParTxtPtr == @kProportionalTxt 
      long[activeParameter + 4] += changeAmount ' adjust right also
    inputIndex--
    lastComTime := cnt
    controlCom := NO_ACTIVE_COM
    
PUB ScriptedProgram
'' The current scripted program.
'' Set the "demoFlag" variable to 1 to run the scripted section
'' of this program.

  '' Initialize Script Portion of Program
  if debugFlag => SCRIPT_INTRO_DEBUG 
    Com.Strse(debugCom, string(11, 13, "Starting Demo", 11, 13))
  result := decInFlag ' save flag state to retore later
  '' It's a good idea to make the first command in the script a "DECIN" command
  '' the program know which base system to use as input.
  
  waitcnt(clkfreq / 4 + cnt)
  if debugFlag => SCRIPT_DEBUG
    Com.Lock
    Com.Txe(debugCom, 12) ' clear below

  case activeDemo
    DEFAULT_DEMO:
      PlayRoute(@twoByOneMRectanglePlusTwo8s)
    CAL_POS_PER_REV_DEMO:  
      PlayRoute(@calibratePosPerRev)
    CAL_DISTANCE_DEMO:  
      PlayRoute(@calibrateDistance)
    ARC_TEST_DEMO:  
      PlayRoute(@arcTest)
    TURN_TEST_DEMO:  
      PlayRoute(@turnTest)
    DISTANCE_TEST_DEMO:  
      PlayRoute(@distanceTest)
    other:
      PlayRoute(@twoByOneMRectanglePlusTwo8s)
    
                
  waitcnt(clkfreq / 4 + cnt)
  '' Finalize Script Portion of Program
  byte[@restoreConfig][DEC_IN_RESTORE_POS] := result + "0"
  ExecuteStoredCommand(@restoreConfig)
  waitcnt(clkfreq / 4 + cnt)
  inputIndex := 0            
  if debugFlag => SCRIPT_INTRO_DEBUG
    Com.Strse(debugCom, string(11, 13, "End of Demo", 11, 13))

PRI PlayRoute(routePtr)

  repeat while word[routePtr]
    ExecuteAndWait(word[routePtr] + addressOffsetCorrection)
    routePtr += 2
    
PRI ExecuteStoredCommand(commandPtr)

  inputIndex := strsize(commandPtr) + 1
  bytemove(@inputBuffer, commandPtr, inputIndex)
  if debugFlag => SCRIPT_EXECUTE_DEBUG
    Com.Txs(debugCom, 11)
    Com.Tx(debugCom, 13)
    Com.Stre(debugCom, commandPtr)
  if error := \Parse                          '   Run the parser and trap and report errors
    if debugFlag => SCRIPT_WARNING_DEBUG
      Com.Strse(debugCom, error)  

PRI ExecuteAndWait(pointer)

  ExecuteStoredCommand(pointer)
  waitcnt(clkfreq * 3 + cnt) ' wait for motors to get some speed
  repeat while motorSpeed[0] or motorSpeed[1] or {
  } ||gDifference[0] > Header#TOO_SMALL_TO_FIX or ||gDifference[1] > Header#TOO_SMALL_TO_FIX
    DisplayPositionError
  ' wait while motors are still turning and until the final destination is reached.

PRI TempDebug(port) | side

  if ledMode == DISPLAY_POSITION_ERROR_LED
    DisplayPositionError

      {
    repeat side from 0 to 1
      if side
        localColor := $FF0000
      else
        localColor := $FF00
          
      if freezeError[side] > 0
        OrColors(0, (freezeError[side]  / errorScaler) - 1, localColor)
      elseif freezeError[side] < 0
        OrColors(MAX_LED_INDEX + (freezeError[side]  / errorScaler) + 1, MAX_LED_INDEX, localColor) }
    
      
  'if port <> USB_COM
  '  return
              
  Com.Txs(port, 11)
  Com.Tx(port, 1) ' home
  {'150102
  Com.Str(USB_COM, string(11, 13, "Eddie Firmware"))
  
  Com.Str(port, string(", mode = "))
  Com.Dec(port, mode)
  Com.Str(port, string(" = "))
  Com.Str(port, FindString(@modeAsText, mode))
 
  Com.Str(port, string(11, 13, "activeParameter = "))
  Com.Str(port, activeParTxtPtr)  
  Com.Str(port, string(" = "))
  Com.Dec(port, long[activeParameter])


  Com.Str(port, string(11, 13, "kIN = "))
  Com.Dec(port, kIntegralNumerator) 
  Com.Str(port, string(", kID = "))
  Com.Dec(port, kIntegralDenominator) 
  
  if debugFlag => PING_DEBUG
    Com.Str(port, string(11, 13, "pingCount = "))
    Com.Dec(port, pingCount)
    Com.Str(port, string(", pingMask = "))
    Com.Dec(port, pingMask)
    Com.Str(port, string(", pingInterval = "))
    Com.Dec(port, pingInterval)
    
    Com.Str(port, string(", pingResults = "))
    Com.Dec(port, pingResults[0])
    Com.Str(port, string(", "))
    Com.Dec(port, pingResults[1]) }'150102
  
  repeat side from 0 to 1
  
    if debugFlag => POWER_DEBUG
      Com.Str(port, string(11, 13, 11, 13, "targetPower["))
      Com.Dec(port, side)
      Com.Str(port, string("] = "))
      Com.Dec(port, targetPower[side])
      Com.Str(port, string(", rampedPower = "))
      Com.Dec(port, rampedPower[side])
      Com.Str(port, string(", difference = "))
      Com.Dec(port, targetPower[side] - rampedPower[side])  
     
    if debugFlag => PID_SPEED_DEBUG
     
      Com.Str(port, string(11, 13, "targetSpeed["))
      Com.Dec(port, side)
      Com.Str(port, string("] = "))
      Com.Dec(port, targetSpeed[side])
 
      Com.Str(port, string(", gDifference = "))
      Com.Dec(port, gDifference[side])
      Com.Str(port, string(", gLimit = "))
      Com.Dec(port, gLimit[side])

      Com.Str(port, string(11, 13, "setPosition = "))
      Com.Dec(port, setPosition[side])
      Com.Str(port, string(", midPosition = "))
      Com.Dec(port, midPosition[side])
      Com.Str(port, string(", difference = "))
      Com.Dec(port, setPosition[side] - midPosition[side])

      {'150102
      Com.Str(port, string(", integral = "))
      Com.Dec(port, integral[side])  }
      
      Com.Str(port, string(11, 13, "speedToUse = "))
      Com.Str(port, FindString(@speedToUseTxt, speedToUse))
      Com.Str(port, string(", motorSpeed = "))
      Com.Dec(port, motorSpeed[side])
      Com.Str(port, string(11, 13, "motorPosition["))
      Com.Dec(port, side)
      Com.Str(port, string("] = "))
      Com.Dec(port, motorPosition[side])       
      Com.Str(port, string(", eddieSpeed = "))
      Com.Dec(port, eddieSpeed[side])
      Com.Str(port, string(11, 13, "currentSpeed ="))
      Com.Dec(port, currentSpeed[side])       
      Com.Str(port, string(", bufferedSpeed = "))
      Com.Dec(port, bufferedSpeed[side])
      
    {    
    if debugFlag => PID_POSITION_DEBUG
      Com.Str(port, string(11, 13, "kProportional = "))
      Com.Dec(port, kProportional[side])   } '150102
      
     
      
  'MotorControlStackDebug(port)
  'PingStackDebug(port) 
      
  {if debugFlag => PID_POSITION_DEBUG
    Com.Str(port, string(11, 13, "motorPositionBuffer[LEFT] = ", 11, 13))
    DumpBuffer(port, @motorPositionBuffer, POSITION_BUFFER_SIZE, @bufferIndex, 0)
    Com.Str(port, string(11, 13, "motorPositionBuffer[RIGHT] = ", 11, 13))
    DumpBuffer(port, @motorPositionBuffer + (POSITION_BUFFER_SIZE * 4), POSITION_BUFFER_SIZE, {
    } @bufferIndex, 0)  }
   
  
  {if inputIndex
    Com.Str(port, string(11, 13, "InputBuffer = ")) 
    SafeDebug(port, @InputBuffer, inputIndex) }

  
                
  Com.Tx(port, 11)
  Com.Txe(port, 13)

PUB DisplayPositionError | freezeError[2]

  longmove(@freezeError, @gDifference, 2)
  longfill(@fullBrightnessArray, 0, LEDS_IN_USE)
  freezeError[0] *= direction[0]
  freezeError[1] *= direction[1]
  if freezeError[0] > freezeError[1]
    OrColors(0, freezeError[0] - freezeError[1] - 1, $FF0000)
  elseif freezeError[0] < freezeError[1]
    OrColors(0, freezeError[1] - freezeError[0] - 1, $FF00)
  AdjustAndSet(@fullBrightnessArray, brightness, LEDS_IN_USE)
      
PUB MotorControlStackDebug(port)

  Com.Str(port, string(11, 13, "Motor Control Stack = ", 11, 13))
  DumpBufferLong(port, @stack, MOTOR_CONTROL_STACK_SIZE, 12)
           
PUB PingStackDebug(port)

  Com.Str(port, string(11, 13, "Ping Stack = ", 11, 13))
  DumpBufferLong(port, @pingStack, PING_STACK_SIZE, 12)

PUB DumpBuffer(port, bufferPtr, bufferSize, interestedLocationPtr, offset) : localIndex

  bufferSize--

  repeat localIndex from 0 to bufferSize
    if long[interestedLocationPtr] - offset == localIndex
      Com.Tx(port, "*")
    Com.Dec(port, long[bufferPtr][localIndex])
    
    if localIndex // 8 == 7 and localIndex <> bufferSize
      Com.Tx(port, 11)
      Com.Tx(port, 13)
    elseif localIndex <> bufferSize  
      Com.Tx(port, ",")
      Com.Tx(port, 32)  

PRI DumpBufferLong(port, localPtr, localSize, localColumns) | localIndex

 
  Com.Str(port, string("DumpBufferLong @ $"))
  Com.Dec(port, localPtr)

  Com.Tx(port, 11) 
  
  repeat localIndex from 0 to localSize - 1
    if localIndex // localColumns == 0
      Com.Tx(port, 11) 
      Com.Tx(port, 13) 
    else
      Com.Tx(port, 32)  
    Com.Tx(port, "$")  
    Com.Hex(port, long[localPtr][localIndex], 8)

PUB FindString(firstStr, stringIndex)      '' Called from DebugCog
'' Finds start address of one string in a list
'' of string. "firstStr" is the address of 
'' string #0 in the list. "stringIndex"
'' indicates which of the strings in the list
'' the method is to find.
'' Version from HexapodRemote140128a
'' Version Hexapod140129a, removed commented
'' out code.

  result := firstStr 
  repeat while stringIndex    
    repeat while byte[result++]  
    stringIndex--
    
PUB SafeDebug(port, ptr, size)

  repeat size
    SafeTx(port, byte[ptr++])
    
PUB SafeTx(port, character)

  case character
    32.."~":
      Com.Tx(port, character)
    other:
      Com.Tx(port, "<")
      Com.Tx(port, "$")
      Com.Hex(port, character, 2)
      Com.Tx(port, ">")
      
PRI Parse                                               '' Parse the command in the input buffer
'' Since Spin only allows 16 "elseif" statements in a row, the parsing
'' of the command is split into multiple lists of "elseif" conditions.
'' The method to parse the commands will be selected based on the first
'' letter of the command.
  
  inputBuffer[inputIndex - 1]~                          ' Ensure buffer is NUL terminated (may have been CR terminated)

  repeat parseIndex from 0 to inputIndex - 2            ' Find the end of the command in the input buffer             
    case inputBuffer[parseIndex]                         
      "a".."z" :                                        ' Set all command characters to uppercase
        inputBuffer[parseIndex] -= constant("a" - "A")
      HT, " " :                                         ' Determine command length by finding the first whitespace character
        inputBuffer[parseIndex]~                        ' Null terminate the command
        quit                                            ' parseIndex now points to the null at the end of the command string (before the first parameter, if present)

  ' parameter[n] := ParseHex(NextParameter) caches the parameters to check for their existence before running the command
  ' CheckLastParameter checks for too many parameters
  ' The Output...() methods write responses to the output buffer
  ' Check command against the following strings:

  case inputBuffer[0]
    "A".."F":
      ParseAF
    "G".."I":
      ParseGI
    "J", "K":
      ParseJK
    "L".."N":
      ParseLN
    "O".."R":
      ParseOR
    "S".."Z":
      ParseSZ
    other:
      abort @invalidCommand

  lastComTime := cnt
  return 0

PRI ParseAF | index, parameter[3]
'' 15 Commands 
'' "ACC", "ADC", "ARC", "BIG", "BLNK", "BRT", "COLOR", "COLORS"  ' 8
'' "DEBUG", "DECIN", "DECOUT", "DEMO", "DEMOID", "DIFF", "DIST" ' 7
   
  if strcomp(@InputBuffer, string("ACC"))
    parameter := ParseHex(NextParameter)
    CheckLastParameter
    case Parameter
      1..2047:                                   
        maxPosAccel := Parameter
        longfill(@activePositionAcceleration, maxPosAccel, 2)
      other:
        abort @invalidParameter
  elseif strcomp(@InputBuffer, string("ADC"))           ' Command: Respond with voltages from ADC
    CheckLastParameter
    OutputHex(Header.ReadAdc(0), 3)                     ' Show output from first ADC
    repeat index from 1 to 7                            ' For the remaining 7
      OutputChr(" ")                                    ' Transmit a space character
      OutputHex(Header.ReadAdc(Index), 3)               ' Then the output from the ADC
  elseif strcomp(@InputBuffer, string("ARC"))
  ' Command: Turn a specified number of degrees around a circle of a specified radius
    parameter[0] := ParseHex(NextParameter)           ' degrees
    parameter[1] := ParseHex(NextParameter)           ' radius in encoder ticks
    parameter[2] := ParseHex(NextParameter)           ' speed (of center of bot)
    CheckLastParameter
    ifnot decInFlag
      ~~parameter[0]
      ~~parameter[1]
      ~parameter[2]

    Arc(parameter[0], parameter[1] * SCALED_TAU, parameter[2])
 
  elseif strcomp(@InputBuffer, string("ARCMM"))
  ' Command: Turn a specified number of degrees around a circle of a specified radius
    parameter[0] := ParseHex(NextParameter)           ' degrees
    parameter[1] := ParseHex(NextParameter)           ' radius in encoder ticks
    parameter[2] := ParseHex(NextParameter)           ' speed (of center of bot)
    CheckLastParameter
    ifnot decInFlag
      ~~parameter[0]
      ~~parameter[1]
      ~parameter[2]

    if parameter[1] < SMALL_ARC_THRESHOLD
      Arc(parameter[0], parameter[1] * SCALED_TAU * 1000 / Header#MICROMETERS_PER_TICK, parameter[2])
    else
      Arc(parameter[0], (1000 * SCALED_TAU / Header#MICROMETERS_PER_TICK) * parameter[1] , parameter[2])
    
  elseif strcomp(@InputBuffer, string("BIG"))        
    Parameter := ParseHex(NextParameter)
    CheckLastParameter
    bigChange := parameter
  elseif strcomp(@InputBuffer, string("BLNK"))        ' Command: Blink the specified pin at a specified rate
    parameter[0] := ParseHex(NextParameter)           ' Pin number
    parameter[1] := ParseHex(NextParameter)           ' Frequency
    CheckLastParameter
    parameter[2] := |< parameter[0]                   ' Create a pin mask from the pin number
    if parameter[2] & OUTPUTABLE                      ' Only use this command on a pin that can be an output
      if parameter[1]                                 
        if parameter[2] & pingMask                    ' If the pin used to be a PING))) sensor pin
          ResetPingDriver(pingMask &= !parameter[0])  ' Restart the PING))) sensor processor with the pin removed from the mask
        gpioMask &= !parameter[2]                     ' Flag the pin as a GPIO pin
        outa[parameter[0]]~                           ' The I/O pin must be set as a low input
        dira[parameter[0]]~~
        ctra := constant(%00101 << 26) + parameter[0] ' Set counter A to toggle the I/O pin
        frqa := constant($8000_0000 / _clkfreq / 10) * parameter[1] ' Calculate the toggle period            
      else
        ctra~                                         ' A frequency of 0 turns of the counter
  
  elseif strcomp(@InputBuffer, string("BRT"))        
    parameter := ParseHex(NextParameter)
    CheckLastParameter
    brightness := parameter
    AdjustAndSet(@fullBrightnessArray, brightness, LEDS_IN_USE) 
  elseif strcomp(@InputBuffer, string("COLOR"))        
    parameter[0] := ParseHex(NextParameter)           
    parameter[1] := ReallyParseHex(NextParameter)    
    CheckLastParameter
    fullBrightnessArray[parameter[0]] := parameter[1]
    Led.Set(parameter[0], AdjustBrightness(parameter[1], brightness))   
  elseif strcomp(@InputBuffer, string("COLORS"))        
    parameter[0] := ParseHex(NextParameter)           
    parameter[1] := ParseHex(NextParameter) 
    parameter[2] := ReallyParseHex(NextParameter)    
    CheckLastParameter
    repeat result from parameter[0] to parameter[1]
      fullBrightnessArray[result] := parameter[2]
      Led.Set(result, AdjustBrightness(parameter[2], brightness))   
  elseif strcomp(@InputBuffer, string("DEBUG"))        
    parameter := ParseHex(NextParameter)
    CheckLastParameter
    debugFlag := parameter   
  elseif strcomp(@InputBuffer, string("DECIN"))        
    parameter := ParseHex(NextParameter)
    CheckLastParameter
    decInFlag := parameter
  elseif strcomp(@InputBuffer, string("DECOUT"))        
    parameter := ParseHex(NextParameter)
    CheckLastParameter
    decOutFlag := parameter
  elseif strcomp(@InputBuffer, string("DEMO"))        
    parameter := ParseHex(NextParameter)
    CheckLastParameter
    case Parameter
      -1, $FF:
        demoFlag := $FF
      0..$7F:
        demoFlag := parameter
      other:
        abort @invalidParameter    
  elseif strcomp(@InputBuffer, string("DEMOID"))        
    parameter := ParseHex(NextParameter)
    CheckLastParameter
    activeDemo := parameter 
  elseif strcomp(@InputBuffer, string("DIFF"))        ' TODO: remove
    CheckLastParameter
    OutputHex(midPosition[LEFT_MOTOR] - motorPosition[LEFT_MOTOR], 8)
    OutputChr(" ")                                           
    OutputHex(midPosition[RIGHT_MOTOR] - motorPosition[RIGHT_MOTOR], 8)
  elseif strcomp(@InputBuffer, string("DIST"))        ' Command: Respond with the accumulative distance each motor has traveled, relative to last reset
    CheckLastParameter
    OutputHex(motorPosition[LEFT_MOTOR] + motPosOffset[LEFT_MOTOR], 8)
    OutputChr(" ")
    OutputHex(motorPosition[RIGHT_MOTOR] + motPosOffset[RIGHT_MOTOR], 8)
  
  else
    abort @invalidCommand

  return 0
  
PRI ParseGI | parameter[3]
'' 9 Commands
'' "GO", "GOSPD", "GOX", "HEAD", "HIGH", "HIGHS", "HWVER", "IN", "INS" ' 9

  if strcomp(@InputBuffer, string("GO"))          ' Command: Set the motors to a specified power
    parameter[0] := ParseHex(NextParameter)           '   Read both parameters before processing them
    parameter[1] := ParseHex(NextParameter)           '   To prevent changes with a "Too few parameters" error
    CheckLastParameter
   
    mode := POWER
    if decInFlag
      targetPower[LEFT_MOTOR] := parameter[0] * MAX_POWER / MAX_INPUT_POWER 
      targetPower[RIGHT_MOTOR] := parameter[1] * MAX_POWER / MAX_INPUT_POWER
    else
      targetPower[LEFT_MOTOR] := ~parameter[0] * MAX_POWER / MAX_INPUT_POWER' Then set the motors' powers
      targetPower[RIGHT_MOTOR] := ~parameter[1] * MAX_POWER / MAX_INPUT_POWER
  elseif strcomp(@InputBuffer, string("GOSPD"))         ' Command: Set the motors to a specified power
    parameter[0] := ParseHex(NextParameter)
    parameter[1] := ParseHex(NextParameter)
    CheckLastParameter

    mode := POWER                                   ' Stop PDIteration from modifying mid-positions
    longfill(@activePositionAcceleration, maxPosAccel, 2)
    InterpolateMidVariables 
    if decInFlag
      targetSpeed[LEFT_MOTOR] := parameter[0]           
      targetSpeed[RIGHT_MOTOR] := parameter[1]
    else
      targetSpeed[LEFT_MOTOR] := ~~parameter[0]           ' Then set the motors' powers
      targetSpeed[RIGHT_MOTOR] := ~~parameter[1]
    longfill(@stillCnt, 0, 2)
    mode := SPEED
  elseif strcomp(@InputBuffer, string("GOX"))          ' Command: Set the motors to a specified power
    parameter[0] := ParseHex(NextParameter)           '   Read both parameters before processing them
    parameter[1] := ParseHex(NextParameter)           '   To prevent changes with a "Too few parameters" error
    CheckLastParameter
    
    mode := POWER
    if decInFlag
      targetPower[LEFT_MOTOR] := parameter[0] 
      targetPower[RIGHT_MOTOR] := parameter[1]
    else
      targetPower[LEFT_MOTOR] := ~~parameter[0] 
      targetPower[RIGHT_MOTOR] := ~~parameter[1]
  elseif strcomp(@InputBuffer, string("HEAD"))        ' Command: Respond with the current heading, relative to last reset
    CheckLastParameter
    result := (((motorPosition[LEFT_MOTOR] + motPosOffset[LEFT_MOTOR]) - {
    } (motorPosition[RIGHT_MOTOR] + motPosOffset[RIGHT_MOTOR])) // {
    } Header#POSITIONS_PER_ROTATION) * 360 / Header#POSITIONS_PER_ROTATION
    '''OutputHex((((motorPosition[LEFT_MOTOR] + motPosOffset[LEFT_MOTOR]) - (motorPosition[RIGHT_MOTOR] + motPosOffset[RIGHT_MOTOR])) // POSITIONS_PER_ROTATION) * 360 / POSITIONS_PER_ROTATION, 3)
    OutputHex(result, 3)
    if debugFlag => HEADING_DEBUG
      ExtraHeadingDebug(result)
  elseif strcomp(@InputBuffer, string("HIGH"))          ' Command: Set GPIO pins in mask high
    parameter := ParseHex(NextParameter)
    CheckLastParameter
    outa |= parameter & gpioMask                        '   Change only GPIO pins in mask high
  elseif strcomp(@InputBuffer, string("HIGHS"))         ' Command: return list of high GPIO pins (may be inputs)
    CheckLastParameter
    OutputHex(outa & gpioMask, 8)
  elseif strcomp(@InputBuffer, string("HWVER"))         ' Command: Respond with hardware version number
    CheckLastParameter
    ReadEEPROM(@Parameter, @Parameter + 1, 65534)       ' Read the hardware version from upper EEPROM
    OutputHex(Parameter, 4)
  elseif strcomp(@InputBuffer, string("HZ"))         ' Command: Respond with hardware version number
    parameter := ParseHex(NextParameter)
    CheckLastParameter

    activeParameter := @controlFrequency
    activeParTxtPtr := @controlFrequencyTxt
    controlFrequency := parameter
    halfInterval := clkfreq / controlFrequency / 2
  
  elseif strcomp(@InputBuffer, string("IN"))            ' Command: Set GPIO pins in mask as inputs
    parameter := ParseHex(NextParameter)
    CheckLastParameter
    dira &= !(parameter & gpioMask)                     '   Change only GPIO pins in mask to inputs
  elseif strcomp(@InputBuffer, string("INS"))           ' Command: return list of GPIO inputs
    CheckLastParameter
    OutputHex(!dira & gpioMask, 8)
  
  else
    abort @invalidCommand

  return 0
  
PRI ParseJK | parameter[3]
'' 4 Commands
'' "KID", "KILL", "KIN", "KP" ' 4

  if strcomp(@InputBuffer, string("KID"))        
    parameter[0] := ParseHex(NextParameter) & 1
    parameter[1] := ParseHex(NextParameter) 
    CheckLastParameter
    kIntegralDenominator[parameter[0]] := parameter[1] 
    activeParameter := @kIntegralDenominator + (4 * parameter[0])
    if parameter[0]
      activeParTxtPtr := @kIntegralDenominatorEndTxt
    else
      activeParTxtPtr := @kIntegralDenominatorTxt 
  elseif strcomp(@InputBuffer, string("KILL"))        
    parameter := ParseHex(NextParameter)
    CheckLastParameter
    if decInFlag
      parameter[1] := 0 #> parameter[0] <# MAX_KILL_SWITCH_TIME
    else
      parameter[1] := 0 #> ~~parameter[0] <# MAX_KILL_SWITCH_TIME 
    killSwitchTimer := parameter[1] * MILLISECOND
    lastComTime := cnt
  elseif strcomp(@InputBuffer, string("KIN"))        
    parameter[0] := ParseHex(NextParameter) & 1
    parameter[1] := ParseHex(NextParameter) 
    CheckLastParameter
    kIntegralNumerator[parameter[0]] := parameter[1]
    activeParameter := @kIntegralNumerator + (4 * parameter[0])
    if parameter[0]
      activeParTxtPtr := @kIntegralNumeratorEndTxt
    else
      activeParTxtPtr := @kIntegralNumeratorTxt
  elseif strcomp(@InputBuffer, string("KP"))        
    parameter := ParseHex(NextParameter)
    CheckLastParameter
    kProportional[0] := kProportional[1] := parameter
    activeParameter := @kProportional
    activeParTxtPtr := @kProportionalTxt
  
  else
    abort @invalidCommand

  return 0
  
PRI ParseLN | parameter[3], index
'' 6 Commands
'' "L", "LOW", "LOWS", "LS:, "MIDV", "MM" ' 6

  if strcomp(@InputBuffer, string("L"))           ' Command: Set left motor to a specified power
    parameter[0] := ParseHex(NextParameter)         
    CheckLastParameter
    mode := POWER
    if decInFlag
      targetPower[LEFT_MOTOR] := parameter[0] 
    else
      targetPower[LEFT_MOTOR] := ~~parameter[0]
    activeParameter := @targetPower
    activeParTxtPtr := @targetPowerLTxt  
  elseif strcomp(@InputBuffer, string("LOW"))           ' Command: Set GPIO pins in mask low
    parameter := ParseHex(NextParameter)
    CheckLastParameter                                                                                  
    outa &= !(parameter & gpioMask)                     '   Change only GPIO pins in mask low
  elseif strcomp(@InputBuffer, string("LOWS"))          ' Command: return list of low GPIO pins (may be inputs)
    CheckLastParameter
    OutputHex(!outa & gpioMask, 8)
  elseif strcomp(@InputBuffer, string("LS"))         ' Command: Set left motor to a specified speed
    parameter[0] := ParseHex(NextParameter)
    CheckLastParameter
    mode := POWER                                   ' Stop PDIteration from modifying mid-positions
    longfill(@activePositionAcceleration, maxPosAccel, 2)
    InterpolateMidVariables
    if decInFlag
      targetSpeed[LEFT_MOTOR] := parameter[0]
    else
      targetSpeed[LEFT_MOTOR] := ~~parameter[0]
    longfill(@stillCnt, 0, 2)
    mode := SPEED
    activeParameter := @targetSpeed
    activeParTxtPtr := @targetSpeedLTxt
  elseif strcomp(@InputBuffer, string("MIDV"))        ' TODO: remove
    CheckLastParameter
    OutputHex(midVelocity[LEFT_MOTOR], 8)
    OutputChr(" ")
    OutputHex(midVelocity[RIGHT_MOTOR], 8)
  elseif strcomp(@InputBuffer, string("MM"))
    ' Command: Travel a specified distance in millimeters at a specified speed
    parameter[0] := ParseHex(NextParameter)                                                                     
    parameter[1] := ParseHex(NextParameter)
    CheckLastParameter
   
    ifnot decInFlag
      ~~parameter[0]  ' sign extend if speed entered as hex (four digits hopefully)
      ~parameter[1]

    Travel(parameter[0] * 1000 / Header#MICROMETERS_PER_TICK, parameter[1])

  else
    abort @invalidCommand

  return 0
  
PRI ParseOR | parameter[3], index
'' 8 Commands
'' "OUT", "OUTS", "PING", "PNGD", "PNGP", "PWR" ' 6
'' "R", "READ", "RS", "RST"  ' 2

  if strcomp(@InputBuffer, string("OUT"))           ' Command: Set GPIO pins in mask as outputs
    parameter := ParseHex(NextParameter)
    CheckLastParameter
    dira |= (parameter & gpioMask)                      '   Change only GPIO pins in mask to outputs
  elseif strcomp(@InputBuffer, string("OUTS"))          ' Command: Set GPIO pins in mask as outputs
    CheckLastParameter
    OutputHex(dira & gpioMask, 8)
  elseif strcomp(@InputBuffer, string("PATH"))
    ' Command: Path, the distance each wheel travels is independently specified
    ' The wheel traveling the farthest distance will travel at the specified speed.
    ' The slower wheel's speed will be appropriately reduced.
    ' A negative value of speed is allowed.
    parameter[0] := ParseHex(NextParameter)                                                                     
    parameter[1] := ParseHex(NextParameter)
    parameter[2] := ParseHex(NextParameter)
    CheckLastParameter
   
    ifnot decInFlag
      ~~parameter[0] 
      ~~parameter[1]  
      ~parameter[2]

    if ||parameter[0] > ||parameter[1]
      Travels(parameter[0], parameter[1], parameter[2], parameter[2] * parameter[1] / parameter[0])
    else
      Travels(parameter[0], parameter[1], parameter[2] * parameter[0] / parameter[1], parameter[2])        
  elseif strcomp(@InputBuffer, string("PATHMM"))
    ' Command: Path, the distance (in millimeters) each wheel travels is independently specified
    ' The wheel traveling the farthest distance will travel at the specified speed.
    ' The slower wheel's speed will be appropriately reduced.
    ' A negative value of speed is allowed.
    parameter[0] := ParseHex(NextParameter)                                                                     
    parameter[1] := ParseHex(NextParameter)
    parameter[2] := ParseHex(NextParameter)
    CheckLastParameter
   
    ifnot decInFlag
      ~~parameter[0] 
      ~~parameter[1]  
      ~parameter[2]
    
    if ||parameter[0] > ||parameter[1]
      Travels(parameter[0] * 1000 / Header#MICROMETERS_PER_TICK, parameter[1] * 1000 / {
      } Header#MICROMETERS_PER_TICK, parameter[2], parameter[2] * parameter[1] / parameter[0])
    else
      Travels(parameter[0] * 1000 / Header#MICROMETERS_PER_TICK, parameter[1] * 1000 / {
      } Header#MICROMETERS_PER_TICK, parameter[2] * parameter[0] / parameter[1], parameter[2])        
  elseif strcomp(@InputBuffer, string("PING"))
    ' Command: Respond with status of active PING))) sensors     
    CheckLastParameter
    if pingPauseFlag
      result := pingCount
      ResetPingDriver(pingMask)
      repeat while pingCount == result or pingCount == 0
                 
    repeat index from 0 to maxPingIndex
      OutputHex(pingResults[index], 3)
      if index < maxPingIndex                      
        OutputChr(" ")
  elseif strcomp(@InputBuffer, string("PNGD"))          ' Command: Respond with status of active PING))) sensors
    parameter[0] := ParseHex(NextParameter)
    CheckLastParameter
    pingInterval := parameter[0]
    ResetPingDriver(pingMask)
  elseif strcomp(@InputBuffer, string("PNGP"))          ' Command: Set value of pausePingFlag
    parameter[0] := ParseHex(NextParameter)
    CheckLastParameter
    if pingPauseFlag and parameter[0] == 0
      Ping.Stop
    elseif parameter[0] and pingPauseFlag == 0
      ResetPingDriver(pingMask)
    pingPauseFlag := parameter[0]
  elseif strcomp(@InputBuffer, string("R"))             ' Command: Set right motor to a specified power
    parameter[0] := ParseHex(NextParameter)         
    CheckLastParameter
    mode := POWER
    if decInFlag
      targetPower[RIGHT_MOTOR] := parameter[0] 
    else
      targetPower[RIGHT_MOTOR] := ~~parameter[0]
    activeParameter := @targetPower + 4
    activeParTxtPtr := @targetPowerRTxt  
  elseif strcomp(@InputBuffer, string("READ"))          ' Command: return state of GPIO pins
    CheckLastParameter
    OutputHex(ina & gpioMask, 8)
  elseif strcomp(@InputBuffer, string("RS"))         ' Command: Set left motor to a specified speed
    parameter[0] := ParseHex(NextParameter)
    CheckLastParameter
    mode := POWER                                   ' Stop PDIteration from modifying mid-positions 
    InterpolateMidVariables
    if decInFlag
      targetSpeed[RIGHT_MOTOR] := parameter[0]
    else
      targetSpeed[RIGHT_MOTOR] := ~~parameter[0]
    longfill(@stillCnt, 0, 2)
    mode := SPEED
    activeParameter := @targetSpeed + 4
    activeParTxtPtr := @targetSpeedRTxt
  elseif strcomp(@InputBuffer, string("RST"))         ' Command: Reset heading and accumulated distance
    CheckLastParameter
    
    motPosOffset[LEFT_MOTOR] := -motorPosition[LEFT_MOTOR]
    motPosOffset[RIGHT_MOTOR] := -motorPosition[RIGHT_MOTOR]
    positionErrorFlag[0] := 0
    positionErrorFlag[1] := 0 
 
  else
    abort @invalidCommand

  return 0
  
PRI ParseSZ | parameter[3]
'' 16 Commands
'' "SERVO", "SETV", "SGP", "SMALL", "SONG", "SPD", "SPNG", "STOP" ' 8
'' "TRVL", "TURN", "USE", "VER", "VERB", "VOL", "WATCH", "X" ' 8

  if strcomp(@InputBuffer, string("SERVO"))        
    parameter[0] := ParseHex(NextParameter)
    parameter[1] := ParseHex(NextParameter)      
    CheckLastParameter
    
    result := 1 << parameter[0]
    if result & SERVOABLE
      Servo.Set(parameter[0], parameter[1])
      activeServo := parameter[0]
      servoPosition := parameter[1]
      activeParameter := @servoPosition
      activeParTxtPtr := @servoTxt
      servoTxt[ACTIVE_SERVO_POS_IN_SERVOTXT] := "0" + activeServo ' insert servo #    
    else
      abort @invalidParameter         
  elseif strcomp(@InputBuffer, string("SETV"))        ' TODO: remove
    CheckLastParameter
    OutputHex(targetSpeed[LEFT_MOTOR], 8)
    OutputChr(" ")
    OutputHex(targetSpeed[RIGHT_MOTOR], 8)
  elseif strcomp(@InputBuffer, string("SGP"))           ' Command: Set pins as GPIO pins
    parameter := ParseHex(NextParameter) & OUTPUTABLE   '  Ignore pins that shouldn't be set as GPIO pins
    CheckLastParameter
    if parameter & pingMask                             '  If this affects any active PING))) sensors,
      ResetPingDriver(pingMask &= !parameter)           '    remove them from the list of active PING))) sensors
    gpioMask := parameter                               '  Set the pins as GPIO pins
  elseif strcomp(@InputBuffer, string("SMALL"))        
    parameter := ParseHex(NextParameter)
    CheckLastParameter
    smallChange := parameter
  elseif     strcomp(@InputBuffer, string("SONG"))     ' Command: Play song
    parameter := ParseHex(NextParameter)
    CheckLastParameter
    Header.PlaySong(parameter, tempo)
  elseif     strcomp(@InputBuffer, string("SPD"))     ' Command: Respond with the current motor speeds
    CheckLastParameter
    OutputHex(motorSpeed[LEFT_MOTOR], 4)
    OutputChr(" ")
    OutputHex(motorSpeed[RIGHT_MOTOR], 4)   
  elseif strcomp(@InputBuffer, string("SPNG"))          ' Command: Set pins as PING))) sensor pins
    parameter := ParseHex(NextParameter) & PINGABLE     '   Ignore pins that shouldn't be set as PING))) sensor pins
    CheckLastParameter
    gpioMask &= !parameter                              '   Remove active PING))) sensor pins from GPIO mask
    outa &= !parameter                                  '   Set active PING))) sensor pins as low inputs
    dira &= !parameter                                                                   
    ResetPingDriver(Parameter)                          '   Restart the ReadPulseWidths object, with new PING))) sensor mask
  elseif strcomp(@InputBuffer, string("STOP"))        ' Command: Slow to a stop over a specified distance
    parameter := ParseHex(NextParameter)
    CheckLastParameter
    if parameter
      mode := POWER                                   ' Stop PDIteration from modifying mid-positions 
      InterpolateMidVariables      
      case targetPower[LEFT_MOTOR]
        -1..negx:
          setPosition[LEFT_MOTOR] := motorPosition[LEFT_MOTOR] - parameter
        1..posx:
          setPosition[LEFT_MOTOR] := motorPosition[LEFT_MOTOR] + parameter
        other:
          setPosition[LEFT_MOTOR] := motorPosition[LEFT_MOTOR]
      case targetPower[RIGHT_MOTOR]
        -1..negx:
          setPosition[RIGHT_MOTOR] := motorPosition[RIGHT_MOTOR] - parameter
        1..posx:
          setPosition[RIGHT_MOTOR] := motorPosition[RIGHT_MOTOR] + parameter
        other:
          setPosition[RIGHT_MOTOR] := motorPosition[RIGHT_MOTOR]
      decel[LEFT_MOTOR] := ||(-HALF_SEC * midVelocity[LEFT_MOTOR] * midVelocity[LEFT_MOTOR] / (midVelocity[LEFT_MOTOR] - HALF_SEC * ||(setPosition[LEFT_MOTOR] - motorPosition[LEFT_MOTOR])))
      decel[RIGHT_MOTOR] := ||(-HALF_SEC * midVelocity[RIGHT_MOTOR] * midVelocity[RIGHT_MOTOR] / (midVelocity[RIGHT_MOTOR] - HALF_SEC * ||(setPosition[RIGHT_MOTOR] - motorPosition[RIGHT_MOTOR])))
      longfill(@stillCnt, 0, 2)
      mode := STOPPING
    else                                              '   For a zero stopping distance:
      targetPower[LEFT_MOTOR]~                           '     Disable power to both motors
      targetPower[RIGHT_MOTOR]~
      longfill(@stillCnt, 0, 2)
      mode := POWER                                   '     Set the motors to power mode
  elseif     strcomp(@InputBuffer, string("TEMPO"))     ' Command: Change tempo used to play songs
    parameter := ParseHex(NextParameter)
    CheckLastParameter
    tempo := parameter
  elseif strcomp(@InputBuffer, string("TRVL"))
    ' Command: Travel a specified distance at a specified speed
    parameter[0] := ParseHex(NextParameter)                                                                     
    parameter[1] := ParseHex(NextParameter)
    CheckLastParameter
   
    ifnot decInFlag
      ~~parameter[0]  ' sign extend if parameters entered as hex
      ~parameter[1]
      
    Travel(parameter[0], parameter[1])
              
  elseif strcomp(@InputBuffer, string("TURN"))
    '' Command: Turn a specified number of degrees around a circle of a specified radius
    ' Read both parameters before processing them (and adjust encoder positions per
    ' revolution / 2 wheels)
    parameter[0] := ParseHex(NextParameter) 
    parameter[1] := ParseHex(NextParameter)
       
    CheckLastParameter
    ifnot decInFlag
      ~~parameter[0]
      ~parameter[1]
      
    if parameter[1] < 0
      abort @invalidParameter
      
    Travels(parameter[0] * Header#POSITIONS_PER_ROTATION / 720, {
    } parameter[0] * Header#POSITIONS_PER_ROTATION / -720, parameter[1], parameter[1])
 
  elseif strcomp(@InputBuffer, string("USE"))          ' Command: Set verbose mode
    parameter := ParseHex(NextParameter)
    CheckLastParameter
    speedToUse := parameter
  elseif strcomp(@InputBuffer, string("VER"))           ' Command: Respond with version number
    CheckLastParameter
    OutputHex(VERSION, 4)
  elseif strcomp(@InputBuffer, string("VERB"))          ' Command: Set verbose mode
    parameter := ParseHex(NextParameter)
    CheckLastParameter
    case Parameter
      0..1:
        verbose := parameter
      other:
        abort @invalidParameter
  elseif     strcomp(@InputBuffer, string("VOL")) ' Command: Change volume used when playing songs
    Parameter := ParseHex(NextParameter)
    CheckLastParameter
    volume := 0 #> Parameter <#100
    Header.SetVolume(volume)
  elseif strcomp(@InputBuffer, string("WATCH"))         ' Command: Set number of seconds to use
                                                        ' in watch mode
    parameter := ParseHex(NextParameter)
    CheckLastParameter
    case parameter
      0..MAX_KILL_SWITCH_SECONDS:
        killSwitchTimer := parameter * clkfreq  
      other:
        abort @invalidParameter
  elseif strcomp(@InputBuffer, string("X"))             ' Command: Stop the motors now.
    targetPower[LEFT_MOTOR] := 0
    targetPower[RIGHT_MOTOR] := 0
    targetSpeed[LEFT_MOTOR] := 0
    targetSpeed[RIGHT_MOTOR] := 0
    mode := POWER
    InterpolateMidVariables
    CheckLastParameter
    targetPower[LEFT_MOTOR] := 0
    targetPower[RIGHT_MOTOR] := 0
    targetSpeed[LEFT_MOTOR] := 0
    targetSpeed[RIGHT_MOTOR] := 0        
  else
    abort @invalidCommand

  return 0
     
PRI Arc(arcDegrees, scaledArcCircumference, arcSpeed) | scaledArcRatioOuter, {
} scaledArcRatioInner, scaledVInside, scaledVOutside, arcDistanceInside, arcDistanceOutside
   
  if scaledArcCircumference == 0
    abort @invalidParameter
  elseif scaledArcCircumference < 0
    -arcSpeed
    -scaledArcCircumference

  arcDistanceInside := ||arcDegrees * (scaledArcCircumference - {
  } SCALED_ROBOT_CIRCUMFERENCE) / SCALED_CIRCLE
  arcDistanceOutside := ||arcDegrees * (scaledArcCircumference + {
  } SCALED_ROBOT_CIRCUMFERENCE) / SCALED_CIRCLE
  ' distances may have different signs

  scaledArcRatioOuter := (SCALED_MULTIPLIER * (scaledArcCircumference + {
  } SCALED_ROBOT_CIRCUMFERENCE)) / scaledArcCircumference 
  scaledArcRatioInner := (SCALED_MULTIPLIER * (scaledArcCircumference - {
  } SCALED_ROBOT_CIRCUMFERENCE)) / scaledArcCircumference 
  ' Since "scaledArcCircumference" is always positive, the outer wheel will always have
  ' farther to travel (and have to turn faster) than the inner wheel .
  scaledVOutside := -SCALED_MAX_ARC_SPEED #> scaledArcRatioOuter * arcSpeed <# {
  } SCALED_MAX_ARC_SPEED
  arcSpeed := scaledVOutside / scaledArcRatioOuter
  scaledVInside := scaledArcRatioInner * arcSpeed
    
  if arcDegrees > 0 '' turn right
    Travels(arcDistanceOutside, arcDistanceInside, scaledVOutside / SCALED_MULTIPLIER, {
    } scaledVInside / SCALED_MULTIPLIER)
  else
    Travels(arcDistanceInside, arcDistanceOutside, scaledVInside / SCALED_MULTIPLIER, {
    } scaledVOutside / SCALED_MULTIPLIER)

PRI Travel(distance, travelSpeed)

  if speed < 0 ' only allow positive speeds. Use negative distance to go backward.
    abort @invalidParameter

  Travels(distance, distance, travelSpeed, travelSpeed)

PRI Travels(distanceLeft, distanceRight, speedLeft, speedRight)

  if speedLeft < 0 
    -speedLeft
    -distanceLeft
  if speedRight < 0
    -speedRight
    -distanceRight

  mode := POWER               ' Stop PDIteration from modifying mid-positions 
  InterpolateMidVariables

  longmove(@targetSpeed, @speedLeft, 2)
  
  setPosition[LEFT_MOTOR] := midPosition[LEFT_MOTOR] + distanceLeft 
  setPosition[RIGHT_MOTOR] := midPosition[RIGHT_MOTOR] + distanceRight
  
  if speedLeft > speedRight
    activePositionAcceleration[LEFT_MOTOR] := maxPosAccel
    activePositionAcceleration[RIGHT_MOTOR] := maxPosAccel * speedRight / speedLeft
  elseif speedLeft < speedRight
    activePositionAcceleration[LEFT_MOTOR] := maxPosAccel * speedLeft / speedRight
    activePositionAcceleration[RIGHT_MOTOR] := maxPosAccel  
  else
    longfill(@activePositionAcceleration, maxPosAccel, 2)
     
  longfill(@stillCnt, 0, 2)

  repeat result from LEFT_MOTOR to RIGHT_MOTOR
    if distanceLeft[result] < 0
      direction[result] := -1
    else
      direction[result] := 1
  
  mode := POSITION
     
PRI ExtraHeadingDebug(heading)
 
  Com.Strs(debugCom, string(11, 13, "Heading = ((("))
  Com.Dec(debugCom, motorPosition[LEFT_MOTOR])
  Com.Str(debugCom, string(" + "))
  Com.Dec(debugCom, motPosOffset[LEFT_MOTOR])
  Com.Str(debugCom, string(") - ("))
  Com.Dec(debugCom, motorPosition[RIGHT_MOTOR])
  Com.Str(debugCom, string(" + "))
  Com.Dec(debugCom, motPosOffset[RIGHT_MOTOR])
   
  Com.Str(debugCom, string(")) // "))
  Com.Dec(debugCom, Header#POSITIONS_PER_ROTATION)
  Com.Str(debugCom, string(") * 360 / "))
  Com.Dec(debugCom, Header#POSITIONS_PER_ROTATION)
  Com.Str(debugCom, string(11, 13, " = "))
  Com.Dec(debugCom, heading)
        
  Com.Tx(debugCom, 11) ' clear end
  Com.Txe(debugCom, 13)

PRI InterpolateMidVariables : side | difference  ' called from parsing cog
'' Sets midVelocity and midPosition variables to values that would create the current
'' targetPower at the current motorPosition

  bytefill(@midReachedSetFlag, 0, 2)
  longfill(@gDifference, 0, 2)
  longfill(@midVelAcc, 0, 2)
  longfill(@midPosAcc, 0, 2)
  longmove(@midPosition, @motorPosition, 2)
  longmove(@midVelocity, @motorSpeed, 2)
  
  {repeat side from LEFT_MOTOR to RIGHT_MOTOR
  
    ' Determine midPosition to motorPosition offset
    if difference := targetPower[side] / kProportional[side]                
      if difference => DEADZONE   ' Adjust for the deadzone   
        difference -= DEADZONE 
      elseif difference =< -DEADZONE
        difference += DEADZONE  
      midPosition[side] := motorPosition[side] + difference
      ' Add it back to the current Motor Position
    else 
      midPosition[side] := motorPosition[side] 

    ' Set the midVelocity to the current motor speed
    midVelocity[side] := motorSpeed[LEFT_MOTOR]  }

    
PRI PDLoop : side | nextControlCycle
'' Measure, set, and maintain wheel position

  if Header#REVERSE_LEFT_FLAG
    Encoders.ReverseMotor(LEFT_MOTOR)
  if Header#REVERSE_RIGHT_FLAG
    Encoders.ReverseMotor(RIGHT_MOTOR)
    
  Encoders.StartEncoders(@encoderPin, @motorPosition, @transitionTime, @enablePin, {
  } @positiveDirectionPin, @negativeDirectionPin, @rampedPower, @encoderDirection)
              
  'Encoders.Start(Header#ENCODERS_PIN, 2, 0, @motorPosition)

  'Header.StartMotors
  
  nextControlCycle := cnt                                        ' Set up a timed loop
  repeat
    repeat side from LEFT_MOTOR to RIGHT_MOTOR
      waitcnt(nextControlCycle += DEFAULT_HALF_INTERVAL)
      PDIteration(side)                ' Service 
      'Header.SetMotorPower(side, rampedPower[side])
      Encoders.RefreshPower
    bufferIndex++
    bufferIndex //= POSITION_BUFFER_SIZE
    
PRI PDIteration(side) | motorPositionSample, difference, limit, previousReachedFlag
'' Read the wheel's speed and position, and set its power
'' The power is set by use of a global variable "rampedPower".
  
  motorPositionSample := motorPosition[side] ' Sample at the beginning to remove jitter
 
  eddieSpeed[side] := motorPositionSample - motorPositionBuffer[side * POSITION_BUFFER_SIZE + bufferIndex]
  motorPositionBuffer[side * POSITION_BUFFER_SIZE + bufferIndex] := motorPositionSample

  ComputeEncoderSpeed(side)
  if speedToUse == EDDIE_SPEED
    motorSpeed[side] := eddieSpeed[side]
  else
    motorSpeed[side] := currentSpeed[side]
    
  if motorSpeed[side] or rampedPower[side] == 0  ' Keep track of how long the motor hasn't been moving
    stillCnt[side] := 0
  else
    stillCnt[side]++
    stillCnt[side] <#= CONTROL_FREQUENCY * SECONDS_UNTIL_SHUTDOWN
    
  ' Keep the mid point from traveling too far away from the current motor position     
  difference := midPosition[side] - motorPositionSample

  ' Check to see if offset is higher than it should be for the current power level (When motor is moving)
  ' dwd 141225c I don't understand the code below.
  if ||difference > SAFEZONE and ||difference > ||targetPower[side] / kProportional[side] + {
    } DEADZONE
    ' If so, bring the set point closer to the physical position
    ' MidPosition equals MotorPositionSample approaching MidPosition, as limited by SetPower / Kp + DEADZONE
    midPosition[side] := motorPositionSample - (-(targetPower[side] / kProportional[side] + {
      } DEADZONE) #> -difference <# (targetPower[side] / kProportional[side] + DEADZONE))
    
  if stillCnt[side] => CONTROL_FREQUENCY * SECONDS_UNTIL_SHUTDOWN and {
    } midReachedSetFlag[side] == 0
    ' If the motor hasn't moved (when it was supposed to) shut off power to motor
    targetPower[side] := 0
    targetSpeed[side] := 0
    midPosition[side] := motorPositionSample
    positionDifference[side] := difference  
    positionErrorFlag[side] := 1
          
         
  case mode                     ' Set motor power based on current control method
    POWER:                      ' Run the motors at a set power level
      ' rampedPower approaches targetPower as limited by maxPowAccel
      'stillCnt[side] := 0 ' in POWER mode, we don't care if we've been sitting still?
      rampedPower[side] += -maxPowAccel #> (targetPower[side] - rampedPower[side]) <# maxPowAccel
      
    SPEED:                      ' Maintain the motors at a set velocity
      ' midVelocity / HALF_SEC approaches targetSpeed as limited by maxPosAccel
      midVelAcc[side] += -activePositionAcceleration[side] #> {
      }(targetSpeed[side] - midVelocity[side]) * HALF_SEC - midVelAcc[side] {
      } <# activePositionAcceleration[side]
      midVelocity[side] += midVelAcc[side] / HALF_SEC
      midVelAcc[side] //= HALF_SEC

      ' midPosition / HALF_SEC increases by midVelocity / 25 positions per half second
      midPosAcc[side] += midVelocity[side]                             
      midPosition[side] += midPosAcc[side] / HALF_SEC
      midPosAcc[side] //= HALF_SEC

      ' Measure motors physical distance from the set point
      difference := midPosition[side] - motorPositionSample

      if difference => DEADZONE                         ' Adjust for the deadzone   
        difference -= DEADZONE
      elseif difference =< -DEADZONE
        difference += DEADZONE
      else
        difference~

      ' targetPower is proportional to the motors physical distance from the set point,
      ' limited by MAX_POWER
     
      targetPower[side] := MIN_POWER #> difference * kProportional[side] <# MAX_POWER

      ' rampedPower approaches targetPower as limited by maxPowAccel
      rampedPower[side] += -maxPowAccel #> (targetPower[side] - rampedPower[side]) <# maxPowAccel

    STOPPING:                   ' Slow to a stop at a set position
      ' midPosition / HALF_SEC approaches setPosition as limited by the deceleration curve
      ' dwd 141118b, HALF_SEC is the value 25 since the control cycle occurs 50 times a second
      ' there are 25 control cycles in half a second.
     
      limit := ^^(constant(8 * HALF_SEC * HALF_SEC) * (setPosition[side] - midPosition[side])/ decel ) * decel / 2
      midPosAcc[side] += -limit #> (setPosition[side] - midPosition[side]) * constant(HALF_SEC * HALF_SEC) + midPosAcc[side] <# limit
      midPosition[side] += midPosAcc[side] / constant(HALF_SEC * HALF_SEC)
      midPosAcc[side] //= constant(HALF_SEC * HALF_SEC)

      ' Measure motors physical distance from the set point
      difference := midPosition[side] - motorPositionSample

      if difference => DEADZONE                         ' Adjust for the deadzone   
        difference -= DEADZONE
      elseif difference =< -DEADZONE
        difference += DEADZONE
      else
        difference~

      ' targetPower is proportional to the motors physical distance from the set point,
      ' limited by MAX_POWER
      targetPower[side] := MIN_POWER #> difference * kProportional[side] <# MAX_POWER

      ' rampedPower approaches targetPower as limited by maxPowAccel
      rampedPower[side] += -maxPowAccel #> (targetPower[side] - rampedPower[side]) <# maxPowAccel
  
    POSITION:                ' Travel to a set position
         
      ' Measure motors physical distance from the set point

      ' midVelocity / HALF_SEC approaches targetSpeed as limited
      'by maxPosAccel / CONTROL_FREQUENCY
      midVelAcc[side] += -activePositionAcceleration[side] #> {
      } (targetSpeed[side] - midVelocity[side]) * HALF_SEC - midVelAcc[side] <# {
      } activePositionAcceleration[side]
      
      midVelocity[side] += midVelAcc[side] / HALF_SEC 
      midVelAcc[side] //= HALF_SEC 
       
      ' midPosition approaches setPosition as limited by the deceleration curve
      gLimit[side] := limit := midVelocity[side] * HALF_SEC + midVelAcc[side] {
      }<# ^^(constant(8 * HALF_SEC * HALF_SEC) * (setPosition[side] - midPosition[side])/ {
      } activePositionAcceleration[side]) * activePositionAcceleration[side] / 2

      midPosAcc[side] += -limit #> (setPosition[side] - midPosition[side]) * {
      } constant(HALF_SEC * HALF_SEC) + midPosAcc[side] <# limit
      
      midPosition[side] += midPosAcc[side] / constant(HALF_SEC * HALF_SEC)
      midPosAcc[side] //= constant(HALF_SEC * HALF_SEC)
         
      ' Measure motors physical distance from the set point
      previousDifference[side] := gDifference[side]

      if midReachedSetFlag[side]
        gDifference[side] := difference := setPosition[side] - MotorPositionSample
    
      else
        gDifference[side] := difference := midPosition[side] - MotorPositionSample
      previousReachedFlag := midReachedSetFlag[side]
      ' The "g" in "gDifference" stands for "global" I wanted a global variable
      ' as a debugging aid.
      
      if midPosition[side] == setPosition[side] or midReachedSetFlag[side]
        midReachedSetFlag[side] := 1 ' The "midPosition" can change so make sure the
        ' target position stays the same.
        ifnot previousReachedFlag
          integral[side] := 0 ' start fresh with integral
        if ||gDifference[side] > Header#TOO_SMALL_TO_FIX
          integral[side] += gDifference[side] 
        else
          integral[side] := 0
          difference := 0
          activePositionAcceleration[side] := maxPosAccel ' reset to standard acceleration
      else
        
        integral[side] += gDifference[side] ' This made things worse.
        'integral[side] := 0
        
      ' targetPower is proportional to the motors physical distance from the set point,
      ' limited by MAX_POWER
      '''targetPower[side] := -MAX_ON_TIME #> difference * kP <# MAX_ON_TIME
      newPowerTarget[side] := (difference * kProportional[side]) + {
      } (integral[side] * kIntegralNumerator[midReachedSetFlag[side]] / kIntegralDenominator[midReachedSetFlag[side]])
      targetPower[side] := MIN_POWER #> newPowerTarget[side] <# MAX_POWER

      ' rampedPower approaches targetPower as limited by maxPowAccel
      rampedPower[side] += -maxPowAccel #> (targetPower[side] - rampedPower[side]) {
      } <# maxPowAccel

    other: ' Invalid state
      rampedPower[side] := 0 ' Stop the motor
      targetPower[side] := 0
      targetSpeed[side] := 0

PRI ResetPingDriver(newMask) '' Restart the PING))) driver with a new set of pins

  pingMask := newMask & PINGABLE                        ' Only use allowed pins
  gpioMask &= !pingMask                                 ' Remove used pins from GPIO set
 
  Ping.Start(pingMask, pingInterval, @pingResults)
  ' Continuously trigger and read pulse widths on PING))) pins
  
  pingsInUse := Ping.GetPingsInUse
  maxPingIndex := pingsInUse - 1
  if pingPauseFlag
    pingPauseFlag := 0

PRI NextParameter                                       '' Condition the next input parameter and return its pointer

  repeat until ++parseIndex => inputIndex               ' Ignore whitespace
    case inputBuffer[parseIndex]                        ' First character is always whitespace
      0, HT, " ":
      other:
        quit                                            ' parseIndex points to first non-whitespace character
  if parseIndex => inputIndex                           ' If at the end of the buffer (or passed it, just in case)
    abort @tooFewParameters                             '  then there are no more parameters
  result := @inputBuffer[parseIndex]                    ' When responding, point to the next parameter,

  repeat parseIndex from parseIndex to inputIndex - 1   ' But first...
    case inputBuffer[parseIndex]                         
      NUL, HT, " " :                                    '  Null terminate the parameter           
        inputBuffer[parseIndex]~
        quit
      "a".."z" :                                        '  Set all command characters to uppercase
        inputBuffer[parseIndex] -= constant("a" - "A")

PRI CheckLastParameter                                  '' Abort if there are any unparsed input parameters

  repeat until (inputBuffer[parseIndex] <> 0 and inputBuffer[parseIndex] <> " " and inputBuffer[parseIndex] <> HT) or parseIndex == inputIndex - 1
    ++parseIndex

  ifnot parseIndex == inputIndex - 1                    '   Ensure that there are no further arguments           
    abort @tooManyParameters                            '   To prevent changes with a "Too many parameters" error

PRI ParseHex(pointer)                       '' Interpret an ASCII string

  if decInFlag
    result := ParseDec(pointer)
  else
    result := ReallyParseHex(pointer)
  
PRI ParseDec(pointer) | character, sign                       '' Interpret an ASCII decimal string

  sign := 1
  if debugFlag => PARSE_DEC_DEBUG
    Com.Strse(debugCom, string(11, 13, "ParseDec"))
  repeat 11
    if debugFlag => PARSE_DEC_DEBUG
      Com.Strs(debugCom, string(", byte[] ="))
      SafeTx(debugCom, byte[pointer])
      Com.E
    case character := byte[pointer++]
      NUL:
        result *= sign
        return result
      "0".."9" :
        result := (result * 10) + (character - "0")
      "-" :
        sign := -1
     
      other :
        abort @invalidParameter
        
  result *= sign
  
  if byte[pointer]                                      ' Make sure there are no remaining characters after parsing first eight.                        
    abort @invalidParameter

PRI ReallyParseHex(pointer) | character                 '' Interpret an ASCII hexadecimal string

  repeat 8
    case character := byte[pointer++]
      NUL:
        return result
      "0".."9" :
        result := result << 4 + character - "0"
      "A".."F" :
        result := result << 4 + character - constant("A" - 10)
      "a".."f" :
        result := result << 4 + character - constant("a" - 10)
      other :
        abort @invalidParameter

  if byte[pointer]                                      ' Make sure there are no remaining characters after parsing first eight.                        
    abort @invalidParameter

PRI OutputChr(char)                                     '' Add a character to the output buffer

  if outputIndex < BUFFER_LENGTH - 3
    outputBuffer[outputIndex++] := char
    outputBuffer[outputIndex]~
  
PRI OutputStr(pointer)                                  '' Concatenate a string to the end of the output buffer

  if strsize(pointer) + 1 =< BUFFER_LENGTH - outputIndex                        ' Check for overflow
    bytemove(@outputBuffer + outputIndex, pointer, strsize(pointer) + 1)        ' Copy the string to the buffer, including the terminator
    outputIndex += strsize(pointer)                                             ' Increment the output buffer index by the length of the sting, not including the terminator

PRI OutputDec(value) | i, x                             '' Create a decimal string and concatenate the end of the output buffer
'' Print a decimal number

  x := value == negx                                    ' Check for max negative
  if value < 0
    value := ||(value + x)                              ' If negative, make positive; adjust for max negative
    OutputChr("-")                                      ' and output sign

  i := 1_000_000_000                                    ' Initialize CONTROL_FREQUENCY

  repeat 10                                             ' Loop for 10 digits
    if value => i                                                               
      OutputChr(value / i + "0" + x * (i == 1))         ' If non-zero digit, output digit; adjust for max negative
      value //= i                                       ' and digit from value
      result~~                                          ' flag non-zero found
    elseif result or i == 1
      OutputChr("0")                                    ' If zero digit (or only digit) output it
    i /= 10                                             ' Update CONTROL_FREQUENCY

PRI OutputHex(value, digits)                            '' Create a hexadecimal string and concatenate the end of the output buffer

'' Print a hexadecimal number

  if decOutFlag
    OutputDec(value)
    return
    
  if outputIndex < BUFFER_LENGTH - digits - 2
    value <<= (8 - digits) << 2
    repeat digits    
      outputBuffer[outputIndex++] := lookupz((value <-= 4) & $F : "0".."9", "A".."F")
    outputBuffer[outputIndex]~

PRI Rx(port)

  {if port == ALT_COM
    return '**141220d 
    '**141220d AltCom.Lock
    '**141220d result := AltCom.Rx(0)
    '**141220d AltCom.E
  else
  }
    Com.Lock  
    result := Com.Rx(port)
    Com.E
    
PRI SendResponse                                        '' Transmit the string in the output buffer and clear the buffer

  result := outputIndex <# OUTPUT_COPY_BUFFER_SIZE
  
  {if controlCom == ALT_COM
    return '**141220d 
    '**141220d AltCom.Lock
    '**141220d AltCom.Str(0, @outputBuffer)                               ' Transmit the buffer contents
    '**141220d AltCom.Stre(0, @prompt)                                     ' Transmit the prompt
  else }
  Com.Lock
  Com.Str(controlCom, @outputBuffer)                    ' Transmit the buffer contents
  Com.Stre(controlCom, @prompt)                         ' Transmit the prompt
  inputIndex := 0                                       ' Clear the buffers
  '** Why clear inputIndex here?
  
  outputBuffer := 0                                     ' is this needed?
  outputIndex := 0
  result := 0

PRI ReadEEPROM(startAddr, endAddr, eeStart) | addr

  ''Copy from EEPROM beginning at eeStart address to startAddr..endAddr in main RAM.
  
  SetAddr(eeStart)                                      ' Set EEPROM's address pointer 
  i2cstart
  SendByte(%10100001)                                   ' EEPROM I2C address + read operation
  if startAddr == endAddr
    addr := startAddr
  else
    repeat addr from startAddr to endAddr - 1           ' Main RAM index startAddr to endAddr
      byte[addr] := GetByte                             ' GetByte byte from EEPROM & copy to RAM 
      SendAck(I2C_ACK)                                  ' Acknowledge byte received
  byte[addr] := GetByte                                 ' GetByte byte from EEPROM & copy to RAM 
  SendAck(I2C_NACK)
  i2cstop                                               ' Stop sequential read
  
PRI WriteEEPROM(startAddr, endAddr, eeStart) | addr, page, eeAddr

  ''Copy startAddr..endAddr from main RAM to EEPROM beginning at eeStart address.

  addr := startAddr                                     ' Initialize main RAM index
  eeAddr := eeStart                                     ' Initialize EEPROM index
  repeat
    page := addr +PAGE_SIZE -eeAddr // PAGE_SIZE <# endaddr +1 ' Find next EEPROM page boundary
    SetAddr(eeAddr)                                     ' Give EEPROM starting address
    repeat                                              ' Bytes -> EEPROM until page boundary
      SendByte(byte[addr++])
    until addr == page
    i2cstop                                             ' From 24LC256's page buffer -> EEPROM
    eeaddr := addr - startAddr + eeStart                ' Next EEPROM starting address
  until addr > endAddr                                  ' Quit when RAM index > end address

PRI SetAddr(addr) : ackbit

  'Sets EEPROM internal address pointer.

  ' Poll until acknowledge.  This is especially important if the 24LC256 is copying from buffer to EEPROM.
  ackbit~~                                              ' Make acknowledge 1
  repeat                                                ' Send/check acknowledge loop
    i2cstart                                            ' Send I2C start condition
    ackbit := SendByte(%10100000)                       ' Write command with EEPROM's address
  while ackbit                                          ' Repeat while acknowledge is not 0

  SendByte(addr >> 8)                                   ' Send address high byte
  SendByte(addr)                                        ' Send address low byte

PRI I2cStart

  ' I2C start condition.  SDA transitions from high to low while the clock is high.
  ' SCL does not have the pullup resistor called for in the I2C protocol, so it has to be
  ' set high. (It can't just be set to inSendByte because the resistor won't pull it up.)

  dira[SCL]~                                            ' SCL pin outSendByte-high
  dira[SDA]~                                            ' Let pulled up SDA pin go high
  dira[SDA]~~                                           ' SDA -> outSendByte for SendByte method

PRI I2cStop

  ' Send I2C stop condition.  SCL must be high as SDA transitions from low to high.
  ' See note in i2cStart about SCL line.

  dira[SDA]~~
  dira[SCL]~                                            ' SCL -> high
  dira[SDA]~                                            ' SDA -> inSendByte GetBytes pulled up
  
PRI SendAck(ackbit)

  ' Transmit an acknowledgment bit (ackbit).

  dira[SDA] := !ackbit                                  ' Set SDA output state to ackbit
  dira[SDA]~~                                           ' Make sure SDA is an output
  dira[SCL]~                                            ' Send a pulse on SCL
  dira[SCL]~~
  dira[SDA]~                                            ' Let go of SDA

PRI GetAck : ackbit

  ' GetByte and return acknowledge bit transmitted by EEPROM after it receives a byte.
  ' 0 = I2C_ACK, 1 = I2C_NACK.

  dira[SDA]~                                            ' SDA -> SendByte so 24LC256 controls
  dira[SCL]~                                            ' Start a pulse on SCL
  ackbit := ina[SDA]                                    ' GetByte the SDA state from 24LC256
  dira[SCL]~~                                           ' Finish SCL pulse
  dira[SDA]~~                                           ' SDA -> outSendByte, master controls
  
PRI SendByte(b) : ackbit | i

  ' Shift a byte to EEPROM, MSB first.  Return if EEPROM acknowledged.  Returns
  ' acknowledge bit.  0 = I2C_ACK, 1 = I2C_NACK.

  b ><= 8                                               ' Reverse bits for shifting MSB right
  dira[SCL]~~                                           ' SCL low, SDA can change
  repeat 8                                              ' 8 reps sends 8 bits
    dira[SDA] := !b                                     ' Lowest bit sets state of SDA
    dira[SCL]~                                          ' Pulse the SCL line
    dira[SCL]~~
    b >>= 1                                             ' Shift b right for next bit
  ackbit := GetAck                                      ' Call GetByteAck and return EEPROM's Ack

PRI GetByte : value

  ' Shift in a byte, MSB first.  

  value~                                                ' Clear value
  dira[SDA]~                                            ' SDA input so 24LC256 can control
  repeat 8                                              ' Repeat shift in eight times
    dira[SCL]~                                          ' Start an SCL pulse
    value <-= 1                                         ' Shift the value left
    value |= ina[SDA]                                   ' Add the next most significant bit
    dira[SCL]~~                                         ' Finish the SCL pulse

PUB AdjustAndSet(colorPtr, localBrightness, size)

  size--
  repeat result from 0 to size
    Led.set(result, AdjustBrightness(long[colorPtr][result], localBrightness))
  
PUB AdjustBrightness(color, localBrightness) | localIndex, temp

  repeat localIndex from 0 to 2
    'byte[@result][localIndex] := byte[@color][localIndex] * localBrightness / 255  'doesn't work
    temp := byte[@color][localIndex] * localBrightness / 255
    byte[@result][localIndex] := temp
    
PUB OrColors(firstLed, lastLed, localColor) : colorIndex
  
  firstLed := 0 #> firstLed <# MAX_LED_INDEX
  lastLed := 0 #> lastLed <# MAX_LED_INDEX

  repeat colorIndex from firstLed to lastLed
    fullBrightnessArray[colorIndex] |= localColor

PUB TtaMethodSigned(N, X, D)   ' return X*N/D where all numbers and result are positive =<2^31

  result := 1
  if N < 0
    -N
    -result
  if X < 0
    -X
    -result
  if D < 0
    -D
    -result
    
  result *= TtaMethod(N, X, D)

PUB TtaMethod(N, X, D)   ' return X*N/D where all numbers and result are positive =<2^31
  return (N / D * X) + (binNormal(N//D, D, 31) ** (X*2))

PUB BinNormal (y, x, b) : f                  ' calculate f = y/x * 2^b
' b is number of bits
' enter with y,x: {x > y, x < 2^31, y <= 2^31}
' exit with f: f/(2^b) =<  y/x =< (f+1) / (2^b)
' that is, f / 2^b is the closest appoximation to the original fraction for that b.
  repeat b
    y <<= 1
    f <<= 1
    if y => x    '
      y -= x
      f++
  if y << 1 => x    ' Round off. In some cases better without.
      f++

PRI ComputeEncoderSpeed(channelIndex) '| adjustmentBits, adjustedTime 
'' A "Period" is a half second amount of time.
'' A "Cycle" is a full encoder cycle
'' Todo count times a full cycle isn't received.
'' Switch from full cycle monitoring to single tick
'' monitoring at very low speeds.
'' The data produced by this method is presently not
'' used by the program.

  'adjustmentBits := INITIAL_BIT_ADJUSTMENT
  
  altDataPtr[channelIndex] := Encoders.GetPointer(channelIndex)
  {The act of requesting the pointer changes the address where
  future writes will occur. This keeps the data located at
  the returned pointer from being overwritten by the encoder
  reading cog.
  Data from the buffer may now be read without concern of it
  being overwritten.
  Both the last transition count with time and last full cycle
  count with time are written to the buffer.
  Encoder which aren't precisely 90 degrees out of phase
  should benifit from being monitored by full cycles.}
  
  alternatingEncoder[channelIndex] := long[altDataPtr[channelIndex]]
  alternatingTimeStamp[channelIndex] := long[altDataPtr[channelIndex] + 4]
  alternatingFullCycle[channelIndex] := long[altDataPtr[channelIndex] + 8]
  fullCycleTimeStamp[channelIndex] := long[altDataPtr[channelIndex] + 12]
  
  alternatingDeltaTime[channelIndex] := alternatingTimeStamp[channelIndex] - previousTimeStamp[channelIndex]
  deltaPosition[channelIndex] := alternatingEncoder[channelIndex] - previousPosition[channelIndex]

  if deltaPosition[channelIndex] and rampedPower[channelIndex]
    stoppedMotorCount[channelIndex] := 0
    currentSpeed[channelIndex] := ComputeSpeed(alternatingDeltaTime[channelIndex], {
    } deltaPosition[channelIndex])
  else
    stoppedMotorCount[channelIndex]++
    currentSpeed[channelIndex] := 0

  halfSecondDeltaPosition[channelIndex] := alternatingEncoder[channelIndex] - {
  } positionBuffer[POSITION_BUFFER_SIZE * channelIndex + bufferIndex]
  positionBuffer[POSITION_BUFFER_SIZE * channelIndex + bufferIndex] := alternatingEncoder[channelIndex]
   
  halfSecondDeltaTime[channelIndex] := alternatingTimeStamp[channelIndex] - {
  } timeBuffer[POSITION_BUFFER_SIZE * channelIndex + bufferIndex]
  timeBuffer[POSITION_BUFFER_SIZE * channelIndex + bufferIndex] := alternatingTimeStamp[channelIndex]
  
  
  ' The value "10" reduces the values sent to "ComputeSpeed" method to manageable
  ' amounts. This is a hack and should be improved.
  bufferedSpeed[channelIndex] := ComputeSpeed(halfSecondDeltaTime[channelIndex] / 10, {
    } halfSecondDeltaPosition[channelIndex] / 10)
    
  previousTimeStamp[channelIndex] := alternatingTimeStamp[channelIndex]
  previousPosition[channelIndex] := alternatingEncoder[channelIndex]

PRI ComputeSpeed(deltaTime, localDeltaPosition) 

  result := TtaMethodSigned(SPEED_NUMERATOR, localDeltaPosition, deltaTime * {
  } ADJ_TO_TICKS_PER_HALF_SECOND)

DAT

prompt                          byte CR, 0
checkSumPrompt
'nullString                      byte 0
nack                            byte "ERROR", 0
overflow                        byte " - Overflow", 0
badChecksum                     byte " - Bad checksum", 0
invalidCommand                  byte " - Invalid command", 0
invalidParameter                byte " - Invalid parameter", 0
tooFewParameters                byte " - Too few parameters", 0
tooManyParameters               byte " - Too many parameters", 0
encoderError                    byte " - Encoder error", 0
'nonCommand                      byte " - Nothing happens", 0

''' Used by DebugTemp
modeAsText                      byte "POWER", 0
                                byte "SPEED", 0
                                byte "STOPPING", 0
                                byte "POSITION", 0
                                byte "ARC_POSITION", 0

kpControlTypeTxt                byte "TARGET_DEPENDENT", 0
                                byte "CURRENT_SPEED_DEPENDENT", 0
                                
comTxt                          byte "USB_COM", 0
                                byte "XBEE_COM", 0
                                byte "NO_ACTIVE_COM", 0

speedToUseTxt                   byte "EXPERIMENTAL_SPEED", 0
                                byte "EDDIE_SPEED", 0                               
' Active Parameter Text
maxPowAccelTxt                  byte "maxPowAccel", 0 
maxPosAccelTxt                  byte "maxPosAccel", 0

kProportionalTxt                byte "kProportional", 0
kProportionalRightTxt           byte "kProportionalRight", 0
kProportionalLeftTxt            byte "kProportionalLeft", 0  

kIntegralDenominatorTxt         byte "kIntegralDenominator", 0
kIntegralDenominatorEndTxt      byte "kIntegralDenominator[END]", 0
kIntegralNumeratorTxt           byte "kIntegralNumerator", 0
kIntegralNumeratorEndTxt        byte "kIntegralNumerator[END]", 0
  
servoTxt                        byte "servo #   ", 0
targetPowerLTxt                 byte "targetPower[LEFT]", 0
targetPowerRTxt                 byte "targetPower[RIGHT]", 0
targetSpeedLTxt                 byte "targetSpeed[LEFT]", 0
targetSpeedRTxt                 byte "targetSpeed[RIGHT]", 0
controlFrequencyTxt             byte "controlFrequency", 0

DAT ' script buffers

configDec                       byte "DECIN 1", 0
restoreConfig                   byte "DECIN ?", 0

introTempo                      byte "TEMPO 1500", 0
{midTempo                        byte "TEMPO 1500", 0
endTempo                        byte "TEMPO 1500", 0
finalTempo                      byte "TEMPO 1500", 0 }
introSong                       byte "SONG 7", 0
roachSong                       byte "SONG 8", 0
catchMeIfYouCanSong             byte "SONG 9", 0
endSong                         byte "SONG 3", 0
someSuccessSong                 byte "SONG 3", 0  
acknowledgeSong                 byte "SONG 5", 0
alarmSong                       byte "SONG 11", 0

leftCircleF149_50               byte "ARC -360 149 50", 0
rightCircleF149_50              byte "ARC 360 149 50", 0
leftCircleF89_50                byte "ARC -360 89 50", 0
rightCircleF89_50               byte "ARC 360 89 50", 0     
leftCircleF500mm50              byte "ARCMM -360 500 50", 0
rightCircleF500mm50             byte "ARCMM 360 500 50", 0
leftCircleF299mm50              byte "ARCMM -360 299 50", 0
rightCircleF299mm50             byte "ARCMM 360 299 50", 0

{straightF2000mm                 byte "TRVL 587 50", 0
straightF1000mm                 byte "TRVL 293 50", 0
straightF500mm                  byte "TRVL 147 50", 0
straightF2000mmFast             byte "TRVL 587 100", 0
straightF1000mmFast             byte "TRVL 293 100", 0
straightF500mmFast              byte "TRVL 147 100", 0 }
straightF2000mm50               byte "MM 2000 50", 0
straightF1000mm50               byte "MM 1000 50", 0
straightF500mm50                byte "MM 500 50", 0
straightF2000mm100              byte "MM 2000 100", 0
straightF1000mm100              byte "MM 1000 100", 0
straightF500mm100               byte "MM 500 100", 0
straightF3000mm20               byte "MM 3000 20", 0
straightR3000mm20               byte "MM -3000 20", 0
straightF3000mm40               byte "MM 3000 40", 0
straightR3000mm40               byte "MM -3000 40", 0
straightF3000mm60               byte "MM 3000 60", 0
straightR3000mm60               byte "MM -3000 60", 0
straightF3000mm80               byte "MM 3000 80", 0
straightF3000mm100              byte "MM 3000 100", 0


straightF5Rev50                 byte "TRVL 720 50", 0

left90_50                       byte "TURN -90 50", 0
right90_50                      byte "TURN 90 50", 0
left90_100                      byte "TURN -90 100", 0
right90_100                     byte "TURN 90 100", 0
left180                         byte "TURN -180 50", 0
right180                        byte "TURN 180 50", 0
leftSpin5Rev100                 byte "TURN -1800 100", 0
rightSpin5Rev100                byte "TURN 1800 100", 0
rightSpin10Rev50                byte "TURN 3600 50", 0
leftSpin10Rev50                 byte "TURN -3600 50", 0
rightSpin20Rev5                 byte "TURN 7200 5", 0
leftSpin20Rev5                  byte "TURN -7200 5", 0
leftSpin1Rev10                  byte "TURN -360 10", 0
rightSpin2Rev20                 byte "TURN 720 20", 0
leftSpin2Rev30                  byte "TURN -720 30", 0
rightSpin2Rev40                 byte "TURN 720 40", 0
leftSpin2Rev50                  byte "TURN -720 50", 0
rightSpin2Rev60                 byte "TURN 720 60", 0
leftSpin3Rev70                  byte "TURN -1080 70", 0
rightSpin3Rev80                 byte "TURN 1080 80", 0
leftSpin4Rev90                  byte "TURN -1440 90", 0
rightSpin4Rev100                byte "TURN 1440 100", 0
                                                 
DAT

addressOffsetTest               word @addressOffsetTest

twoByOneMRectanglePlusTwo8s     word @configDec
                                word @introSong
                                word @straightF2000mm50, @left90_50
                                word @acknowledgeSong
                                word @straightF1000mm50, @left90_50
                                word @acknowledgeSong
                                word @straightF2000mm50, @left90_50
                                word @acknowledgeSong
                                word @straightF1000mm50
                                word @someSuccessSong, @right180
                                word @straightF1000mm50, @right90_50
                                word @acknowledgeSong
                                word @straightF2000mm50, @right90_50
                                word @acknowledgeSong
                                word @straightF1000mm50, @right90_50
                                word @straightF2000mm50
                                word @someSuccessSong, @left180
                                word @straightF1000mm50, @left90_50
                                word @acknowledgeSong
                                word @straightF500mm50
                                word @catchMeIfYouCanSong
                                word @rightCircleF299mm50, @leftCircleF299mm50
                                word @rightCircleF500mm50, @leftCircleF500mm50, 0

calibratePosPerRev              word @configDec
                                word @introSong
                                word @rightSpin10Rev50, 0

calibrateDistance               word @configDec
                                word @introSong
                                word @straightF5Rev50, 0

arcTest                         word @configDec
                                word @introSong
                                word @leftCircleF89_50, @rightCircleF89_50
                                word @leftCircleF299mm50, @rightCircleF299mm50 
                                word @leftCircleF149_50, @rightCircleF149_50
                                word @leftCircleF500mm50, @rightCircleF500mm50, 0

turnTest                        word @configDec
                                word @introSong
                                word @rightSpin10Rev50
                                word @acknowledgeSong
                                word @leftSpin10Rev50
                                word @acknowledgeSong
                                word @leftSpin5Rev100
                                word @acknowledgeSong
                                word @rightSpin5Rev100
                                word @catchMeIfYouCanSong
                                word @rightSpin20Rev5
                                word @acknowledgeSong
                                word @leftSpin20Rev5
                                word @acknowledgeSong
                                word @roachSong, 0

distanceTest                    word @configDec
                                word @introSong
                                word @straightF3000mm20
                                word @acknowledgeSong
                                word @straightR3000mm20
                                word @acknowledgeSong
                                word @straightF3000mm40
                                word @acknowledgeSong
                                word @straightR3000mm40
                                word @acknowledgeSong
                                word @straightF3000mm60
                                word @acknowledgeSong
                                word @straightR3000mm60
                                word @acknowledgeSong
                                word @straightF3000mm80
                                word @acknowledgeSong
                                word @left180
                                word @straightF3000mm100
                                word @acknowledgeSong
                                word @left180
                                word @straightF2000mm50

                                word @catchMeIfYouCanSong
                                
                                word @leftSpin1Rev10
                                word @rightSpin2Rev20
                                word @acknowledgeSong
                                word @leftSpin2Rev30
                                word @rightSpin2Rev40
                                word @acknowledgeSong
                                word @leftSpin2Rev50
                                word @rightSpin2Rev60
                                word @acknowledgeSong
                                word @leftSpin3Rev70
                                word @rightSpin3Rev80
                                word @acknowledgeSong
                                word @leftSpin4Rev90
                                word @rightSpin4Rev100
                                word @someSuccessSong, 0
                           
DAT {{Terms of Use: MIT License

  Permission is hereby granted, free of charge, to any person obtaining a copy of this
  software and associated documentation files (the "Software"), to deal in the Software
  without restriction, including without limitation the rights to use, copy, modify,
  merge, publish, distribute, sublicense, and/or sell copies of the Software, and to
  permit persons to whom the Software is furnished to miso so, subject to the following
  conditions:

  The above copyright notice and this permission notice shall be included in all copies
  or substantial portions of the Software.

  The software is provided "as is", without warranty of any kind, express or implied,
  including but not limited to the warranties of mechantability, fitness for a
  particular purpose and non-infringement. In no even shall the authors or copyright
  holders be liable for any claim, damages or other liability, whether in an action of
  contract, tort or otherwise, arising from, out of or in connection with the software
  or the use of other dealing in the software.
  
}} 