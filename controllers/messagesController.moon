sha1= require 'sha1'

export class MessagesC

  send_email: (params,session) =>
    name_sha=sha1 os.date "%Y%m%d %H%M %S"
    date_programmed = os.date "%Y%m%d %H%M"

    EmailQueue\create {
      uuid: name_sha
      email: params.recipients
      subject: params.subject
      message: params.message
      shipping_date: date_programmed
      status: "programmed"
    }

    return message

  count_emails: () =>
    get = "select count(*) from email_queue where status='programmed' or status='paused' or status='ongoing'"
    c = db.query get
    emails=0
    for k,v in pairs c
      emails=v.count
    return emails

messagesC = MessagesC!
messagesC
