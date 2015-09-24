require 'webrick'

require_relative '../active_record/lib/active_record_manifest'
require_relative '../action_view/lib/action_view_manifest'
require_relative '../app/controllers/dogs_controller'

router = Router.new
router.draw do
  get  Regexp.new("^/dogs$"), DogsController, :index
  get  Regexp.new("^/dogs/new$"), DogsController, :new
  post Regexp.new("^/dogs$"), DogsController, :create
end

server = WEBrick::HTTPServer.new(Port: 3000)
server.mount_proc('/') do |req, res|
  route = router.run(req, res)
end

trap('INT') { server.shutdown }
server.start