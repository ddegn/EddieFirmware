CON
{{
  Modified By Duane Degn
  December 6, 2014

  There may be multiple instances of the object
  in use on one time. All the variables are
  located in the DAT section which allows the
  variables to be shared among the multiple
  instances.

  The method "Init" must be called prior to using
  any method relying on the Speed of sound to
  compute distance.
  
  The method "RawTicks" is used by all the
  distance measuring methods.

  It is possible to adjust the conversion factors
  used to compute distances by changing the
  value used in the variable "speedOfSound".
  This value may be changed directly with the
  method "SetSpeedOfSound" or indirctly with the
  method "AdjustForTemperature". See the comments
  included with these methods for additional
  information about their function.
  
  Based on code by Chris Savage and Jeff Martin.
  Most of the code in the method "RawTicks" is
  from the original object.
  
***************************************
*        Ping))) Object V1.2          *
* Author:  Chris Savage & Jeff Martin *
* Copyright (c) 2006 Parallax, Inc.   *
* See end of file for terms of use.   *    
* Started: 05-08-2006                 *
***************************************

Interface to Ping))) sensor and measure its ultrasonic travel time.  Measurements can be in
units of time or distance.
Each method requires one parameter, pin, that is the I/O pin that is connected to the
Ping)))'s signal line.

  ┌───────────────────┐
  │┌───┐         ┌───┐│    Connection To Propeller
  ││ ‣ │ PING))) │ ‣ ││    Remember PING))) Requires
  │└───┘         └───┘│    +5V Power Supply
  │    GND +5V SIG    │
  └─────┬───┬───┬─────┘
        │  │    3.3K
          └┘   └ Pin

--------------------------REVISION HISTORY--------------------------
 v1.2 - Updated 06/13/2011 to change SIG resistor from 1K to 3.3K
 v1.1 - Updated 03/20/2007 to change SIG resistor from 10K to 1K
 
}}
CON '' Temperature Effects on Speed of Sound
{{
  The speed of sound in dry air is approximately:
  speed of sound = 331.3 + 0.606 * temperature
  with temperature in units of Celsius

  @25C speed of sound is 346.45 m/s

  14.83 C at 340.29 m/s?

  340.29 m/s is the value given by Google for the
  speed of sound. This is used as the default
  centimeters per second speed value.
  The speed used to compute distances may be
  changed with the "SetSpeedOfSound" method.   
}}
CON

  #0, CM_UNITS, TENTH_OF_INCH_UNITS
  #0, DEGREES_C, DEGREES_TENTH_C
  
  CM_IN_100_INCHES = 254                                '' exact
  TENTHS_OF_INCH_IN_100_INCHES = 1000                   '' exact
  DEFAULT_SPEED_OF_SOUND_CM = 34029                     '' cm / s (according to Google)
  SPEED_AT_0_C = 33130                                  '' cm / s
  ADJUSTMENT_PER_10_C = 606                             '' per 10 degree C
                                                                                 
PUB Init
'' Set the value of the conversion factors.
'' These conversion factors take into account
'' the round trip nature of the sound.
'' This method needs to be called prior to
'' calling methods using any of the conversion
'' factors used by the program.

  toMicroseconds := clkfreq / 500_000
  SetSpeedOfSound(DEFAULT_SPEED_OF_SOUND_CM, CM_UNITS)
  
PUB SetSpeedOfSound(value, units)
'' Set new "value" for the speed of sound.
'' The new value will be used for both
'' imperial and metric measurements.
'' If "units" equals "CM_UNITS", then "value"
'' will be assumed to be in the units of
'' cm/s. If units equals "TENTH_OF_INCH_UNITS"
'' then "value" will be assumed to be in the
'' units of inches per ten seconds or 0.1"/s.

  case units
    CM_UNITS:
      speedOfSound[CM_UNITS] := value
      speedOfSound[TENTH_OF_INCH_UNITS] := DivideWithRound(speedOfSound[CM_UNITS] * {
      } TENTHS_OF_INCH_IN_100_INCHES, CM_IN_100_INCHES)
    TENTH_OF_INCH_UNITS:
      speedOfSound[TENTH_OF_INCH_UNITS] := value
      speedOfSound[CM_UNITS] := DivideWithRound(speedOfSound[TENTH_OF_INCH_UNITS] * {
      } CM_IN_100_INCHES, TENTHS_OF_INCH_IN_100_INCHES)
    other: ' not a valid value for the units parameter
      return 0

  InitConvertionFactors
  
  result := @speedOfSound
      
PRI InitConvertionFactors
'' These conversion factors need to be computed prior to being used in
'' the various calculations in this program.
'' These values need to be changed whenever the value used for the
'' speed of sound changes.
'' These calculations were moved from being inline with the code in order
'' to speed up the program.
    
  toTenthInches := DivideWithRound(clkfreq * 2, speedOfSound[TENTH_OF_INCH_UNITS])
  toInches := DivideWithRound(clkfreq * 20, speedOfSound[TENTH_OF_INCH_UNITS])
  toMillimeters := DivideWithRound(clkfreq, 5 * speedOfSound[CM_UNITS])
  toCentimeters := DivideWithRound(clkfreq * 2, speedOfSound[CM_UNITS])
  
