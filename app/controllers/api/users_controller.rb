module Api
class UsersController < BaseController
  before_action :auth_only!, except: [:create]
 # load_and_authorize_resource
 
  def create
    @user = User.new(user_params)
    @user.skip_confirmation!
    if @user.save
      # UserMailer.signup_confirmation(@user).deliver_now
      render_or_false(@user, "api/users/show")
    else
      render json: @user.errors.full_messages.to_sentence, status: 400 and return
    end
  end

  def update
    @user = current_user
    render json: "User not found", status: 400 and return if @user.blank?
    
    if @user.update_attributes(user_params)
      render_or_false(@user, "api/users/show")
    else
      render json: @user.errors.full_messages.to_sentence, status: 400 and return
    end
  end

  def show
    @user = User.find_by_id(params[:id])
    render_or_false(@user, "api/users/show")
  end

  protected
  def user_params
    params.require(:user) \
          .permit( :email, :password, :password_confirmation, :image,
                   :first_name, :last_name, :about_me)
  end
end
end
