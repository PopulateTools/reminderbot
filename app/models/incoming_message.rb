class IncomingMessage < ApplicationRecord
  serialize :content

  validates :chat_id, presence: true
  validates :message_id, presence: true
  validates :message_text, presence: true

  after_create :process

  def process
    if message_text == '/start'
      Bot.send_message(chat_id, "Hola, #{self.content.from.first_name}")
      Bot.send_message(chat_id, help_text)
    elsif message_text == '/stop'
      Bot.send_message(chat_id, "Adiós, #{self.content.from.first_name}")
    elsif message_text == '/help'
      Bot.send_message(chat_id, help_text)
    elsif message_text == '/l'
      Bot.send_message(chat_id, existing_reminders(chat_id))
    elsif message_text.starts_with?('/r ')
      begin
        Reminder.create!(chat_id: chat_id, coded_string: message_text[3..-1])
        Bot.send_message(chat_id, "Guardando recordatorio...")
      rescue
        Bot.send_message(chat_id, "Error guardando recordatorio")
      end
    else
      Bot.send_message(chat_id, "No te entiendo")
      Bot.send_message(chat_id, help_text)
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
/r M,X,J|18:25|Mensaje que quieres recibir

Para ver los recordatorios que tienes guardados:
/l

HELP_TEXT
  end
end
