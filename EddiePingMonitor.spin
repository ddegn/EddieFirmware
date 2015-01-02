CON{{ ****** Public Notes ******  

  This object fills an array with values read
  from Ping ultrasonic sensors.

  This object runs continuously once started and
  uses one cog.

  The values stored in the array are the readings
  in units of millimeters.

  To use units consistent with earlier version
  of Eddie firmware, comment out lines with the
  the comment "New Eddie" on the line.
  Uncomment the corresponding "Old Eddie" lines.
  
}}
CON

  #0, CM_UNITS, TENTH_OF_INCH_UNITS
  #0, DEGREES_C, DEGREES_TENTH_C

  MAX_ALLOWED_PINGS = 8
 
  'MIN_PING = $12 '18      ' Old Eddie
  'MAX_PING = $B54 '2900  ' Old Eddie

  MIN_PING = $A '10      ' New Eddie
  MAX_PING = $CC6 '3270  ' New Eddie

  MIN_DELAY = 9
  MAX_DELAY = $68DB '26,843
  
VAR

  long pingInterval, pingTimer, countAddress, firstPingAddress 
  
  byte cog, pingsInUse, pingPins[MAX_ALLOWED_PINGS]
                                                          
OBJ

  Ping : "EddiePing"
  
PUB Start(pingMask, delayInMilliseconds, stackPtr)            'Start a new cog with the assembly routine
'' The long immediately previous to the location
'' indicated by "stackPtr" is a counter to keep
'' track of how many times the Ping sensors have
'' been read.
'' The parameter "stackPtr" initially points to
'' the Ping distance variables.
'' The stack used by the new cog will start with
'' the long after the last distance variable.

  Stop

  countAddress := stackPtr - 4
  firstPingAddress := stackPtr
  pingInterval := (MIN_DELAY #> delayInMilliseconds <# MAX_DELAY) * (clkfreq / 1000)
  pingsInUse := FindPingPins(pingMask)
  stackPtr += 4 * pingsInUse

  if pingsInUse
    result := cog := cognew(WatchPing(pingsInUse - 1), stackPtr) + 1
  else
    result := 0

PUB Stop                        'Stop the currently running cog, if any

  if cog
    cogstop(cog - 1)
    cog := 0
    pingsInUse := 0

PUB GetPingsInUse

  result := pingsInUse

PUB AdjustForTemperature(temperature)
'' Adjust the calibration value used by the Ping
'' object to compensate for changes in the speed
'' of sound caused by changes in air temperature.
'' The value of "temperature" should be in
'' degrees Celsius scaled by a factor of ten to
'' allow greater precision.

  Ping.AdjustForTemperature(temperature, Ping#DEGREES_TENTH_C)
  
PRI FindPingPins(mask) | pinNumber
'' Returns the number of ping sensors in use.

  pinNumber := 0 ' there's a faster way to do this
  repeat while mask and result =< MAX_ALLOWED_PINGS
    if mask & 1
      pingPins[result++] := pinNumber
    pinNumber++
    mask >>= 1
  
PUB WatchPing(maxPingIndex) | pingIndex

  Ping.Init ' not really needed if just Eddie units are read
  long[countAddress] := 0
  pingTimer := cnt
  repeat
    repeat pingIndex from 0 to maxPingIndex
      'result := Ping.EddieUnits(pingPins[pingIndex]) ' Old Eddie
      result := Ping.Millimeters(pingPins[pingIndex]) ' New Eddie
      if result < MIN_PING or result > MAX_PING
        result := 0
      long[firstPingAddress][pingIndex] := result
      waitcnt(pingTimer += pingInterval)   
    long[countAddress]++
    