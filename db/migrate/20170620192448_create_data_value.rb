class CreateDataValue < ActiveRecord::Migration[5.0]
  def change
    create_table :data_values do |t|
      t.references :widget
      t.float :value
      t.datetime :recorded_at
      t.boolean :in_bounds

      t.timestamps
    end
    
    add_index :data_values, [:widget_id, :recorded_at], unique: true
  end
end
