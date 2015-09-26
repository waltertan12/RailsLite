#!/user/bin/env ruby

require 'webrick'
require_relative './include'

server = WEBrick::HTTPServer.new(Port: 3000)
server.mount_proc('/') do |req, res|
  route = ROUTER.run(req, res)
end

trap('INT') { server.shutdown }
server.start
