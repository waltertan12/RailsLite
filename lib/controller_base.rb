require_relative './phase6/controller_base'
require_relative './flash'
require 'byebug'

module Sandbox
  class ControllerBase < Phase6::ControllerBase
    def self.protect_from_forgery(options = {})
      # something with the options hash
      @@protect_from_forgery = true
    end

    def flash
      @flash ||= Flash.new(req)
    end

    def redirect_to(url)
      flash.store_flash(res)
      super(url)
    end

    def render(template_name)
      flash.store_flash(res)
      super(template_name)
    end

    def protect_from_forgery?
      @@protect_from_forgery
    end

    def form_authenticity_token
      token = SecureRandom.urlsafe_base64(100)
      cookie = WEBrick::Cookie.new("authenticity_token", token.to_json)
      cookie.path = "/"
      res.cookies << cookie
      token
    end

    def invoke_action(name)
      if protect_from_forgery? && 
         req.request_method != "GET"
        if valid_authenticity_token?
          super(name)
        else
          raise "Nononononononono"
        end
      else
        super(name)
      end
    end

    def valid_authenticity_token?
      cookie = req.cookies.find { |c| c.name == "authenticity_token" }
      puts "Truly authentic experience?: #{!cookie.nil? && (params[:authenticity_token] == cookie.value)}"
      cookie && (params[:authenticity_token] == cookie.value)
    end
  end
end