class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.references :messagable, polymorphic: true
      t.integer :chat_id      
      t.string :content
      t.timestamps
    end
    add_index :messages, :chat_id
  end
end
