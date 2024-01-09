# frozen_string_literal: true

module MessageService
  class Create
    attr_reader :match_id, :sender_id, :content

    def initialize(match_id, sender_id, content)
      @match_id = match_id
      @sender_id = sender_id
      @content = content
    end

    def execute
      match = Match.find_by(id: match_id)

      return { status: :error, message: 'Match not found' } if match.nil?
      return { status: :error, message: 'Sender not part of the match' } unless match.user_id == sender_id

      message = match.messages.create(sender_id: sender_id, content: content, created_at: Time.current)

      if message.persisted?
        # Notify the recipient user of the new message (pseudo code)
        # NotificationService.new(message).notify_recipient
        { status: :success, message: message }
      else
        { status: :error, message: message.errors.full_messages }
      end
    end
  end
end

# Note: The NotificationService is a placeholder for the actual implementation of the notification logic.
# It should be replaced with the actual service used in the project for sending notifications.
