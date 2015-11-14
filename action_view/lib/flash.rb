require 'webrick'
require 'json'

class Flash
  include Enumerable

  def initialize(req)
    # debugger
    # cookie = req.cookies.find { |c| c.name == "flash" } if req
    cookie = req.cookies["flash"]
    if cookie
      @now = JSON.parse(cookie.value)
    else
      @now = {}
    end
    @flashes = {}
  end

  def [](key)
    JSON.parse(@now.to_json)[key.to_s] || 
    JSON.parse(@flashes.to_json)[key.to_s]
  end

  def []=(key, value)
    @flashes[key] = value
  end

  def store_flash(res)
    # cookie = WEBrick::Cookie.new(
    #   "flash",
    #   @flashes.to_json
    # )
    # cookie.path = "/"
    # res.cookies << cookie
  end

  def flashes
    @flashes
  end

  def now
    @now
  end

  def now=(key, value)
    @now[key] = value
  end

  def each(&block)
    @now.merge(@flashes).each(&block)
  end

  def empty?
    @flashes.empty?
  end
end