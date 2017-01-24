require 'telegram/bot'

namespace :bot do
  desc "Process bot incoming messages"
  task process_incoming_messages: :environment do
    Telegram::Bot::Client.run(Rails.application.secrets.telegram_bot_key) do |bot|
      bot.fetch_updates do |message|
        puts "========"
        puts message.inspect
        puts "========"
        IncomingMessage.create(message_id: message.message_id, chat_id: message.chat.id, message_text: message.text, content: message)
      end
    end
  end

end
