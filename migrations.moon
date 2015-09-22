import drop_table,drop_column,rename_column,rename_table,add_column,create_table, types from  require "lapis.db.schema"

{
  [1]: =>
    create_table "email_queue", {
      { "id", types.serial }
      { "uuid", types.text }
      { "email", types.text }
      { "shipping_date", types.text }
      { "status", types.text }
      "PRIMARY KEY (id)"
    }
    create_table "email_result", {
      { "id", types.serial }
      { "uuid", types.text }
      { "email", types.integer }
      { "shipping_date", types.boolean }
      { "result", types.text }
      "PRIMARY KEY (id)"
    }
  [2]: =>
    add_column "email_queue", "subject", types.text
    add_column "email_queue", "message", types.text
    add_column "email_result", "subject", types.text
    add_column "email_result", "message", types.text
}
