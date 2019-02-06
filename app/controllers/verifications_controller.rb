class VerificationsController < ApplicationController
  respond_to :json, :js, :html
  before_action :get_alert
  
  def create
    if @alert.confirmation_token == params[:alert_token]
      @alert.mark_verified

      respond_to do |format|
        format.json { render json: {}, status: :ok }
        format.html do
          flash[:notice] = "Successfully confirmed email!"
          redirect_to edit_dashboard_path(id: @alert.widget.dashboard_id)
        end
      end
    else
      respond_to do |format|
        format.json { render json: {}, status: :unprocessable_entity }
        format.html do
          flash[:error] = "Invalid confirmation!"
          redirect_to edit_dashboard_path(id: @alert.widget.dashboard_id)
        end
      end
    end
  end
  
  def resend_verification
    sent_time = @alert.resend_instructions
    if sent_time == true
      render json: {text: "#{@alert.verification_text}" }, status: :ok
    else
      render json: "Resend again in #{sent_time} #{'minute'.pluralize(sent_time)}!", status: :unprocessable_entity
    end
  end
  
  private
  def get_alert
    unless @alert = Alert.where(id: params[:alert_id]).first
      head :not_found
    end
  end
end
