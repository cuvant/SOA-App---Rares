module Api
class AdminUsersController < BaseController
  before_action :admin_auth!

  def show
    @user = AdminUser.find_by_id(params[:id])
    render_or_false(@user, "api/admin_users/show")
  end

end
end