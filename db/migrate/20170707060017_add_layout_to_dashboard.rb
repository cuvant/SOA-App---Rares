class AddLayoutToDashboard < ActiveRecord::Migration[5.1]
  def change
    add_column :dashboards, :layout, :text
    
    add_index :dashboards, :layout
  end
end
