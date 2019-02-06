class AddNewColumnsToDataValues < ActiveRecord::Migration[5.1]
  def change
    add_column :data_values, :instance_count, :integer, index: true
    add_column :data_values, :total_used, :float, index: true
  end
end
