class Permissions
  @verbose
  @session

  new: =>
    @@verbose = false

  route_has_perms: () =>
    return true

  section_has_perms: () =>
    return true

permsC = Permissions!
permsC
