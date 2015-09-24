require_relative '../action_view/lib/action_view_manifest'
require_relative '../app/controllers/dogs_controller'

ROUTER = Router.new
ROUTER.draw do
  get     Regexp.new("^/dogs$"),            DogsController, :index
  get     Regexp.new("^/dogs/new$"),        DogsController, :new
  post    Regexp.new("^/dogs$"),            DogsController, :create
  get     Regexp.new("^/dogs/(?<id>\\d+)/edit$"), DogsController, :edit
  put     Regexp.new("^/dogs/(?<id>\\d+)$"),      DogsController, :update
  patch   Regexp.new("^/dogs/(?<id>\\d+)$"),      DogsController, :update
  get     Regexp.new("^/dogs/(?<id>\\d+)$"),      DogsController, :show
  delete  Regexp.new("^/dogs/(?<id>\\d+)$"),      DogsController, :destroy
end