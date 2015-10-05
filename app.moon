lapis = require "lapis"
db = require "lapis.db"

require 'init'

import respond_to,capture_errors,yield_error from require "lapis.application"

class extends lapis.Application
  layout: require "views.layout"
--  @include "applications.access.access"
--  @include "applications.users.users"
  @include "applications.messages.messages"

  @before_filter =>
    if @session.lang == nil
      @session.lang="es"
    i_.set_locale @session.lang
    prefix = routeHelper\get_application @route_name

  [dashboard: "/"]: =>
    @g_title = "Dashboard"
    @g_route = "dashboard"
    @count_messages = messagesC\count_emails!
    render: true
    
  [user_create: "/user_create"]: =>
    @g_title = "user create"
    @g_route = "dashboard"
    render: true
