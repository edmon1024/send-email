require 'lfs'

i18n = require 'i18n'
enc = require 'utils.enc_ent'

i_ = {}

i_.langs={}
i_.directory="i18n"
i_.verbose = false

i_.set_verbose = (status) ->
  if status == "on" then
    i_.verbose = "on"
  else
    i_.verbose = nil

i_.set_dir = (dir) ->
  print "Directory set to #{dir}" if i_.verbose
  i_.directory = dir

i_.load_langs = () ->
  print "loading langs" if i_.verbose
  i_.langs = { }
  for file in lfs.dir(i_.directory) do
    if lfs.attributes(file,"mode") != "directory" then
      if iso=string.match(file,'^([%a%d]+).txt$') then
        print "found file: '"..file .."' iso: '"..iso.."'" if i_.verbose
        table.insert i_.langs, iso
        for line in io.lines(i_.directory.."/"..file) do
          key, v=string.match(line,'^%s*([^%s]+)%s*:%s*"(.+)"%s*$')
          if key then
            print "llave: '"..key.."' valor: '"..v.."'" if i_.verbose
            i18n.set(iso.."."..key,v)

i_.set_locale = (iso) ->
  i18n.setLocale iso
  print "set locale #{iso}" if i_.verbose

i_.get_langs = () ->
  i_.langs

i_.tr = (label) ->
  print "Label for translation: #{label}" if i_.verbose
  tr_label = i18n.translate(label)
  if tr_label == nil then
    return "empty"
  else
    return i18n.translate label
  print "tranlated label: "..tr_label if i_.verbose

i_.t = (label) ->
  enc.str(i_.tr(label))
  

i_.load_langs!
i_

--OLD Classes OOP
--class I18n
--  new: =>
--    @i18n = require 'i18n'
--    @enc = require 'utils.EncodeEntities'
--    @langs = { }
--    @directory="."
--    @verbose = nil
--    @load_langs!
--
--  set_verbose: (status) =>
--    if status == "on" then
--      @verbose = "on"
--    else
--      @verbose = nil
--
--  set_dir: (dir) =>
--    print "Directory set to #{dir}" if @verbose
--    @directory = dir
--
--  load_langs: =>
--    print "loading langs" if @verbose
--    @langs = { }
--    for file in lfs.dir(@directory) do
--      if lfs.attributes(file,"mode") != "directory" then
--        if iso=string.match(file,'^([%a%d]+).txt$') then
--          print "found file: '"..file .."' iso: '"..iso.."'" if @verbose
--          table.insert @langs, iso
--          for line in io.lines(@directory.."/"..file) do
--            key, v=string.match(line,'^%s*([^%s]+)%s*:%s*"(.+)"%s*$')
--            if key then
--              print "llave: '"..key.."' valor: '"..v.."'" if @verbose
--              @i18n.set(iso.."."..key,v)
--
--  set_locale: (iso) =>
--    @i18n.setLocale iso
--    print "set locale #{iso}" if @verbose
--  
--  get_langs: =>
--    @langs
--
--  tr: (label) =>
--    print "Label for translation: #{label}" if @verbose
--    tr_label = @i18n.translate(label)
--    if tr_label == nil then
--      return "empty"
--    else
--      return @i18n.translate label
--    print "tranlated label: "..tr_label if @verbose
--
--  t: (label) =>
--    print "label to translate: '#{label}'"
--    tr_label=@tr label
--    print "translated: '#{tr_label}'"
--    encoded=@enc\str tr_label
--    --result=@enc\str(@tr(label))
--    print "Encoded string: '#{encoded}'"
--    encoded
