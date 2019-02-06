class WidgetsController < ApplicationController
  before_action :authenticate_user!, except: [:show]
  
  load_and_authorize_resource except: [:show, :set_form]
  load_and_authorize_resource :alerts, through: :widget, only: :edit
  load_and_authorize_resource :bound, through: :widget, singleton: true, only: :edit
  
  respond_to :html, :js

  
  def create
    begin
      @widget.save_with_hooks

      flash[:notice] = "Widget created!"
    rescue Widgets::Errors::CredentialsError, ActiveRecord::RecordInvalid => e
      @widget.destroy!
      @error = e.message
    end
  end
  
  def new
  end
  
  def edit
    @unverified_alerts = @widget.alerts.unverified
  end
  
  def update
    params[:widget].delete(:type)
    params[:widget].delete(:dashboard_id)
    initial_values = @widget.attributes

    initial_values["options"] = initial_values["options"].stringify_keys
    @widget.attributes = widget_params

    begin
      @widget.save_with_hooks
      
      flash[:notice] = "Widget updated!"
    rescue Widgets::Errors::CredentialsError, ActiveRecord::RecordInvalid => e
      # We need to convert back the hash keys from STRINGS to SYMBOLS
      initial_values["options"] = initial_values["options"].symbolize_keys
      @widget.reload
      @widget.update_attributes!(initial_values)
      @error = e.message
    end
  end
  
  def delete_widget
  end
  
  def destroy
    if @widget.destroy
      DestroyDataValuesWorker.perform_async(@widget.id)
      flash[:notice] = "Widget successfully removed!"
    else
      flash[:error] = "Can't remove widget!"
    end
  end
  
  def set_form
    @dashboard = Dashboard.where(id: params[:dashboard_id]).first
    @widget = @dashboard.widgets.new(type: params[:type])
    @widget.build_bound
  end
  
  private
  def widget_params
    params.require(:widget).permit( :type, :oauth_token, :repository, :user, :labels, :filter, :state, :dashboard_id,
                                    :application_name, :api_key, :application_id, :url, :project_id, :access_token, :branch,
                                    bound_attributes: [ :id, :lower_bound, :upper_bound],
                                    alerts_attributes: [ :id, :type, :_destroy, :email_address, :occurring_rate, :time_type, :phone_number ]
                                  )
  end
end
