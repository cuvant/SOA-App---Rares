class CreateBounds < ActiveRecord::Migration[5.1]
  def change
    create_table :bounds do |t|
      t.float :upper_bound, index: true
      t.float :lower_bound, index: true
      t.references :widget
      
      t.timestamps
    end
  end
end
