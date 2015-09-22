-- global variables and classes
export lapis = require "lapis"
export db = require "lapis.db"
export app_path = "/home/edmon/Documentos/tiendaip/desarrollo/delti/send-email"
export application_name = "Email"

--utils
-- Loading i18n class
export i_ = require "utils.i18n"
i_.set_dir app_path.."/i18n"
i_.load_langs!
-- Loading table set
export t_ = require "utils.table"
-- encoding entities
export enc_ent = require "utils.enc_ent"
-- dumpvar
export dumpvar = require "utils.dumpvar"
-- Route Helper
export routeHelper = require "utils.routeHelper"

-- Loading menu classes
--export menu = require "controllers.menuController"

-- Filesystem
export filesystem = require "utils.filesystem"

-- Loading controllers
--export usersC = require "controllers.usersController"
--export logC = require "controllers.logController"
export messagesC = require "controllers.messagesController"

--Import Data models
require "models.EmailQueue"
require "models.EmailResult"
require "models.Messages"

-- default configuration
export default_lang = "es"
