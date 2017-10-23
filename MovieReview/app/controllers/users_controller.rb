class UsersController < ApplicationController
  def index
  	@users = User.all
  end

  def show
  	@user= user.find(params[:id])
  end
 
 def update
 	@user= User.find(params[:id])
	if @user.update_attributes(secure_params)
		redirect_to user_path
	else
		redirect_to movie_path, :notice => 'wrong'
	end
  end
  private secure_params
  	params.require(:user).permit(:role)
  end

end
