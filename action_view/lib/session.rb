require 'json'
require 'webrick'

class Session
  # find the cookie for this app
  # deserialize the cookie into a hash
  def initialize(req)
    # data = req.cookies.find {|c| c.name == '_rails_lite_app'}
    data = req.cookies['_rails_lite_app']
    if data && data != "{}"
      @cookie = JSON.parse(data.value)
    else
      @cookie = {}
    end
  end

  def [](key)
    @cookie[key]
  end

  def []=(key, val)
    @cookie[key] = val
  end

  # serialize the hash into json and save in a cookie
  # add to the responses cookies
  def store_session(res)
    cookie = { path: '/', value: @cookie.to_json }
    res.set_cookie("_rails_lite_app", cookie)
  end
end
