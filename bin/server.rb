#!/user/bin/env ruby

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
  Host: "127.0.0.1",
  Port: 3000
)