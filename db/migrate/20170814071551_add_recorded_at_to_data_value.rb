class AddRecordedAtToDataValue < ActiveRecord::Migration[5.1]
  def change
    add_index :data_values, :recorded_at
    add_index :data_values, :in_bounds

    add_column :data_values, :lower_bound, :float, index: true
    add_column :data_values, :upper_bound, :float, index: true
    
    if column_exists? :data_values, :bound_id
      remove_column :data_values, :bound_id
    end
  end
end
