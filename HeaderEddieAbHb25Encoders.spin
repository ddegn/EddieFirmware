CON{{ ****** Public Notes ******

  This header file should be used with robots using the Propeller Activity Board
  and HB-25 Motor controllers.
  This firmware update is part of the Open Propeller Project #8. For more information
  about this project see the following thread in the Parallax forum.
  
  http://forums.parallax.com/showthread.php/158030
  
  This header file makes it possible to easily change hardware while using the
  same base code.
  
  The hardware specific objects are included in this header. This allows updates
  to the Eddie firmware to be easily applied to both robots using the original
  Eddie harware and to robots using the Arlo hardware.

}}
CON '' Activity Board Constants
  
  ' Encoders
  ENCODERS_PIN = 14

  ENABLE_0 = 12
  ENABLE_1 = 13
 
  ' ADC (Activity Board)
  ADC_CS = 21                                        
  ADC_SCL = 20 
  ADC_DO = 19 
  ADC_DI = 18

  
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
  ALT_TX = 10                                          '' User changeable
  ALT_RX = 11                                          '' User changeable

  ' Master GPIO mask (Only high pins can be set as outputs)
  OUTPUTABLE = %00001100_00000000_00000011_11111111 
  PINGABLE = %00000000_00000000_00000011_11111111
  SERVOABLE = PINGABLE
  MAX_ALLOWED_PINGS = 10

  INITIAL_GPIO = OUTPUTABLE & !INITIAL_PING
  
  ' Terminal Settings
  BAUDMODE = %0000
  USB_BAUD = 115_200                                    '' User changeable
  ALT_BAUD = 115_200                                    '' User changeable

  MAX_POWER = 7520

  SCALED_POWER = MAX_POWER / 500
 
  STOP_PULSE = 1_500

  TOO_SMALL_TO_FIX = 0                                  '' User changeable
  DEFAULT_INTEGRAL_NUMERATOR = 200                      '' User changeable
  DEFAULT_INTEGRAL_DENOMINATOR = 100                    '' User changeable
  
OBJ

  '' The analog to digital converter object does not start a new cog.
  '' The ADC object is required to use the "ADC" command
  Adc : "ActivityBoardAdc"                              ' 4-channel 12-bits
  Motors : "Servo32v9Shared"
  Music : "s2_music141215a"                             ' uses one cog
  
PUB InitAdc

  Adc.Init(ADC_CS, ADC_SCL, ADC_DI, ADC_DO)
    
PUB StartMotors

  Motors.Start

PUB SetMotorPower(side, power)

  Motors.Set(enablePin[side], STOP_PULSE + (power / SCALED_POWER))

PUB ReadAdc(ch)

  result := Adc.Read(ch)
                        
PUB InitMusic(volume)

  Music.start_tones
  Music.SetVolume(volume)

PUB PlaySong(songId, tempo)

  Music.play_song(songId, tempo)

PUB SetVolume(volume)

  Music.SetVolume(volume)
  
DAT

enablePin     long ENABLE_0, ENABLE_1
