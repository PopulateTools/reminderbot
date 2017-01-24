class CreateReminders < ActiveRecord::Migration[5.0]
  def change
    create_table :reminders do |t|
      t.integer :chat_id
      t.string :coded_string
      t.string :message_text
      t.text :schedule
      t.datetime :generated_jobs_until

      t.timestamps
    end
  end
end
