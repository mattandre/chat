class AddClientRefToUsers < ActiveRecord::Migration
  def change
    add_reference :users, :client, index: true
  end
end
