class CreateAlerts < ActiveRecord::Migration[5.1]
  def change
    if table_exists?(:bounds)
      drop_table :bounds
    end

    if table_exists?(:alerts)
      drop_table :alerts
    end

    create_table :alerts do |t|
      t.string :type, index: true
      t.references :widget
      t.integer :occurring_rate, index: true
      t.string :time_type, index: true
      t.datetime :last_sent, index: true
      t.string :phone_number, index: true
      t.string :email_address, index: true
      t.boolean :verified, default: false, index: true
      t.string :confirmation_token, index: true
      t.datetime :confirmation_sent_at, index: true
      t.datetime :confirmed_at
      
      t.timestamps
    end
  end
end
