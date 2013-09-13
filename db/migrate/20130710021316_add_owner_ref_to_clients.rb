class AddOwnerRefToClients < ActiveRecord::Migration
  def change
    add_reference :clients, :owner, index: true
  end
end
