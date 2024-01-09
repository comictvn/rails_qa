# typed: strict
module NotificationService
  class MessageNotification
    def initialize(message_id)
      @message_id = message_id
    end

    def execute
      message = Message.find_by(id: @message_id)
      return { status: :error, message: 'Message not found' } unless message

      match = Match.find_by(id: message.match_id)
      return { status: :error, message: 'Match not found' } unless match

      recipient_id = (match.user_ids - [message.sender_id]).first
      recipient = User.find_by(id: recipient_id)
      return { status: :error, message: 'Recipient not found' } unless recipient

      # Here you would implement the actual notification sending logic.
      # For example, using a mailer or a push notification service.
      # This is a placeholder for the notification logic:
      if send_notification(recipient, message.content)
        { status: :success, message: 'Notification sent' }
      else
        { status: :error, message: 'Failed to send notification' }
      end
    end

    private

    def send_notification(user, content)
      # Placeholder for sending notification logic
      true
    end
  end
end
