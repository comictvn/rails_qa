# frozen_string_literal: true

module FeedbackService
  class Create < BaseService
    attr_reader :user_id, :matched_user_id, :comment

    def initialize(user_id, matched_user_id, comment)
      @user_id = user_id
      @matched_user_id = matched_user_id
      @comment = comment
    end

    def call
      match = validate_user_and_match

      feedback = Feedback.create!(
        user_id: user_id,
        match_id: match.id, # Keep match_id from existing code
        matched_user_id: matched_user_id, # Add matched_user_id from new code
        comment: comment,
        created_at: Time.current # Keep created_at from existing code
      )

      adjust_matching_algorithm(feedback) # Use method from new code

      { status: :success, feedback: feedback }
    rescue StandardError => e
      { status: :error, message: e.message }
    end

    private

    def validate_user_and_match
      user = User.find(user_id) # Keep user find from existing code
      match = Match.find_by!(user_id: user.id, matched_user_id: matched_user_id)
      raise ActiveRecord::RecordNotFound, 'Match not found' unless match

      match # Return match object for use in the call method
    end

    def adjust_matching_algorithm(feedback)
      # Placeholder for future matching algorithm adjustment logic
      # Use the call from new code to encapsulate the logic
      MatchingService::AdjustAlgorithm.new(feedback).call
    end
  end
end
