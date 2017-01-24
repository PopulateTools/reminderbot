require 'telegram/bot'

class Bot
  def self.send_message(chat_id, message_text)
    api = ::Telegram::Bot::Api.new(Rails.application.secrets.telegram_bot_key)
    api.send_message(chat_id: chat_id, text: message_text)
  end
end
