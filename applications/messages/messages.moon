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
 
  [send_email_edit: "/send_email_edit/:message_id"]: capture_errors =>
    @g_title = i_.t('message_edit_title')
    @g_route = "send"
    render: true

  [send_email_validate_edit: "/send_email_validate_edit"]: capture_errors =>
    @g_title = i_.t('message_send_title')
    @g_route = "send"
    message=messagesC\send_email_edit(@params,@session)
    @write redirect_to: @url_for("send_email_list")
 
  [send_email_erase: "/send_erase/:message_id"]: capture_errors =>
    @params.check_list = {}
    @g_title = i_.t('message_erase_title')
    @g_route = "send"
    @action = "erase_send"
    table.insert(@params.check_list,@params.message_id)
    render: "confirmTemplate"

  [send_email_paused: "/send_email_paused/:message_id"]: capture_errors =>
    @params.check_list = {}
    @g_title = i_.t('message_paused_title')
    @g_route = "send"
    @action = "paused_send"
    table.insert(@params.check_list,@params.message_id)
    render: "confirmTemplate"

  [send_email_resume: "/send_resume/:message_id"]: capture_errors =>
    @params.check_list = {}
    @g_title = i_.t('message_resume_title')
    @g_route = "send"
    @action = "resume_send"
    table.insert(@params.check_list,@params.message_id)
    render: "confirmTemplate"

  [send_action: "/send_action"]: capture_errors =>
    @g_route= "send"
    @action=nil

    if @params.erase_send != nil then
      @g_title=i_.t "send_erase_title"
      @action="erase_send"
    elseif @params.paused_send != nil then
      @g_title=i_.t "send_paused_title"
      @action="paused_send"
    elseif @params.resume_send !=nil then
      @g_title=i_.t "send_resume_title"
      @action="resume_send"
    else
      @g_title=i_.t "send_paused_title"
      yield_error i_.t('error_unknown_action')
    render: "confirmTemplate"

  [send_confirm_action: "/send_confirm_action"]: =>
    t = {}
    eml = {}
    for k,v in pairs(@params.check_list)
      table.insert(t,v)
    eml = Messages\find_all t

    if table.getn(eml)>0 then
      for k,v in pairs eml
        switch @params.action
          when "paused_send"
            v.status="paused"
            v\update "status"
          when "resume_send"
            v.status="programmed"
            v\update "status"
          when "erase_send"
            v\delete!

            campaign_emails = EmailQueue\select "where message_id=?",v.name
            if table.getn(campaign_emails)>0
              for k,v in pairs(campaign_emails)
                  v\delete!

    @write redirect_to: @url_for("send_email_list")
