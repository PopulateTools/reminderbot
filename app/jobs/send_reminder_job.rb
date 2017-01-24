class SendReminderJob < ApplicationJob
  queue_as :default

  def perform(chat_id, message_text)
    Bot.send_message(chat_id, message_text)
  end
end
