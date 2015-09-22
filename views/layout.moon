import Widget from require "lapis.html"

class VB_layout extends Widget
  content: =>
    html_5 lang: @session.lang, xmlns: "http://www.w3.org/1999/xhtml", ->
      head ->
        element "link", href: "/static/css/style.css", rel: "stylesheet"
        element "link", href: "/static/css/jquery-ui.css", rel: "stylesheet"
        element "link", href: "/static/css/jquery-ui.theme.css", rel: "stylesheet"
        element "link", href: "/static/css/jquery-ui.structure.css", rel: "stylesheet"
        element "link", href: "/static/DataTables/media/css/jquery.dataTables.css", rel: "stylesheet"
        element "link", href: "/static/DateTimePicker/jquery.datetimepicker.css", rel: "stylesheet"
        element "link", href: "/static/favicon.ico", rel: "icon"
        element "script", src: "/static/js/jquery.js"
        element "script", src: "/static/js/jquery-ui.min.js"
        element "script", src: "/static/bootstrap/js/bootstrap.js"
        element "script", src: "/static/js/jq-validate/jquery.validate.js"
        element "script", src: "/static/js/jq-validate/jq-validate-bootstrap-fix.js"
        element "script", src: "/static/DataTables/media/js/jquery.dataTables.js"
        element "script", src: "/static/js/DataTables/jquery.dataTables.columnFilter.js"
        element "script", src: "/static/js/jq-validate/localization/messages_"..@session.lang..".js"
        element "script", src: "/static/DateTimePicker/jquery.datetimepicker.js"
        element "meta", name: "viewport", content: "width=device-width, initial-scale=1"
        element "meta", charset: "UTF-8"
 
        title ->
          if @g_title != " " then
            raw @g_title
          else
            raw application_name

      body ->
        @content_for "inner"
