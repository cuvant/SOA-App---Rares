class AddColumns < ActiveRecord::Migration[5.1]
  def change
    add_column :golf_genius_employees, :for_cc, :boolean, default: false
  end
end
