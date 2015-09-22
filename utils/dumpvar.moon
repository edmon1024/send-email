dumpvar = {}

dumpvar.browser = (d) ->
  buffer = ""
  buffer = dumpvar._int d, 0, "browser"
  buffer
 
dumpvar.print = (d) ->
  buffer = "\n\n"
  buffer ..= dumpvar._int d, 0, "print"
  print buffer
  buffer

dumpvar._int = (d, depth, output) ->
  buffer = ""
  tablecache = {}
  cr = ""
  padder = ""
  str = ""

  switch output
    when "browser"
      padder = "&nbsp;&nbsp;&nbsp;"
      cr = "<br>"
    else
      padder = "   "
      cr = "\n"

  t = type(d)
  str = tostring(d)
  if t == "table" then
    if tablecache[str] then
      buffer ..= "<"..str..">"..cr
    else
      tablecache[str] = (tablecache[str] or 0 ) + 1
      buffer ..= "("..str..") {"..cr
      for k,v in pairs d do
        buffer ..= string.rep(padder, depth+1).."["..k.."] => "
        buffer ..= dumpvar._int v, depth+1, output
      buffer ..= string.rep(padder,depth).."}"..cr
  elseif t == "number" then
    buffer ..= "("..t..") "..str..cr
  else
    buffer ..= "("..t..") \""..str.."\""..cr
  buffer

dumpvar
