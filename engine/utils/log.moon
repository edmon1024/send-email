log = {}

log.path = "/home/edmon/Documentos/tiendaip/desarrollo/delti/send-email/logs"
log.file = "send.log"
log.descriptor = ""

log.date = () ->
  return os.date "%Y%m%d-%H:%M"

log.start = () ->
  log.descriptor = io.open "#{log.path}/#{log.file}","a"
  io.output log.descriptor

log.w = (text) ->
  io.write "#{log.date!} #{text}\n"

log.stop = () ->
  io.close log.descriptor

return log
