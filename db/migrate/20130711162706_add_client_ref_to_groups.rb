class AddClientRefToGroups < ActiveRecord::Migration
  def change
    add_reference :groups, :client, index: true
  end
end
