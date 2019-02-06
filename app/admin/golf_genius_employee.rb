ActiveAdmin.register GolfGenius::Employee do
# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
  permit_params :email, :name, :for_cc, :phone_number

  index do
    column :name
    column :email
    column :phone_number
    column :for_cc

    actions
  end

end
