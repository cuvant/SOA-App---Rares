class DashboardsController < ApplicationController
  before_action :authenticate_user!, except: [:show, :save_layout]
  load_and_authorize_resource
  respond_to :html, :js
  
  def new
  end
  
  def create
    @dashboard = Dashboard.new(dashboard_params)
    @dashboard.user = current_user
    
    if @dashboard.save
      flash[:notice] = "Dashboard created!"
    end
  end
  
  def edit
    @widgets = @dashboard.widgets.includes(:bound).order(:created_at)
  end
  
  def update
    if @dashboard.update_attributes(dashboard_params)
      flash[:notice] = "Dashboard updated!"
    end
  end
  
  def index
    @dashboards = current_user.dashboards.includes(:widgets).paginate(page: params[:page] || "1").order('created_at DESC')
  end
  
  def show
    render :show, layout: "dashboard"
  end
  
  def save_layout
    @dashboard.update_column(:layout, ActiveSupport::JSON.decode(params["layout"]))
    head :ok, content_type: "js"
  end
  
  def delete_dashboard
  end
  
  def destroy
    if @dashboard.destroy
      flash[:notice] = "Dashboard successfully removed!"
    else
      flash[:error] = "Can't remove dashboard!"
    end
    
    redirect_to dashboards_path
  end
  
  private
  
  def dashboard_params
    params.require(:dashboard).permit(:name, :description)
  end
end
