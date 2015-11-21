class HumansController < ControllerBase
  protect_from_forgery

  # def new
  #   @dog = Dog.new
  #   render :new
  # end

  # def create
  #   @dog = Dog.new(params[:dog])

  #   if @dog.save
  #     flash[:success] = "Successfully created a new dog"
  #     redirect_to("/dogs")
  #   else
  #     flash.now[:danger] = "Dog could not be saved"
  #     render :new
  #   end
  # end

  # def edit
  #   @dog = Dog.find(params[:id])
  #   render :edit
  # end

  # def update
  #   @dog = Dog.find(params[:id])

  #   if @dog.update(params[:dog])
  #     flash[:success] = "Successfully updated a dog"
  #     redirect_to("/dogs/#{@dog.id}")
  #   else
  #     flash.now[:danger] = "Dog could not be updated"
  #     render :edit
  #   end
  # end

  def show
    @human = Human.find(params[:id])
    render :show
  end

  # def index
  #   @dogs = Dog.all
  #   render :index
  # end

  # def destroy
  #   @dog = Dog.find(params[:id])
  #   @dog.destroy
  #   redirect_to("/dogs")
  # end
end