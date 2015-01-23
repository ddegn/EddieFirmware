CON{{ ****** Public Notes ******

  This header file should be used with robots using an Eddie Controller Board.
  This firmware update is part of the Open Propeller Project #8. For more information
  about this project see the following thread in the Parallax forum.
  
  http://forums.parallax.com/showthread.php/158030
  
  This header file makes it possible to easily change hardware while using the
  same base code.
  
  The hardware specific objects are included in this header. This allows updates
  to the Eddie firmware to be easily applied to both robots using the original
  Eddie harware and to robots using the Arlo hardware.
  
}}
CON '' Eddie Board Constants  

    ' Encoders
  ENCODERS_PIN = 8
  
  ' Solid-state Relays
  SSR_A = 16                                            
  SSR_B = 17                                            
  SSR_C = 18                                            
 
  ' ADC (Eddie Board)
  ADC_CS = 25
  ADC_SCL = 27 
  ADC_DIO = 26 
  
CON 

  '' distance travelled per encoder tick = 2,455mm / 720 = 3.410mm
  '' bot radius = 59.52 ticks 
  MICROMETERS_PER_TICK = 3410                           '' User changeable
  POSITIONS_PER_ROTATION = 748 ' 744                    '' User changeable
  ' "POSITIONS_PER_ROTATION" is the distance one wheel needs to travel to rotate the
  ' robot a full revolution while one wheel remains stationary.

  ' Motor names
  #0
  LEFT_MOTOR
  RIGHT_MOTOR

  ' Pin assignments
  ' Ping))) sensors
  PING_0 = 0                                            '' User changeable
  PING_1 = 1                                            '' User changeable
  PINGS_IN_USE = 2                                      '' User changeable
  INITIAL_PING = |< PING_0 | |< PING_1                  '' User changeable
  
  ' PC COMMUNICATION
  USB_TX = 30 
  USB_RX = 31
  
  ' PROP TO PROP COMMUNICATION
  ALT_TX = ENCODERS_PIN + 4 '(12)                       '' User changeable 
  ALT_RX = 11                                           '' User changeable

  ' Master GPIO mask (Only high pins can be set as outputs)
  OUTPUTABLE = %00000000_00000111_00001111_11111111
  PINGABLE = %00000000_00000000_00000011_11111111
  SERVOABLE = PINGABLE
  MAX_ALLOWED_PINGS = 10
 
  INITIAL_GPIO = OUTPUTABLE & !INITIAL_PING
  
  ' Terminal Settings
  BAUDMODE = %0000
  USB_BAUD = 115_200                                    '' User changeable
  ALT_BAUD = 115_200                                    '' User changeable

  MAX_POWER = Motors#MAX_ON_TIME

  TOO_SMALL_TO_FIX = 1                                  '' User changeable
  DEFAULT_INTEGRAL_NUMERATOR = 200                      '' User changeable
  DEFAULT_INTEGRAL_DENOMINATOR = 100                    '' User changeable
  DEFAULT_INTEGRAL_NUMERATOR_END = 100                  '' User changeable  
  DEFAULT_INTEGRAL_DENOMINATOR_E = 100                  '' User changeable
  
OBJ

  '' The analog to digital converter object does not start a new cog.
  '' The ADC object is required to use the "ADC" command

  Adc : "EddieBoardAdc"                                 ' 8-channel 10-bits (scaled to 12-bits)
  Motors : "Eddie Motor Driver"                        ' Uses 1 cog
  
PUB InitAdc

  Adc.Init(ADC_CS, ADC_SCL, ADC_DIO)

PUB StartMotors

  Motors.Start

PUB SetMotorPower(side, power)

  if side == RIGHT_MOTOR
    Motors.Right(power)
  else
    Motors.Left(power)
    
PUB ReadAdc(ch)

  result := Adc.Read(ch)

PUB InitMusic(volume)
'' This method is included to make this object compatible with
'' the parent object which is shared amoung two versions of
'' Eddie firmware .   

PUB PlaySong(songId, tempo)
'' This method is included to make this object compatible with
'' the parent object which is shared amoung two versions of
'' Eddie firmware .   

PUB SetVolume(volume)
'' This method is included to make this object compatible with
'' the parent object which is shared amoung two versions of
'' Eddie firmware .   
   