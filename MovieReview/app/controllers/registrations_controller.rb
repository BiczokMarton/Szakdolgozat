class RegistrationsController < Devise::RegistrationsController

  private

  def sign_up_params
    params.require(:user).permit(:firstname, :surname, :email, :password, :password_confirmation)
  end

  def account_update_params
    params.require(:user).permit(:firstname, :surname, :email, :password, :password_confirmation, :current_password, :user_img, :about_me)
  end
end