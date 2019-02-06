class CreateDashboards < ActiveRecord::Migration[5.0]
  def change
    create_table :dashboards do |t|
      t.references :user
      t.string :name, index: true
      t.text :description

      t.timestamps
    end
  end
end
