require "init"

scheduler = {}
scheduler.buffer_available = ""
scheduler.green_status = "programmed|ongoing"
scheduler.rate = 1.8
scheduler.popper = {}

scheduler.verbose = 'yes'

scheduler.pdebug = (text) ->
  if scheduler.verbose = 'yes'
    print "Scheduler=> "..text.."\n"

scheduler.ddebug = (table) ->
  if scheduler.verbose = 'yes'
    print "Scheduler Dump=> "
    dumpvar.print table

scheduler.current_date = () ->
  date = os.date "%Y-%m-%d %H:%M:00"
  return date

scheduler.db_init = () ->
  db2.connect!
  db2.setup!

scheduler.ensamble_sql = () ->
  scheduler.buffer_available=phone_buffer.available!
  query_limit = math.floor(tonumber(scheduler.buffer_available) * scheduler.rate)
  scheduler.pdebug "Calculated limit: #{query_limit}"
  if query_limit < 5 and query_limit != 0
    query_limit += 2
  scheduler.pdebug "Corrected limit: #{query_limit}"
  log.w "Getting '#{query_limit}' rows from queue"
  --sql = "SELECT DISTINCT ON (phone_queue.contact_id) "
  sql = "SELECT "
  sql ..= "phone_queue.id,"
  sql ..= "phone_queue.campaign_id,"
  sql ..= "phone_queue.priority,"
  sql ..= "phone_queue.audio_name,"
  sql ..= "phone_queue.shipping_date,"
  sql ..= "phone_queue.phone,"
  sql ..= "phone_queue.contact_id,"
  sql ..= "phone_queue.dialing_order,"
  sql ..= "campaigns_status.status "
  sql ..= "FROM phone_queue "
  sql ..= "INNER JOIN campaigns_status "
  sql ..= "ON (phone_queue.campaign_id = campaigns_status.campaign_id) "
  sql ..= "WHERE phone_queue.shipping_date <= '#{scheduler.current_date!}' "
  sql ..= "AND campaigns_status.status ~ '#{scheduler.green_status}' "
  --sql ..= "ORDER BY phone_queue.contact_id ASC, "
  sql ..= "ORDER BY "
  sql ..= "phone_queue.priority ASC, "
  sql ..= "phone_queue.dialing_order ASC "
  sql ..= "LIMIT #{query_limit}"
  return sql

scheduler.get_popper = () ->
  scheduler.popper = {}
  cur = db2.exec scheduler.ensamble_sql!
  row = cur\fetch {}, "a"
  while row
    if type(scheduler.popper[row.contact_id]) == 'nil'
      scheduler.popper[row.contact_id]={}
      scheduler.popper[row.contact_id]['id']=row.id
      scheduler.popper[row.contact_id]['phone']=row.phone
      scheduler.popper[row.contact_id]['contact_id']=row.contact_id
      scheduler.popper[row.contact_id]['campaign_id']=row.campaign_id
      scheduler.popper[row.contact_id]['dialing_order']=row.dialing_order
      scheduler.popper[row.contact_id]['status']=row.status
      scheduler.popper[row.contact_id]['priority']=row.priority
      scheduler.popper[row.contact_id]['shipping_date']=row.shipping_date
      scheduler.popper[row.contact_id]['audio_name']=row.audio_name
    row = cur\fetch row, "a"
  scheduler.pdebug "Showing popper"
  scheduler.ddebug scheduler.popper
  return scheduler.popper

scheduler.filter_popper = () ->
  buffer = phone_buffer.get!
  for k,v in pairs scheduler.popper
    if buffer
      if type(buffer[k]) == 'table'
        scheduler.pdebug "Contact #{k} in call, deleted from popper"
        scheduler.popper[k] = nil
  scheduler.ddebug scheduler.popper

scheduler.insert_popper = () ->
  for k,v in pairs scheduler.popper
    scheduler.pdebug "Inserting record #{k}"
    scheduler.ddebug v
    if scheduler.buffer_available > 0
      sql =   "INSERT INTO phone_buffer "
      sql ..= "(campaign_id,"
      sql ..= "contact_id,"
      sql ..= "number,"
      sql ..= "file,"
      sql ..= "gateway,"
      sql ..= "status,"
      sql ..= "available) "
      sql ..= "VALUES ("
      sql ..= "'#{v.campaign_id}',"
      sql ..= "#{v.contact_id},"
      sql ..= "'#{v.phone}',"
      sql ..= "'#{v.audio_name}',"
      sql ..= "1,"
      sql ..= "'INITIAL',"
      sql ..= "'no')"
      scheduler.pdebug "sql: '#{sql}'"
      if db2.exec sql
        scheduler.queue_pop(v.id)
        scheduler.buffer_available -= 1
    else
      break

scheduler.queue_pop = (id) ->
  sql =   "DELETE FROM phone_queue "
  sql ..= "WHERE id = #{id}"
  scheduler.ddebug db2.exec sql

scheduler.insert_buffer = () ->
  scheduler.pdebug "getting popper"
  scheduler.get_popper!
  scheduler.pdebug "filtering popper"
  scheduler.filter_popper!
  scheduler.pdebug "inserting popper"
  scheduler.insert_popper!


------ change programmed > finished  -----------


scheduler.q = () ->
  q = "SELECT "
  q ..= "id,"
  q ..= "campaign_id,"
  q ..= "shipping_date,"
  q ..= "status "
  q ..= "FROM campaigns_status "
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
    if type(scheduler.end[row.campaign_id]) == 'nil'
      scheduler.end[row.campaign_id]={}
      scheduler.end[row.campaign_id]['id']=row.id
      scheduler.end[row.campaign_id]['campaign_id']=row.campaign_id
      scheduler.end[row.campaign_id]['status']=row.status
      scheduler.end[row.campaign_id]['shipping_date']=row.shipping_date
    row = cur\fetch row, "a"
  return scheduler.end

scheduler.filter = () ->
  for k,v in pairs scheduler.end
    q2 = "SELECT count (*) from phone_queue where campaign_id='#{v.campaign_id}'"
    if db2.exec q2
--      if num ~= 0
--        dumpvar.print "sin phone_queue: --------------- #{v.campaign_id}"
--        break
--      if num == 0
      dumpvar.print "Campaigns to remove  #{v.campaign_id}"
      scheduler.search(v.campaign_id)
    else
      break

scheduler.search = (id) ->
  query = "select count (*) from phone_buffer where campaign_id='#{id}' and available='yes'"
  if db2.exec query
    dumpvar.print id
    q2 = "update campaigns_status set status='finished' where campaign_id='#{id}'"
    db2.exec q2
    dumpvar.print "Remove: '#{id}'"

----- end change status --------


scheduler.close = () ->
  log.w "LOG STOP"
  log.stop!
  db2.disconnect!

scheduler.insert_buffer!
phone_buffer.call!
phone_buffer.events!
dumpvar.print scheduler.finished!
dumpvar.print scheduler.filter!
scheduler.close!
