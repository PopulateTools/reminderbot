class CreateIncomingMessages < ActiveRecord::Migration[5.0]
  def change
    create_table :incoming_messages do |t|
      t.integer :message_id
      t.integer :chat_id
      t.string :message_text
      t.text :content

      t.timestamps
    end
  end
end
