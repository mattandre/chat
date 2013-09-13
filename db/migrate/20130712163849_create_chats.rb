class CreateChats < ActiveRecord::Migration
  def change
    create_table :chats do |t|
      t.timestamps
    end
    add_reference :chats, :client, index: true
  end
end
