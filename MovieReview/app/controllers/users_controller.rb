class UsersController < ApplicationController
before_action :find_user
before_action :authenticate_user!
  def index
  	@users = User.all
  end

  def show
    @reviews=Review.where(:user_id => @user.id)

  end
 
 def update

	if @user.update_attributes(secure_params)
		redirect_to user_path
	else
		redirect_to movie_path, :notice => 'wrong'
	end
  
  private secure_params
  	params.require(:user).permit(:role)
  end

  def find_user
    @user=User.find(params[:id])
  end  

end
