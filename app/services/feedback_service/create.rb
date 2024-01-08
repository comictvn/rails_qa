# frozen_string_literal: true

module FeedbackService
  class Create < BaseService
    attr_reader :user_id, :match_id, :comment

    def initialize(user_id, match_id, comment)
      @user_id = user_id
      @match_id = match_id
      @comment = comment
    end

    def call
      validate_user_and_match

      feedback = Feedback.create!(
        user_id: user_id,
        match_id: match_id,
        comment: comment,
        created_at: Time.current
      )

      # Placeholder for future matching algorithm adjustment logic

      { status: :success, feedback: feedback }
    rescue StandardError => e
      { status: :error, message: e.message }
    end

    private

    def validate_user_and_match
      User.find(user_id)
      Match.find(match_id)
    end
  end
end
