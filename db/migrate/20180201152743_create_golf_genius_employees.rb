class CreateGolfGeniusEmployees < ActiveRecord::Migration[5.1]
  def change
    create_table :golf_genius_employees do |t|
      t.string :name, index: true
      t.string :email, index: true

      t.timestamps
    end
  end
end
