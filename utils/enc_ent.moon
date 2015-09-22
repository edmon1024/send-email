enc_ent = {}

enc_ent.verbose = false

enc_ent.entities = {
 	'<': "&lt;"
 	'>': "&gt;"
 	-- French and spanish entities (the most common ones)
 	'à': "&agrave;"
 	'á': "&aacute;"
 	'â': "&acirc;"
 	'é': "&eacute;"
 	'è': "&egrave;"
 	'ê': "&ecirc;"
 	'ë': "&euml;"
 	'î': "&icirc;"
 	'ï': "&iuml;"
 	'í': "&iacute;"
 	'ô': "&ocirc;"
 	'ö': "&ouml;"
 	'ó': "&oacute;"
 	'ù': "&ugrave;"
 	'û': "&ucirc;"
 	'ú': "&uacute;"
 	'ÿ': "&yuml;"
 	'À': "&Agrave;"
 	'Â': "&Acirc;"
 	'Á': "&Aacute;"
 	'É': "&Eacute;"
 	'È': "&Egrave;"
 	'Ê': "&Ecirc;"
 	'Ë': "&Euml;"
 	'Î': "&Icirc;"
 	'Ï': "&Iuml;"
 	'Í': "&Iacute;"
 	'Ô': "&Ocirc;"
 	'Ö': "&Ouml;"
 	'Ó': "&Oacute;"
 	'Ù': "&Ugrave;"
 	'Û': "&Ucirc;"
 	'Ú': "&Uacute;"
 	'ç': "&ccedil;"
 	'Ç': "&Ccedil;"
 	'Ÿ': "&Yuml;"
 	'«': "&laquo;"
 	'»': "&raquo;"
 	'©': "&copy;"
 	'®': "&reg;"
 	'æ': "&aelig;"
 	'Æ': "&AElig;"
   'ñ': "&#241;"
   'Ñ': "&#209;"
 	'Œ': "&OElig;" -- Not understood by all browsers
 	'œ': "&oelig;" -- Not understood by all browsers
  '¿': "&#191;"
  '¡': "&#161;"
}

enc_ent.str = (string) ->
  print "enc_ent received: #{string}" if enc_ent.verbose
  if string == nil then
    return ''

  enc_high = (char) ->
    code = string.byte char
    if code > 127 then
      return string.format "&#%d;", code
    else
      return char

  eString = string
  eString = string.gsub eString, '&', "&amp;"
  for char, entity in pairs enc_ent.entities do
    eString = string.gsub eString, char, entity
  eString = string.gsub(eString, '(.)', enc_high)
  return eString

enc_ent.escape = (string) ->
  str_encode = ""
  print "enc_ent.escape received: #{string}" if enc_ent.verbose
  str_encode =string.gsub(string,"[%(%)%.%%%+%-%*%?%[%]%^%$]", "%%%0")
  str_encode
  

enc_ent

