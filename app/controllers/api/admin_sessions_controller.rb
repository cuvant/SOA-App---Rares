module Api
class AdminSessionsController < BaseController

  def create
    unless params[:email] && params[:password]
      return missing_params
    end

    @user = AdminUser.find_by(email: params[:email])
    if @user.present?
      if @user.valid_password? (params[:password])
        @user.authentication_token = Devise.friendly_token
        @user.save
        render_or_false(@user, "api/admin_sessions/create")
      else
        render json: "Wrong password!", status: 400
      end
    else
      render json: "The email provided is not an admin email!", status: 400
    end
  end

  protected

  def missing_params
    render json: "", status: 400
  end

end
end