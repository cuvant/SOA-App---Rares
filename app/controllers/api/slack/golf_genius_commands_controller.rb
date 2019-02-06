class Api::Slack::GolfGeniusCommandsController < Api::BaseController

  before_action :authenticate_slack
  before_action :validate_gg_channel
  before_action :set_response_receiver

  def bugs
    BugsCommandWorker.perform_async(params.to_unsafe_h)
    render json: { response_type: @response_receiver, text: @message_text }, status: :created
  end

  def hb
    BugsCommandWorker.perform_async(params.to_unsafe_h)
    render json: { response_type: @response_receiver, text: @message_text }, status: :created
  end

  def status
    GolfGeniusStatusWorker.perform_async(params.to_unsafe_h)
    render json: { response_type: @response_receiver, text: @message_text }, status: :created
  end

  def ping
    SlackPingWorker.perform_async(params.to_unsafe_h)
    render json: { response_type: @response_receiver, text: @message_text }, status: :created
  end

  def help
    SlackHelpWorker.perform_async(params.to_unsafe_h)
    render json: { response_type: @response_receiver, text: @message_text }, status: :created
  end

end
