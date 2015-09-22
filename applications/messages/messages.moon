lapis = require "lapis"

import respond_to,capture_errors,yield_error from require "lapis.application"
import validate_functions,assert_valid from require "lapis.validate"

class MessagesApplication extends lapis.Application
  @enable "etlua"

  [send_email: "/send_email"]: capture_errors =>
    @g_title = i_.t('message_send_title')
    @g_route = "send"
    render: true

  [send_email_validate: "/send_email_validate"]: capture_errors =>
    @g_title = i_.t('message_send_title')
    @g_route = "send"
    message=messagesC\send_email(@params,@session)
    @write redirect_to: @url_for("dashboard")

  [send_email_list: "/send_email_list"]: capture_errors =>
    @g_title = i_.t('message_send_list_title')
    @g_route = "send"
    @email_queue = Messages\select " where status='programmed' or status='paused' or status='ongoing'"
    render: true
 
  [send_edit: "/send_edit/"]: capture_errors =>
    @g_title = i_.t('message_edit_title')
    @g_route = "send"
    render: true

  [send_erase: "/send_erase/"]: capture_errors =>
    @g_title = i_.t('message_edit_title')
    @g_route = "send"
    render: true

  [send_paused: "/send_paused/"]: capture_errors =>
    @g_title = i_.t('message_edit_title')
    @g_route = "send"
    render: true

  [send_resume: "/send_resume/"]: capture_errors =>
    @g_title = i_.t('message_edit_title')
    @g_route = "send"
    render: true



--  [predefined_confirm_action: "/confirm_action"]: =>
--    t = {}
--    usrs = {}
--    for k,v in pairs(@params.check_list)
--      table.insert(t,v)
--    message_pre = MessagesPredefined\find_all t
--    
--    if table.getn(message_pre)>0 then
--      for k,v in pairs message_pre
--        logC\save @session, "log_erase_message_predefined", "("..v.id..") "..v.name
--        v\delete!
--      
--        year = string.sub(v.audio_name,1,4)
--        month = string.sub(v.audio_name,5,6)
--        os.remove(msg_path.."/"..year.."/"..month.."/"..v.audio_name)
--
--    @write redirect_to: @url_for("message_predefined_list")
