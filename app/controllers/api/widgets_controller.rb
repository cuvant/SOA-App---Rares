module Api
class Api::WidgetsController < BaseController
  before_action :auth_only!, except: [:widget_data]
  before_action :load_widget, except: :jenkins_test_suite
  before_action :check_params, only: :jenkins_test_suite
  authorize_resource except: [:widget_data]

  def widget_data
    render json: @widget.value
  end
  
  def jenkins_test_suite
    start_time = Time.now
    ProcessJenkinsTestSuiteWorker.perform_async(params[:value], params[:branch], params[:app])
    
    RequestLog.create!( description: "Test Suite Widget. App: #{params[:app]}, branch: #{params[:branch]}.",
                        parameters: params.permit(params.keys).to_h,
                        duration: (Time.now - start_time).round(2) )

    head :ok
  end
  
  private
  def check_params
    errors = ""
    [:value, :branch, :app].each do |key|
      errors << " #{key.capitalize} blank. " if params[key].blank?
    end

    render json: { error: errors }, status: :not_found and return if errors.present?

    unless Widgets::JenkinsTestSuite.where(options: { application_name: params[:app], branch: params[:branch] }).any?
      render json: { error: "There isn't any Test Suite Widget for app: '#{params[:app]}', branch: '#{params[:branch]}'."}, status: :not_found
    end
  end

  def load_widget
    @widget = Widget.where(id: params[:id]).first
    render json: { error: "Widget not found." }, status: :not_found if @widget.blank?
  end
end
end
