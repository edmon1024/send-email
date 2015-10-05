sha1= require 'sha1'

export class MessagesC

  send_email: (params,session) =>
    name_sha=sha1 os.date "%Y%m%d %H%M %S"

    date_programmed=""
    if params.send_pro == "1"
      date_programmed = os.date "%Y%m%d %H%M"
    if params.send_pro == "2"
      date_programmed = params.datetimepicker

    n= 1
    recipients={}
    recipients[n]={}
    for x in string.gmatch(params.recipients, "[^,]+") do
      x = string.gsub(x,"^%s*(.-)%s*$", "%1")
      recipients[n]=x
      n=n+1
  
    Messages\create {
      name: name_sha
      subject: params.subject
      recipients: params.recipients
      message: params.message
      shipping_date: date_programmed
      status: "programmed"
    }
  
    for k,v in pairs (recipients)
      if table.getn(recipients)>0
        EmailQueue\create {
          message_id: name_sha
          email: v
          subject: params.subject
          message: params.message
          shipping_date: date_programmed
        }

    return message

  send_email_edit: (params,session) =>
    date_programmed=""
    if params.send_pro == "1"
      date_programmed = os.date "%Y%m%d %H%M"
    if params.send_pro == "2"
      date_programmed = params.datetimepicker

    n= 1
    recipients={}
    recipients[n]={}
    for x in string.gmatch(params.recipients, "[^,]+") do
      x = string.gsub(x,"^%s*(.-)%s*$", "%1")
      recipients[n]=x
      n=n+1
  
    message = Messages\find name: params.name
    message.subject = params.subject
    message.recipients = params.recipients
    message.message = params.message
    message.shipping_date = date_programmed
    message.status = "programmed"
    message\update "subject","recipients","message","shipping_date","status"
 
    dif={}
    num_dif=1
    for k,v in pairs (recipients)
      if table.getn(recipients)>0
        email = EmailQueue\select "where email=? and message_id=?",v,params.name
        dif[num_dif]={}
        if table.getn(email)==0
          EmailQueue\create {
            message_id: params.name
            email: v
            subject: params.subject
            message: params.message
            shipping_date: date_programmed
          }
          dif[num_dif]['email']=v
          num_dif=num_dif+1
        if table.getn(email)>0
          for k2,v2 in pairs email
            v2.subject = params.subject
            v2.message = params.message
            v2.shipping_date = date_programmed
            v2\update "subject","message","shipping_date"
            dif[num_dif]['email']=v
            num_dif=num_dif+1

    email_list = ""
    for k,v in pairs dif
      if email_list == ""
        email_list="'"..v.email.."'"
      else
        email_list=email_list..",".."'"..v.email.."'"

    delete_emails = "delete from email_queue where email not in (#{email_list}) and message_id='#{params.name}'"
    db.query delete_emails

    return message

  count_emails: () =>
    get = "select count(*) from messages where status='programmed' or status='paused' or status='ongoing'"
    c = db.query get
    emails=0
    for k,v in pairs c
      emails=v.count
    return emails

messagesC = MessagesC!
messagesC
