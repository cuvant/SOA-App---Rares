class CreateRequestLogs < ActiveRecord::Migration[5.1]
  def change
    create_table :request_logs do |t|
      t.integer :widget_id
      t.string :description
      t.text :parameters
      t.float :duration
      
      t.timestamps
    end
  end
end
