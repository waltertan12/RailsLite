require_relative '../../action_view/lib/action_view_manifest'
require_relative '../../active_record/lib/active_record_manifest'
require_relative '../models/dog'

class DogsController < ControllerBase
  protect_from_forgery

  def create
    @dog = Dog.new(params["dog"])
    puts "Is the dog valid? #{Dog.valid?(@dog)}"
    p params
    p @dog
    if @dog.save
      flash[:success] = "Successfully created a new dog"
      redirect_to("/dogs")
    else
      flash.now[:danger] = "Dog could not be saved"
      render :new
    end
  end

  def new
    @dog = Dog.new
    render :new
  end

  def index
    @dogs = Dog.all
    render :index
  end
end