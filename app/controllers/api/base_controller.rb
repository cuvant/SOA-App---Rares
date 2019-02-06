module Api
class BaseController < ApplicationController
  respond_to :json
  before_action :default_json

  def render_json(view_name)
    render view_name, formats: [:json], 
                     handlers: [:jbuilder], 
                       status: 200
  end
  
  # Render a JSON view, or return false (if to_check is not present)
  def render_or_false(to_check, view)
    if to_check.present?
      render_json view
    else
      render json: false, status: 200
    end
  end
  
  protected

  def auth_only!
    render json: {}, status: 401 unless current_user
  end

  def default_json
    request.format = :json if params[:format].nil?
  end

  def admin_auth!
    current_user = AdminUser.find_by_authentication_token(params[:auth_token])
    if current_user.present?
      return current_user
    else
      render json: "Not logged in!", status: 401
    end
  end

  def set_response_receiver
    if params[:text].split(' ').include?("only-me")
      @response_receiver ||= 'ephemeral'
      @message_text = 'Only vsisible by you!'
    else
      @response_receiver ||= 'in_channel'
    end
  end

  def valid_slack_token?
    params[:token] == ENV["SLACK_SLASH_COMMAND_TOKEN"]
  end

  def gg_channel?
    return true # Now all can use the Command
    params[:channel_id] == ENV["GG_CHANNEL_ID"]
  end

  def valid_private_member?
    return true # Now all can use the Command
    ENV["SLACK_PRIVATE_MEMBERS"].split('+').include?(params[:user_name])
  end

  def authenticate_slack
    return render json: {}, status: 403 unless valid_slack_token?
  end

  def validate_gg_channel
    return render json: { text: "Sorry but this command is only for Golf Genius channel / OR is not valid for you in Private Message (if you want it ask Rares)!" } unless (gg_channel? || valid_private_member?)
  end

end
end
