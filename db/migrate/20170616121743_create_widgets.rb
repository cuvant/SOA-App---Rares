class CreateWidgets < ActiveRecord::Migration[5.0]
  def change
    create_table :widgets do |t|
      t.string :type, index: true
      t.references :dashboard
      t.text :options, index: true
      t.string :name, index: true

      t.timestamps
    end
  end
end
