class AddFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :title, :string
    add_column :users, :set_password_token, :string
    add_column :users, :active, :boolean, default: false
    add_column :users, :ip, :string
    add_column :users, :accept_chats, :boolean, default: false
    add_column :users, :chat_limit, :integer, default: 5
  end
end
