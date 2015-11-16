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

Rack::Server.start(
  app: app,
  port: 3000
)