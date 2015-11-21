#!/user/bin/env ruby

require 'webrick'
require 'rack'
require 'byebug'
require_relative './include'
 
app = Proc.new do |env|
  req = Rack::Request.new(env)
  res = Rack::Response.new
  ROUTER.run(req, res)
  res.finish
end

Rack::Server.start(
  app: app,
  # server: 'webrick',
  Port: 3000
)