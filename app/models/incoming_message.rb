class IncomingMessage < ApplicationRecord
  serialize :content

  validates :chat_id, presence: true
  validates :message_id, presence: true
  validates :message_text, presence: true

  after_create :process

  def process
    Telegram::Bot::Client.run(ENV["REMINDER_BOT_KEY"]) do |bot|
      if message_text == '/start'
        r = bot.api.send_message(chat_id: chat_id, text: "Hola, #{self.content.from.first_name}")
        puts r
      elsif message_text == '/stop'
        bot.api.send_message(chat_id: chat_id, text: "Adiós, #{self.content.from.first_name}")
      elsif message_text == '/help'
        bot.api.send_message(chat_id: chat_id, text: help_text)
      else message_text.starts_with?('/r ')
        begin
          Reminder.create!(chat_id: chat_id, coded_string: message_text[3..-1])
          bot.api.send_message(chat_id: chat_id, text: "Guardando recordatorio...")
        rescue
          bot.api.send_message(chat_id: chat_id, text: "Error guardando recordatorio")
        end
      end
    end
  end

  private

  def help_text
<<-HELP_TEXT
Para guardar un recordatorio (dias y horas separadas por comas):
/r M,J|18:25|Mensaje que quieres recibir

HELP_TEXT
  end
end
