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

  count_emails: () =>
    get = "select count(*) from messages where status='programmed' or status='paused' or status='ongoing'"
    c = db.query get
    emails=0
    for k,v in pairs c
      emails=v.count
    return emails

messagesC = MessagesC!
messagesC
