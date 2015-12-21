#!/user/bin/env ruby

require 'rack'
require_relative './include'
 
app = Proc.new do |env|
  req = Rack::Request.new(env)
  res = Rack::Response.new
  ROUTER.run(req, res)
  res.finish
end


if __FILE__ == $PROGRAM_NAME
  if ARGV[0] == "-p" && ARGV[1]
    port = ARGV[1].to_i
  else
    port = 80
  end

  Rack::Server.start(
    app: app,
    Host: "0.0.0.0",
    Port: port
  )
end
