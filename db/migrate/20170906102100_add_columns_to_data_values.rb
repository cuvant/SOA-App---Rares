class AddColumnsToDataValues < ActiveRecord::Migration[5.1]
  def change
    add_column :data_values, :lines_covered, :integer, index: true
    add_column :data_values, :total_lines, :integer, index: true
  end
end
