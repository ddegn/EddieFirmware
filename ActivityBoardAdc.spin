CON
{{
  Modified by Duane Degn

  The software is a modified version of Jon McPalen's "jm_adc124s021.spin" object.
  The modifications are intended to make it easier to use part of the "Eddie"
  robot's firmware.

  The Propeller Activity board uses an ADC124S021 analog to digital converter chip. This is 
  a 4 channel 12-bit device. To make the Activity Board version of the Eddie firmware
  backwards compatible, the readings of the four channels will be availble from two
  different channel IDs. For example, the first channel's reading will be available when
  requested from both channel 0 and channel 4. 
  
  These modifications were made as part of Parallax's Open Propeller Project #8.
  For more information about this project see the following thread on the Parallax forums:

  http://forums.parallax.com/showthread.php/158030

  Some of the changes I made include changing the name of the "start" method to "init"
  to comply with the convention of only using "start" with methods which start a new
  cog. The "read" method was modified to accept the channel number or the channel
  number plus four.

  The formatting was changed to more closely agree with the Parallax Gold Standard
  formatting conventions.
  
  Header to the original object below.
}}
'' ==========================================================================================
''
''   File....... jm_adc124s021.spin 
''   Purpose.... Interface for ADC124S021 ADC chip (used on Propeller Activity Board)
''   Author..... Jon "JonnyMac" McPhalen
''               Copyright (c) 2013-14 Jon McPhalen
''               -- see below for terms of use
''   E-mail..... jon@jonmcphalen.com
''   Started.... 
''   Updated.... 09 OCT 2014
''
'' ==========================================================================================

{{

   Note on object: The ADC returns the channel value set in the _previous_ read cycle, hence 
   this code uses a double read each time to ensure the current channel value is returned.
   
}}
VAR

  long  cs                                              ' active-low chip select
  long  sck                                             ' active-low clock
  long  mosi                                            ' prop -> adc.di
  long  miso                                            ' prop <- adc.do

PUB Init(cspin, sckpin, dipin, dopin)

'' Configure IO pins used by ADC
'' -- pins define connections to ADC124S021

  longmove(@cs, @cspin, 4)                              ' copy pins

  outa[cs] := 1                                         ' output high to disable
  dira[cs] := 1

  outa[sck] := 1                                        ' output high
  dira[sck] := 1 

  dira[miso] := 0                                       ' input (from adc)

  dira[mosi] := 1                                       ' output (to adc)

 
PUB Read(ch) | ctrlbits, adcval

'' Reads adc (ADC124S021) channel, 0 - 3 (with ID's 0 - 7)
'' -- returns 12-bit value
'' The channel may be read by identifing the channel number
'' or the channel number plus four.

  if ((ch < 0) or (ch > 7))                             ' validate channel
    return -1

  if ch > 3
    ch -= 4
    
  ctrlbits := ((ch << 3) << 24) | ((ch << 3) << 8)      ' config for two reads

  outa[cs] := 0                                         ' select device
  repeat 32                                             ' two complete reads
    outa[sck] := 0                                      ' clock low
    outa[mosi] := (ctrlbits <-= 1)                      ' output control bits  
    adcval := (adcval << 1) | ina[miso]                 ' get result bit
    outa[sck] := 1                                      ' clock high
  outa[cs] := 1                                         ' deselect device

  return adcval & $0FFF                                 ' return 2nd read


DAT { license }

{{

  Terms of Use: MIT License

  Permission is hereby granted, free of charge, to any person obtaining a copy of this
  software and associated documentation files (the "Software"), to deal in the Software
  without restriction, including without limitation the rights to use, copy, modify,
  merge, publish, distribute, sublicense, and/or sell copies of the Software, and to
  permit persons to whom the Software is furnished to miso so, subject to the following
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