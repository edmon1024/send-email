class RouteHelper
  @verbose: false
  get_application: (g_route) =>
    if g_route != nil
      if not string.match(g_route,"._.")
        print "Regresando g_route #{g_route}" if @@verbose
        return g_route
      else
        result = string.match(g_route,"^([%a%d]+)_")
        print "Application: '#{result}'" if @@verbose
        return result
    return false

routeHelper=RouteHelper!
routeHelper
