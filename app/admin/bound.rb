# ActiveAdmin.register Bound do
# # See permitted parameters documentation:
# # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#   actions :all, :except => :destroy
#   scope :all
#   scope :active
#   scope :incative
# 
#   permit_params do
#     permitted = [:lower_bound, :upper_bound, :active]
#     permitted << :widget_type if params[:action] == 'create'
#     permitted
#   end
# 
# 
#   index do
#     column :id
#     column :widget_type
#     column :lower_bound
#     column :upper_bound
#     column :active
#     column :created_at
#     column :updated_at
# 
#     actions
#   end
# 
#   form do |f|
#     f.inputs "Bound Details" do
#       if f.object.new_record?
#         f.input :widget_type, as: :select, label: "Type Rares", collection: Widget::TYPES.map{|x| ["#{x[:provider]} #{x[:label]}", "#{x[:type]}"]}, include_blank: false, 
#           hint: "If already exists a bound for the selected type, it will be marked as inactive. The newly created one will automatically be used."
#       else
#         f.input :widget_type, input_html: { disabled: true }
#       end
#       
#       f.input :lower_bound
#       f.input :upper_bound
#       
#       if !f.object.new_record? && !f.object.active?
#         f.input :active,
#           hint: "Marking this bound as active will set the current active bound for #{f.object.widget_type} as inactive."
#       end
#     end
#     f.actions
#   end
#   
# 
#   controller do
#     def bound_params
#       params.require(:bound).permit(:lower_bound, :upper_bound, :active, :widget_type)
#     end
#     
#     def update
#       bound = Bound.where(id: params[:id]).first
#       
#       begin
#         bound.update_attributes!(bound_params)
#       rescue ActiveRecord::RecordNotUnique => e
#         Bound.where(widget_type: bound.widget_type, active: true).first.update_column(:active, false)
#         bound.update_attributes!(bound_params)
#       end
#       
#       flash[:notice] = "Bound updated successfully!"
#       redirect_to admin_bound_path(bound)
#     end
# 
#     def create
#       bound = Bound.new(bound_params)
#       bound.active = true
#       
#       begin
#         bound.save!
#       rescue ActiveRecord::RecordNotUnique => e
#         Bound.where(widget_type: bound.widget_type, active: true).first.update_column(:active, false)
#         bound.save!
#       end
#       
#       redirect_to admin_bounds_path
#     end
#   end
# end
