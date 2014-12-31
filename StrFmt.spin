{{
  String Format Object

  These functions add formatted string data to a buffer
  supplied by the caller (which may be a local array).
  All functions null terminate the buffer and return a
  pointer to the null, which is the new insertion point
  for more formatted data.
  
  Since this object uses no data of its own it can be used
  by many other objects and multiple cogs without wasting
  memory or causing interference between instances.

  For clarity it is recommended to name buffers ???buf, as
  in the fdec function, which would always be referenced
  as @???buf, and pointers derived from @???buf as ???ptr
  which would never be used with @.
}}

pub ch(ptr, a)
{
  add an ASCII character
}
  byte[ptr++] := a
  byte[ptr] := 0
  return ptr

pub out(ptr, a)
{
  video object syntax
}
  return ch(ptr, a)

pub tx(ptr, a)
{
  serial object syntax
}
  return ch(ptr, a)

pub chstr(ptr, a, len)
{
  add a string of len characters
}
  bytefill(ptr, a, len)
  result := ptr + len
  byte[result] := 0

pub str(ptr, sptr) | slen
{
  add a null-terminated string
}
  return sbuf(ptr, sptr, strsize(sptr))

pub sbuf(ptr, sptr, len)
{
  Return a string buffer which might not be
  null terminated with specified length
}
  bytemove(ptr, sptr, len)
  result := ptr + len
  byte[result] := 0
  
pub lstr(ptr, sptr, len)
{
  add string left-justified the given length with spaces
}
  return lstrpad(ptr, sptr, len, " ")

pub lstrpad(ptr, sptr, len, padchr) | slen
{
  add string left-justified with given pad character
}
  slen := strsize(sptr) <# len
  result := sbuf(ptr, sptr, slen)
  if slen < len
    result := chstr(result, padchr, len - slen)      
     
pub rstr(ptr, sptr, len)
{
  add string right-justified the given length with spaces
}
  return rstrpad(ptr, sptr, len, " ")

pub rstrpad(ptr, sptr, len, padchr) | slen
{
  add string right-justified with given pad character
}
  slen := strsize(sptr)
  result := ptr
  if slen =< len
    result := chstr(result, padchr, len - slen)
  else
    sptr += (slen - len)
    slen := len      
  result := sbuf(result, sptr, slen)

pub cstr(ptr, sptr, len)
{
  add string center-justified the given length with spaces
}
  return cstrpad(ptr, sptr, len, " ")

pub cstrpad(ptr, sptr, len, padchr) | slen, rlen, llen
{
  add string center-justified with given pad character
}
  slen := strsize(sptr)
  if slen > len
    result := sbuf(ptr, sptr + (slen - len) / 2, len)
  else
    llen := (len - slen) / 2
    rlen := len - slen - llen
    result := chstr(ptr, padchr, llen)
    result := sbuf(result, sptr, slen)
    result := chstr(result, padchr, rlen)      
       
pub dec(ptr, value) | i, nz
{
  add a signed random width decimal number as found
  in many output objects
}
  if value < 0
    -value
    ptr := ch(ptr, "-")

  i := 1_000_000_000
  nz~

  repeat 10
    if value => i
      ptr := ch(ptr, value / i + "0")
      value //= i
      nz~~
    elseif nz or i == 1
      ptr := ch(ptr, "0")
    i /= 10

  return ptr

pub rdec(ptr, value, len) | buf[3]
{
  Return a right-justified fixed length decimal number
  without the flourishes of fdec
}
  dec(@buf, value)
  return rstr(ptr, @buf, len)

pub hex(ptr, value, digits)
{
  add a hexadecimal number
}
  value <<= (8 - digits) << 2
  repeat digits
    ptr := ch(ptr, lookupz((value <-= 4) & $F : "0".."9", "A".."F"))
  return ptr


pub bin(ptr, value, digits)
{
  add a binary number
}
  value <<= 32 - digits
  repeat digits
    ptr := ch(ptr, (value <-= 1) & 1 + "0")
  return ptr

pub fdec(ptr, value, len, dp) | p, fnumbuf[4]
{
   Add a formatted signed fixed width decimal number
  
   This function inserts an optional decimal point.
   A negative dp specifies leading zero width, e.g. dp=-3
   returns 010 instead of 10.  Minus sign is added to the
   left of leading zeroes, e.g. -010 for -10.
  
   First we prep the local buffer with any leading zero and
   decimals that might be called for, then write the number
   down backward skipping over the decimal and skipping
   over any remaining zeroes for the minus sign.  Finally
   we write the result to the caller's buffer.
}
  bytefill(@fnumbuf," ",14)
  byte[@fnumbuf+14] := 0
  
  p := @fnumbuf + 13
  if dp > 0
    repeat dp
      byte[p] := "0"
      p--
    byte[p] := "."
    p--
    byte[p] := "0"
    p--
  elseif dp < 0
    repeat -dp
      byte[p] := "0"
      p--
  else
    byte[p] := "0"
    p--
         
  wdec(value, @fnumbuf+13)
  bytemove(ptr, @fnumbuf + 14 - len, len + 1)
  return ptr + len  
      
pri wdec(value, atloc) | s
{
  This is works like dec but writes the number to memory
  down from the starting atloc.  It will skip over a
  decimal point.  The string should be pre-loaded with
  any necessary leading zeroes and decimals.  There are
  no controls so be sure the buffer is large enough to
  handle a signed, decimalled 9-digit number.
}
  s := 0
  if value < 0
    -value
    s := "-"
    
  repeat while value <> 0
    'skip over decimal
    if byte[atloc] == "."
      atloc --
    byte[atloc] := value // 10 + "0"
    atloc --
    value /= 10

  if s
    'skip over any non space (leading zeroes)
    'before writing sign
    repeat while byte[atloc] <> " "
      atloc --
    byte[atloc] := s  