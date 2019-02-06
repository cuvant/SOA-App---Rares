class AddPhoneNumber < ActiveRecord::Migration[5.1]
  def change
    add_column :golf_genius_employees, :phone_number, :string
  end
end
