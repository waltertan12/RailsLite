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

#### Flash
Flash is a temporary way to pass primitive types (Strings, Symbols, Arrays) between controller actions. Anything inserted into the Flash will be available on the next action and the action after that. If you only want the data to persist for the next action, use Flash.now.

````Ruby
# Controller
class DogsController
  def create
    @dog = Dog.new(params[:dog])

    if @dog.save
      flash[:success] = "Dog successfully created!"
      redirect_to :index
    else
      flash.now[:danger] = "Dog could not be saved!"
      render :new
    end
  end
end

# dogs/index.html.erb
<ul>
  <% flash.each do |type, message| %>
    <div class="alert alert-<%= type %>">
      <li><%= message %></li>
    </div>
  <% end %>
</ul>
````