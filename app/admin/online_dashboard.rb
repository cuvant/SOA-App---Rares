# ActiveAdmin.register_page "Online Dasbhoards" do
#   
#   content do
#     keys = $redis.keys("dashboard_*").map{ |key| key.split("_")[1] }
#     dashboards = Dashboard.includes(:user).where(id: keys)
# 
#     columns do
#       column do
#         panel "#{dashboards.size} Online Dasbhoards Stored in Redis, with the key 'dashboard_ID_online'" do
#           ul do
#             dashboards.each do |dashboard|
#               li link_to("Id: #{dashboard.id} User: #{dashboard.user.email} Number: #{DashboardTracker.sub_count(dashboard.id)}", edit_dashboard_path(dashboard))
#             end
#           end
#         end
#       end
#     end
#   end
# end
