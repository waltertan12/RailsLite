require 'active_support'
require 'active_support/core_ext'
require 'active_support/inflector'
require 'erb'
# require_relative '../../config/root_path'
# require_relative 'params'
# require_relative 'session'
# require_relative 'flash'

class ControllerBase
  attr_reader :req, :res

  def self.protect_from_forgery(options = {})
    # something with the options hash
    @@protect_from_forgery = true
  end

  def initialize(req, res, route_params = {})
    @req = req
    @res = res
    @params = Params.new(req, route_params)
  end

  # Helper method to alias @already_built_response
  def already_built_response?
    @already_built_response
  end

  # Set the response status code and header
  def redirect_to(url)
    if already_built_response? 
      fail "Cannot redirect or render more than once"
    end 
    self.res['location'] = url
    self.res.status = 302

    @already_built_response = true
    
    session.store_session(res)
    flash.store_flash(res)
  end

  # Populate the response with content.
  # Set the response's content type to the given type.
  # Raise an error if the developer tries to double render.
  def render_content(content, content_type, &block)
    if already_built_response? 
      fail "Cannot redirect or render more than once"
    end  
    
    res.write(content)
    res['Content-Type'] = content_type
    @already_built_response = true
    session.store_session(res)
    flash.store_flash(res)
  end

  def render_asset(params)
    name = params["asset_name"]
    extension = params["extension"]
    folder = params["folder"]
    file = File.read("#{ROOT_PATH}app/assets/#{folder}/#{name}.#{extension}")
    extension = "javascript" if extension == "js"
    extension = "babel" if extension == "jsx"
    render_content(file, "text/#{extension}")
  end

  def render(template_name)
    file_path = "#{ROOT_PATH}app/views/#{self.class.to_s.underscore.sub("_controller","")}/#{template_name}.html.erb"

    template = File.read(file_path)
    content = ERB.new(template).result(binding)
    render_content(content, "text/html")
  end

  def session
    @session ||= Session.new(req)
  end

  def flash
    @flash ||= Flash.new(req)
  end

  def form_authenticity_token
    token = SecureRandom.urlsafe_base64(100)
    cookie = {path: "/", value: token.to_json}
    res.set_cookie("_rails_lite_app", cookie)
    token
  end

  def protect_from_forgery?
    @@protect_from_forgery
  end

  def invoke_action(name)
    if protect_from_forgery? && 
       req.request_method != "GET"
      if valid_authenticity_token?
        invoke(name)
      else
        fail "Invalid authenticity token"
      end
    else
      invoke(name)
    end
  end

  def invoke(name)
    self.send(name)
    render(name) unless already_built_response?
  end

  def params
    @params
  end

  def valid_authenticity_token?
    params[:authenticity_token] == req[:authenticity_token]
  end
end