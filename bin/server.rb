#!/user/bin/env ruby

require 'webrick'
require 'rack'
require 'byebug'
require_relative './include'

router = ROUTER
 
app = Proc.new do |env|
  req = Rack::Request.new(env)
  res = Rack::Response.new
  router.run(req, res)
  res.finish
end

# app = Proc.new do |env|
#     ['200', {'Content-Type' => 'text/html'}, ['A barebones rack app.']]
# end
 
# Rack::Handler::WEBrick.run app

Rack::Server.start(
  app: app,
  port: 3000
)

# server = WEBrick::HTTPServer.new(Port: 3000)
# server.mount_proc('/') do |req, res|
#   router = ROUTER.run(req, res)
# end

# trap('INT') { server.shutdown }
# server.start