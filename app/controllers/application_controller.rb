class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_locale
  skip_before_action :verify_authenticity_token, if: :json_request?
  
  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.json { render json: 'Access Denied', status: :unauthorized }
      format.html { redirect_to root_path, alert: exception.message }
      format.js { flash[:notice] = exception.message; render "shared/redirect_root_path", status: :unauthorized, layout: false }
    end
  end

  def json_request?
    request.format.json?
  end

  def current_user
    User.find_by_authentication_token(params[:auth_token]) || ( warden.authenticate(scope: :user) rescue nil)
  end

  def remember_token
    data = User.serialize_into_cookie @user
    "#{data.first.first}-#{data.last}"
  end

  def after_sign_in_path_for(resource)
    root_path
  end

  private
  
  def record_not_found
    respond_to do |format|
      format.html{redirect_to root_path and return}
      format.js{render nothing: true and return}
    end
  end

  def authenticate_user_from_token!
    user_token = params[:user_token].presence
    user       = user_token && User.find_by_authentication_token(user_token.to_s)
    if user
      sign_in user, store: false
    end
  end

  def invalid_credentials
    render json: {}, status: 401
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:email, :password, :image, :password_confirmation) }
  end

  def set_locale
    I18n.locale = session[:locale] || I18n.default_locale
    session[:locale] = I18n.locale
  end

end
