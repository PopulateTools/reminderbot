require 'telegram/bot'

class Api::IncomingMessagesController < Api::BaseController
  def create
    unless params[:token] == Rails.application.secrets.telegram_bot_key
      render json: {}, status: :unauthorized
      return
    end

    data = params.permit!.to_h
    update = Telegram::Bot::Types::Update.new(data)
    message = update.message

    unless existing_message = IncomingMessage.where(message_id: message.message_id).any?
      IncomingMessage.create(message_id: message.message_id, chat_id: message.chat.id, message_text: message.text, content: message)
    end

    render json: {}, status: :ok
  end
end
