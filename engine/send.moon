require "init"

scheduler = {}
scheduler.green_status = "programmed"

scheduler.current_date = () ->
  date = os.date "%Y-%m-%d %H:%M:00"
  return date

scheduler.db_init = () ->
  db2.connect!
  db2.setup!

scheduler.q = () ->
  q = "SELECT "
  q ..= "id,"
  q ..= "uuid,"
  q ..= "email,"
  q ..= "subject,"
  q ..= "message,"
  q ..= "shipping_date,"
  q ..= "status "
  q ..= "FROM email_queue "
  q ..= "WHERE shipping_date<'#{scheduler.current_date!}' "
  q ..= "AND status='programmed' "
  q ..= "ORDER BY "
  q ..= "id"
  return q

scheduler.finished = () ->
  scheduler.end = {}
  cur = db2.exec scheduler.q!
  row = cur\fetch {}, "a"
  while row
    os.execute 'echo "Prueba de correo desde postfix" | mail -s "Test Postfix" edmon.af@gmail.com'
  return scheduler.end

dumpvar.print scheduler.finished!
--dumpvar.print scheduler.filter!
scheduler.close!
