class Route
  attr_reader :pattern, :http_method, :controller_class, :action_name

  def initialize(pattern, http_method, controller_class, action_name)
    @pattern = pattern
    @http_method = http_method
    @controller_class = controller_class
    @action_name = action_name
  end

  # checks if pattern matches path and method matches request method
  def matches?(req)
    !!(req.path =~ pattern) && req.request_method.downcase.to_sym == http_method
  end

  # use pattern to pull out route params (save for later?)
  # instantiate controller and call controller action
  def run(req, res)
    match_data = req.path.match(pattern)
    route_params = {}
    if match_data
      match_data.names.each do |name|
        route_params[name] = match_data[name]
      end
    end
    c = controller_class.new(req, res, route_params)
    c.invoke_action(action_name)
  end
end

class Router
  include Enumerable
  attr_reader :routes

  def initialize
    @routes = []
  end

  def each(env, &block)
    @routes.each do |route|
      block.call(route.run(env.request, env.response))
    end
  end

  # simply adds a new route to the list of routes
  def add_route(pattern, method, controller_class, action_name)
    @routes << Route.new(pattern, method, controller_class, action_name)
  end

  # evaluate the proc in the context of the instance
  # for syntactic sugar :)
  def draw(&proc)
    self.instance_eval(&proc)
  end

  # make each of these methods that
  # when called add route
  [:get, :post, :put, :patch, :delete].each do |http_method|
    define_method(http_method) do |pattern, controller_class, action_name|
      add_route(pattern, http_method, controller_class, action_name)
      create_helper_route(pattern, controller_class) if http_method == :get
    end
  end

  # should return the route that matches this request
  def match(req)
    params = Params.new(req)

    if req.request_method == "POST" && params[:_method]
      new_method = params[:_method].downcase.to_sym
      req.instance_variable_set("@request_method", new_method)
    end

    routes.find { |route| route.matches?(req) }
  end

  # TODO: Add helper routes method to make model_path
  def create_helper_route(pattern, controller_class)
    words = pattern.source.scan(/\/(\w+)/).flatten.reverse
    method_name = find_route_name(pattern)

    controller_class.send(:define_method, "#{method_name}") do |args = nil|
        path = "/"
        if words.length == 1
            if args
              path += "#{words[0]}/#{args.id}"
            else 
              path += "#{words[0]}"
            end
        elsif words.length == 2
          if args
            path +="#{words[1]}/#{args.id}/#{words[0]}"
          else
            path +="#{words[1]}/#{words[0]}"
          end
        end

        path
      end
  end

  def find_route_name(regexp)
    regexp.source.scan(/\/(\w+)/).flatten.reverse.join("_") + "_path"
  end

  # either throw 404 or call run on a matched route
  def run(req, res)
    matched_route = match(req)
    if matched_route
      matched_route.run(req, res)
    else
      res.body = "Not Found"
      res.status = 404
    end
  end
end
