require 'webrick'
require 'byebug'
require_relative '../lib/controller_base'
require_relative '../lib/flash'
require_relative '../lib/params'
require_relative '../lib/router'
require_relative '../lib/session'

class Cat
  attr_reader :name, :owner

  def self.all
    @cat ||= []
  end

  def initialize(params = {})
    params ||= {}
    @name, @owner = params["name"], params["owner"]
  end

  def save
    return false unless @name.present? && @owner.present?

    Cat.all << self
    true
  end

  def inspect
    { name: name, owner: owner }.inspect
  end
end

class CatsController < ControllerBase
  protect_from_forgery

  def create
    @cat = Cat.new(params["cat"])
    if @cat.save
      flash[:success] = "Successfully posted cat"
      redirect_to("/cats")
    else
      flash.now[:Error] = "Cat could not be saved"
      render :new
    end
  end

  def index
    @cats = Cat.all
    render :index
  end

  def new
    @cat = Cat.new
    render :new
  end
end

router = Router.new
router.draw do
  get  Regexp.new("^/cats$"), CatsController, :index
  get  Regexp.new("^/cats/new$"), CatsController, :new
  post Regexp.new("^/cats$"), CatsController, :create
end

server = WEBrick::HTTPServer.new(Port: 3000)
server.mount_proc('/') do |req, res|
  route = router.run(req, res)
end

trap('INT') { server.shutdown }
server.start