{{Servo32v9Shared.spin Removed ramping option to make file smaller.Modification by Duane Degn, February 21, 2014.Changed variables to DAT section so this object may beshared from multiple objects.Additional modification by Duane Degn November 4, 2014.****************************************** Servo32v9 Driver                   v9 ** Author: Beau Schwabe                  ** Copyright (c) 2013 Parallax           ** See end of file for terms of use.     *********************************************************************************************************** Control up to 32-Servos      Version 9               04-05-2013 ***************************************************************** Coded by Beau Schwabe (Parallax).                                            ***************************************************************** History:                            Version 1 -               initial concept                            Version 2 - (03-08-2006)  Beta release                             Version 3 - (11-04-2007)  Improved servo resolution to 1uS                            Version 4 - (05-03-2009)  Ability to disable a servo channel                                                      and remove channel preset requirement                                        Version 5 - (05-08-2009)  Added ramping ability                            Version 6 - (07-18-2009)  Fixed slight timing skew in ZoneLoop and                                                      fixed overhead timing latency in ZoneCore                            Version 7 - (08-18-2009)  Fixed servo jitter in ramping function when                                                      servo reached it's target position                            Version 8 - (12-20-2010)  Added PUB method to retrieve servo position                            Version 9 - (04-05-2013)  cnt rollover issue corrected with ZonePeriod                                                      by setting up Counter A and using the Phase                                                      accumulator instead of the cnt                                                                                                            Note: This also eliminates the need to setup                                                            a 'NoGlitch' variable                                                                                                                                          Theory of Operation:Each servo requires a pulse that varies from 1mS to 2mS with a period of 20mS.To prevent a current surge nightmare, I have broken the 20mS period into fourgroups or Zones of 8 servos each with a period of 5mS. What this does, is toensure that at any given moment in time, a maximum of only 8 servos are receivinga pulse.   Zone1 Zone2 Zone3    Zone4          In Zone1, servo pins  0- 7 are active           In Zone2, servo pins  8-15 are active  │─5mS│─5mS│─5mS│─5mS│        In Zone3, servo pins 16-23 are active  │──────────20mS───────────│        In Zone4, servo pins 24-31 are active                      1-2mS servo pulse               The preferred circuit of choice is to place a 4.7K resistor on each signal inputto the servo.    If long leads are used, place a 1000uF cap at the servo powerconnector.    Servo's seem to be happy with a 5V supply receiving a 3.3V signal.}}CON  ONE_MILLION = 1_000_000                               'Divisor for 1 uS     ZONE_PERIOD = 5_000                                   '5mS (1/4th of typical servo period of 20mS)     MIN_ALLOWED_PULSE = 500  MAX_ALLOWED_PULSE = 2500                                                                                  MIN_ALLOWED_PIN = 0  MAX_ALLOWED_PIN = 31                                                                               DATzoneClocks              long 0servoPinDirection       long 0servoData               long 0[32] '0-31 Current Servo Value cog                     long 0microSecond             long 0-0PUB Start  ifnot cog    microSecond := clkfreq / ONE_MILLION    zoneClocks := (microSecond * ZONE_PERIOD)         'calculate # of clocks per ZONE_PERIOD    cog := cognew(@servoStart, @zoneClocks) + 1  result := @servoDataPUB Set(pin, width)   result := MIN_ALLOWED_PULSE #> width <# MAX_ALLOWED_PULSE ' check if within limits      pin := MIN_ALLOWED_PIN #> pin <# MAX_ALLOWED_PIN     servoData[pin] := (microSecond * width)        'calculate # of clocks for a specific Pulse Width     pin := 1 << pin     if result == width  ' check if within limits    ifnot servoPinDirection & pin ' only change direction mask if needed      servoPinDirection |= pin  elseif servoPinDirection & pin     servoPinDirection &= !pinDAT'*********************'* Assembly language *'*********************                        org'------------------------------------------------------------------------------------------------------------------------------------------------servoStart                        mov     ctra,                   %11111                  'set Counter A mode to Always                        shl     ctra,                   #26                                             mov     frqa,                   #1                      'start Counter A ; use it as a clock                        mov     index,                  par                     'Set Index Pointer                        rdlong  _zoneClocks,            index                   'Get ZoneClock value                        add     index,                  #4                      'Increment Index to next Pointer                        mov     pinDirectionAddress,    index                   'Set pointer for I/O direction Address                        add     index,                  #32                     'Increment index to END of Zone1 Pointer                        mov     zoneIndex1,             index                   'Set index Pointer for Zone1                        add     index,                  #32                     'Increment index to END of Zone2 Pointer                        mov     zoneIndex2,             index                   'Set index Pointer for Zone2                        add     index,                  #32                     'Increment index to END of Zone3 Pointer                        mov     zoneIndex3,             index                   'Set index Pointer for Zone3                        add     index,                  #32                     'Increment index to END of Zone4 Pointer                        mov     zoneIndex4,             index                   'Set index Pointer for Zone4ioUpdate                rdlong  dira,                   pinDirectionAddress     'Get and set I/O pin directions'------------------------------------------------------------------------------------------------------------------------------------------------zone1                   mov     zoneIndex0,              zoneIndex1              'Set index Pointer for Zone1                        call    #resetZone                        call    #zoneCorezone2                   mov     zoneIndex0,              zoneIndex2              'Set Index Pointer for Zone2                        call    #incrementZone                        call    #zoneCorezone3                   mov     zoneIndex0,              zoneIndex3              'Set Index Pointer for Zone3                        call    #incrementZone                        call    #zoneCorezone4                   mov     zoneIndex0,              zoneIndex4              'Set Index Pointer for Zone4                        call    #incrementZone                        call    #zoneCore                        jmp     #ioUpdate'------------------------------------------------------------------------------------------------------------------------------------------------resetZone               mov     zoneShift1,             #1                        mov     zoneShift2,             #2                                                mov     zoneShift3,             #4                        mov     zoneShift4,             #8                        mov     zoneShift5,             #16                        mov     zoneShift6,             #32                        mov     zoneShift7,             #64                        mov     zoneShift8,             #128resetZone_RET           ret                        '------------------------------------------------------------------------------------------------------------------------------------------------incrementZone           shl     zoneShift1,             #8                        shl     zoneShift2,             #8                                                shl     zoneShift3,             #8                        shl     zoneShift4,             #8                        shl     zoneShift5,             #8                        shl     zoneShift6,             #8                        shl     zoneShift7,             #8                        shl     zoneShift8,             #8incrementZone_RET       ret                        '------------------------------------------------------------------------------------------------------------------------------------------------zoneCore                mov     servoByte,              #0                      'Clear ServoByte                        mov     index,                  zoneIndex0               'Set Index Pointer for proper ZonezoneSync                        mov     phsa,                   #0                      'reset Phase A accumulator                        mov     syncPoint,              phsa                    'Create a Sync Point with Phase A accumulator'                       add     syncPoint,              #215                    '<- Debug - 2us becomes 1us  (See CON section)'                       add     syncPoint,              #296                    '<- Debug - 2us becomes 3us  (See CON section)                        add     syncPoint,              #256                    'Add overhead offset to counter Sync point                                                                                'midpoint from above Debug test.                                                                                                         mov     loopCounter,            #8                      'Set Loop Counter to 8 Servos for this Zone                        movd    loadServos,             #servoWidth8            'Restore/Set self-modifying code on "LoadServos" line                        movd    servoSync,              #servoWidth8            'Restore/Set self-modifying code on "ServoSync" lineloadServos              rdlong  servoWidth8,            index                   'Get Servo Data                        sub     index,                  #4                      'Decrement index pointer to next address                        nopservoSync               add     servoWidth8,            syncPoint               'Determine system counter location where pulse should end                        sub     loadServos,             destinationIncrement    'self-modify destination pointer for "LoadServos" line                        sub     servoSync,              destinationIncrement    'self-modify destination pointer for "ServoSync" line                        djnz    loopCounter,            #loadServos             'Do ALL 8 servo positions for this Zone                        mov     temp,                   _zoneClocks             'Move _ZoneClocks into temp                        add     temp,                   syncPoint               'Add syncPoint to _ZoneClocks                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                '----------------------------------------------Start Tight Servo code-------------------------------------------------------------zoneLoop                mov     tempcnt,                phsa                    '(4 - clocks) take a snapshot of current Phase A accumulator value                        cmpsub  servoWidth1,            tempcnt       nr,wc     '(4 - clocks) compare system counter to servoWidth ; write result in C flag                        muxc    servoByte,              zoneShift1              '(4 - clocks) Set ServoByte.Bit0 to "0" or "1" depending on the value of "C"                        cmpsub  servoWidth2,            tempcnt       nr,wc     '(4 - clocks) compare system counter to servoWidth ; write result in C flag                        muxc    servoByte,              zoneShift2              '(4 - clocks) Set ServoByte.Bit1 to "0" or "1" depending on the value of "C"                        cmpsub  servoWidth3,            tempcnt       nr,wc     '(4 - clocks) compare system counter to servoWidth ; write result in C flag                        muxc    servoByte,              zoneShift3              '(4 - clocks) Set ServoByte.Bit2 to "0" or "1" depending on the value of "C"                        cmpsub  servoWidth4,            tempcnt       nr,wc     '(4 - clocks) compare system counter to servoWidth ; write result in C flag                        muxc    servoByte,              zoneShift4              '(4 - clocks) Set ServoByte.Bit3 to "0" or "1" depending on the value of "C"                        cmpsub  servoWidth5,            tempcnt       nr,wc     '(4 - clocks) compare system counter to servoWidth ; write result in C flag                        muxc    servoByte,              zoneShift5              '(4 - clocks) Set ServoByte.Bit4 to "0" or "1" depending on the value of "C"                        cmpsub  servoWidth6,            tempcnt       nr,wc     '(4 - clocks) compare system counter to servoWidth ; write result in C flag                        muxc    servoByte,              zoneShift6              '(4 - clocks) Set ServoByte.Bit5 to "0" or "1" depending on the value of "C"                        cmpsub  servoWidth7,            tempcnt       nr,wc     '(4 - clocks) compare system counter to servoWidth ; write result in C flag                        muxc    servoByte,              zoneShift7              '(4 - clocks) Set ServoByte.Bit6 to "0" or "1" depending on the value of "C"                        cmpsub  servoWidth8,            tempcnt       nr,wc     '(4 - clocks) compare system counter to servoWidth ; write result in C flag                        muxc    servoByte,              zoneShift8              '(4 - clocks) Set ServoByte.Bit7 to "0" or "1" depending on the value of "C"                        mov     outa,                   ServoByte               '(4 - clocks) Send ServoByte to Zone Port                        cmp     temp,                   tempcnt       nr,wc     '(4 - clocks) Determine if Phase A accumulator has exceeded width of _ZoneClocks ; write result in C flag              if_nc     jmp     #zoneLoop                                       '(4 - clocks) if the "C Flag" is not set stay in the current Zone'-----------------------------------------------End Tight Servo code--------------------------------------------------------------'                                                                        Total = 80 - clocks  @ 80MHz that's 1uS resolutionzoneCore_RET            ret'------------------------------------------------------------------------------------------------------------------------------------------------destinationIncrement    long    $0000_0200pinDirectionAddress     long    0tempcnt                 long    0servoWidth1             res     1servoWidth2             res     1servoWidth3             res     1servoWidth4             res     1servoWidth5             res     1servoWidth6             res     1servoWidth7             res     1servoWidth8             res     1zoneShift1              res     1zoneShift2              res     1zoneShift3              res     1zoneShift4              res     1zoneShift5              res     1zoneShift6              res     1zoneShift7              res     1zoneShift8              res     1temp                    res     1index                   res     1zoneIndex0              res     1zoneIndex1              res     1zoneIndex2              res     1zoneIndex3              res     1zoneIndex4              res     1syncPoint               res     1servoByte               res     1loopCounter             res     1_zoneClocks             res     1DAT{{┌──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐│                                                   TERMS OF USE: MIT License                                                  │├──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┤│Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation    ││files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy,    ││modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software││is furnished to do so, subject to the following conditions:                                                                   ││                                                                                                                              ││The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.││                                                                                                                              ││THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE          ││WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR         ││COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,   ││ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.                         │└──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘}}