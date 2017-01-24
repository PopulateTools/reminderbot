class IncomingMessage < ApplicationRecord
  serialize :content

  validates :chat_id, presence: true
  validates :message_id, presence: true
  validates :message_text, presence: true

  after_create :process

  def process
    Telegram::Bot::Client.run(ENV["REMINDER_BOT_KEY"]) do |bot|
      if message_text == '/start'
        bot.api.send_message(chat_id: chat_id, text: "Hola, #{self.content.from.first_name}")
        bot.api.send_message(chat_id: chat_id, text: help_text)
      elsif message_text == '/stop'
        bot.api.send_message(chat_id: chat_id, text: "Adiós, #{self.content.from.first_name}")
      elsif message_text == '/help'
        bot.api.send_message(chat_id: chat_id, text: help_text)
      elsif message_text == '/l'
        bot.api.send_message(chat_id: chat_id, text: existing_reminders(chat_id))
      elsif message_text.starts_with?('/r ')
        begin
          Reminder.create!(chat_id: chat_id, coded_string: message_text[3..-1])
          bot.api.send_message(chat_id: chat_id, text: "Guardando recordatorio...")
        rescue
          bot.api.send_message(chat_id: chat_id, text: "Error guardando recordatorio")
        end
      else
      end
    end
  end

  private

  def existing_reminders(chat_id)
    reminders = Reminder.where(chat_id: chat_id)
    if reminders.empty?
      "No tienes recordatorios guardados"
    else
      reminders.map(&:coded_string).join("\n")
    end
  end

  def help_text
<<-HELP_TEXT
Para guardar un recordatorio (dias y horas separadas por comas):
/r M,J|18:25|Mensaje que quieres recibir

Para ver los recordatorios que tienes guardados:
/l

HELP_TEXT
  end
end
