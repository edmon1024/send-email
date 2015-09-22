driver = require "luasql.postgres"

db2 = {}

db2.con = nil
db2.env = nil

db2.dbname = "email"
db2.dbuser = "email"
db2.dbpass = "email_2015"

db2.connect = () ->
  con = nil
  db2.env = assert driver.postgres!
  con = assert(db2.env\connect db2.dbname,db2.dbuser,db2.dbpass)
  if con != nil
    db2.con = con
    return con
  return false

db2.exec = (sql) ->
  res = nil
  res = assert( db2.con\execute sql )
  if res != nil
    return res
  return false

db2.disconnect = () ->
  db2.con\close!
  db2.env\close!

db2.setup = () ->
  db2.exec table
  table = "CREATE TABLE IF NOT EXISTS email_result("
  table ..= "id SERIAL NOT NULL PRIMARY KEY,"
  table ..= "uuid TEXT,"
  table ..= "email TEXT,"
  table ..= "subject TEXT,"
  table ..= "message TEXT,"
  table ..= "shipping_date TEXT,"
  table ..= "status TEXT"
  table ..= ")"
  db2.exec table

db2.remove = () ->
  db2.exec "DROP TABLE IF EXISTS email_result"

return db2
