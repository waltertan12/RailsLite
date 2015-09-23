require 'webrick'
require 'json'

class Flash
  def initialize(req)
    cookie = req.cookies.find { |c| c.name == "flash" } if req
    if cookie
      cookie.expires = 1
      @now = JSON.parse(cookie.value)
    else
      @now = {}
    end
    @flash = {}
  end

  def [](key)
    if @now.empty?
      JSON.parse(@flash.to_json)[key.to_s]
    else
      JSON.parse(@now.to_json)[key.to_s]
    end
  end

  def []=(key, value)
    @flash[key] = value
    @now[key] = value
  end

  def store_flash(res)
    res.cookies << WEBrick::Cookie.new(
      "flash",
      @flash.to_json
    )
  end

  def now
    @now
  end

  def now=(key, value)
    @now[key] = value
  end
end