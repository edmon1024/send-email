require 'posix'

filesystem = {}

filesystem.isDir = (dir) ->
  info = ""
  info = posix.sys.stat.stat(dir)
  if info != nil
    if info.type == 'directory'
      return true
  false

filesystem.createDir = (dir) ->
  return (os.execute "mkdir -p #{dir}")

filesystem
