import config from require "lapis.config"

config "production", ->
  num_workers 8
  code_cache "on"
  postgres ->
    backend "pgmoon"
    host "127.0.0.1"
    user "email"
    password "email_2015"
    database "email"
  session_name "email"
  secret "3m411_2015"

config "development", ->
  num_workers 1
  code_cache "off"
  postgres ->
    backend "pgmoon"
    host "127.0.0.1"
    user "email"
    password "email_2015"
    database "email"
  session_name "email"
  secret "3m411_2015"
