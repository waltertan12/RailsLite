# Action View Lite
Action View Lite is a reimplementation of some of ActionViews's core features, namely, routing, generating controller actions, rendering views, flash, and CSRF attack prevention.

#### Router
Routes are generated in a `draw` block and consist of four parts:
  - HTTP request
  - A regular expression describing the route
  - The controller reponsible for the action
  - The name of the action

An example is provided below:

````Ruby
ROUTER = Router.new
ROUTER.draw do
  get     Regexp.new("^/$"),           ModelsController, :index
  get     Regexp.new("^/models$"),     ModelsController, :index
  get     Regexp.new("^/models/new$"), ModelsController, :new
  post    Regexp.new("^/models$"),     ModelsController, :create
  get     Regexp.new("^/models/(?<id>\\d+)/edit$"), ModelsController, :edit
  put     Regexp.new("^/models/(?<id>\\d+)$"),      ModelsController, :update
  patch   Regexp.new("^/models/(?<id>\\d+)$"),      ModelsController, :update
  get     Regexp.new("^/models/(?<id>\\d+)$"),      ModelsController, :show
  delete  Regexp.new("^/models/(?<id>\\d+)$"),      ModelsController, :destroy
end
````