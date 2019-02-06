class UsersController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource

  def edit
    @user = current_user
  end

  def update()
    prepare_params
    if @user.update_attributes(user_params)
      redirect_to root_path
    else
      render 'edit'
    end
  end

  private
    def user_params
      params.require(:user).permit( :email, :password, :password_confirmation, :image, :remove_image)
    end

    def load_user
      user = User.find(params[:id])
    end

    def prepare_params
      if params[:user][:password].blank? && \
        params[:user][:password_confirmation].blank?
        params[:user].delete(:password)
        params[:user].delete(:password_confirmation)
    end

  end

end
