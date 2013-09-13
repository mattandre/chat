class CreateVisitors < ActiveRecord::Migration
  def change
    create_table :visitors do |t|
      t.integer :client_id, index:true
      t.string :remember_token
      t.string :ip
      t.string :browser_data
      t.string :current_url
      t.datetime :last_visit
      t.string :name
      t.string :email

      t.timestamps
    end
  end
end
