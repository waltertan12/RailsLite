require_relative '../action_view/lib/action_view_manifest'
require_relative '../app/controllers/dogs_controller'

router = Router.new
router.draw do
  get  Regexp.new("^/dogs$"), DogsController, :index
  get  Regexp.new("^/dogs/new$"), DogsController, :new
  post Regexp.new("^/dogs$"), DogsController, :create
end