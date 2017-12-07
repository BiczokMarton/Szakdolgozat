class UsersController < ApplicationController
before_action :find_user , only: [:show, :edit, :update, :destroy]
before_action :authenticate_user!
  def index
  	
    if params[:query].present?
      @users= User.search(params[:query], fields: [:firstname, :surname])
      

    else
      @users = User.all

    end
  end

  def show
    @reviews=Review.where(:user_id => @user.id).page(params[:page]).per(3)
    @follows = []
    @user.follows.each do |id|
      @follows << User.find(id) unless User.where(id: id).empty?
    end
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
