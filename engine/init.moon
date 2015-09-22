-- Include and Configuration script
--Setting include path
lib_path = "utils/"
package.path ..= "#{lib_path}?;#{lib_path}?.lua;#{lib_path}?.so"

--Including utils
require "postgres"
--require "luasql.postgres"
export db2 = require "db2"
export dumpvar = require "dumpvar"
export log = require "log"
export t_ = require "table"

--Setting default variables
db2.dbname = "email"
db2.dbuser = "email"
db2.dbpass = "email_2015"

--Start log and db connection
log.start!
log.w "LOG STARTED"
db2.connect!
db2.setup!

log.path = "/home/edmon/Documentos/tiendaip/desarrollo/delti/send-email/logs"
log.file = "send.log"

return
