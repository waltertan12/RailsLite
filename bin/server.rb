require 'webrick'
require_relative '../action_view/lib/action_view_manifest'
require_relative '../active_record/lib/active_record_manifest'
require_relative './include'

server = WEBrick::HTTPServer.new(Port: 3000)
server.mount_proc('/') do |req, res|
  route = ROUTER.run(req, res)
end

trap('INT') { server.shutdown }
server.start