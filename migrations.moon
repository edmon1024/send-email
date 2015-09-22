import drop_table,drop_column,rename_column,rename_table,add_column,create_table,alter_column, types from  require "lapis.db.schema"

{
  [1]: =>
    create_table "email_queue", {
      { "id", types.serial }
      { "message_id", types.text }
      { "email", types.text }
      { "subject", types.text }
      { "message", types.text }
      { "shipping_date", types.time }
      "PRIMARY KEY (id)"
    }
    create_table "email_result", {
      { "id", types.serial }
      { "message_id", types.text }
      { "email", types.integer }
      { "subject", types.text }
      { "message", types.text }
      { "shipping_date", types.time }
      { "result", types.text }
      "PRIMARY KEY (id)"
    }
    create_table "messages", {
      { "id", types.serial }
      { "name", types.text }
      { "subject", types.text }
      { "recipients", types.text }
      { "message", types.text }
      { "shipping_date", types.time }
      { "status", types.text }
      "PRIMARY KEY (id)"
    }

}