PUB RawTicks(pin) : raw
'' Returns Ping)))'s two-way ultrasonic travel
'' time in clock cycles
                                                                                 
  outa[pin] := 0                
  dira[pin] := 1                
  outa[pin] := 1                
  outa[pin] := 0                ' This low pulse should be at least 2µs long.
                                ' Spin is slow enough, a pause is not required.
  dira[pin] := 0                ' Make I/O pin an input and listen for echo.
  waitpne(0, |< pin, 0)         ' Wait for pin to go high (indicating pulse has been sent).
  
  raw := -cnt                   ' Store negative of current counter value. (This allows a
                                ' single local variable to measure the time interval.)
                                
  waitpeq(0, |< pin, 0)         ' Wait for I/O pin to be set low (indicating echo has been
                                ' received).
                                
  raw += cnt                    ' Add current counter to produce interval between pulse
                                ' being sent and echo received. 

PUB Microseconds(pin)
'' The time the ultrasound pulse takes to make a
'' one way trip to the obstacle in microseconds.
'' This method does not use the speed of sound
'' to calculate the returned value.

  result := RawTicks(pin) / toMicroseconds              

PUB EddieUnits(pin)
'' Returns value matching original Eddie 
'' firmware's Ping algorithm. Shifting the number
'' of clock cycles nine bits to the right has
'' the effect of dividing the value by 512.
'' The value returned by this method is about 9%
'' different than the value returned by the
'' "Millimeters" method (when using an 80 MHz
'' clock).
'' This method does not use the speed of sound
'' to calculate the returned value. 

  result := RawTicks(pin) >> 9

PUB Inches(pin) : distance
'' Measure object distance in inches.
'' This method relies on a conversion factor
'' derived from the speed of sound to calculate
'' the returned value.

  distance := RawTicks(pin) / toInches                
                                                                                 
PUB TenthsOfInch(pin) : distance
'' Measure object distance in tenths of an inch.
'' While this program is not able to achieve
'' tenth of an inch precision, this method is 
'' still useful since this program can achieve 
'' better than 1 inch precision. The precision 
'' appears to be about 0.2 inch.
'' This method relies on a conversion factor
'' derived from the speed of sound to calculate
'' the returned value.

  distance := RawTicks(pin) / toTenthInches
                                                                                 
PUB Centimeters(pin) : distance                                                  
'' Measure object distance in centimeters.
'' This method relies on a conversion factor
'' derived from the speed of sound to calculate
'' the returned value.
                                              
  distance := RawTicks(pin) / toCentimeters        
                                                                                
PUB Millimeters(pin) : distance                                                  
'' Measure object distance in millimeters
'' While this program is not able to achieve
'' millimeter precision, this method is still
'' useful since this program can achieve better
'' than 1 centimeter precision.
'' This method relies on a conversion factor
'' derived from the speed of sound to calculate
'' the returned value.
                                              
  distance := RawTicks(pin) / toMillimeters        

PUB GetSpeedOfSound(units)
'' This method returns the value of the speed of 
'' sound used by the object to calculate distances.
'' The value returned will either be the speed of
'' sound in cm/s or 0.1"/s depending one the value
'' used for the parameter "units".
'' If "units" equals zero then the value with
'' metric units will be return. If the value of
'' "units" equals one then the value with
'' imperial units will be returned.

  result := speedOfSound[units]

PUB AdjustForTemperature(temperature, units)
'' This method will adjust the value of the speed 
'' of sound based on the temperature parameter. 
'' The "units" parameter is used to indicate if 
'' the temperature value has been scaled by a 
'' factor of ten or not. 
'' See the comments under "Temperature Effects on 
'' Speed of Sound" in the CON section for
'' additional information about the formula used
'' in this calculation.

  case units
    DEGREES_C:
      temperature *= 10
    DEGREES_TENTH_C:
    other:
      return 0

  result := SPEED_AT_0_C + DivideWithRound(temperature * ADJUSTMENT_PER_10_C, 100)
  SetSpeedOfSound(result, CM_UNITS)
  
  result := @speedOfSound

PUB DivideWithRound(numerator, denominator)

  numerator += denominator / 2
  result := numerator / denominator

DAT

toMicroseconds          long 0-0
toInches                long 0-0
toTenthInches           long 0-0
toMillimeters           long 0-0
toCentimeters           long 0-0

speedOfSound            long 0-0[2]
  
{{

  Terms of Use: MIT License

  Permission is hereby granted, free of charge, to any person obtaining a copy of this
  software and associated documentation files (the "Software"), to deal in the Software
  without restriction, including without limitation the rights to use, copy, modify,
  merge, publish, distribute, sublicense, and/or sell copies of the Software, and to
  permit persons to whom the Software is furnished to do so, subject to the following
  conditions:

  The above copyright notice and this permission notice shall be included in all copies
  or substantial portions of the Software.

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
  INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
  PARTICULAR PURPOSE AND NON-INFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF
  CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
  OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. 

}}         