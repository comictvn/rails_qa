# frozen_string_literal: true

module UserService
  class UpdatePreferences
    attr_reader :user_id, :new_preferences

    def initialize(user_id, new_preferences)
      @user_id = user_id
      @new_preferences = new_preferences
    end

    def execute
      user = User.find_by(id: user_id)
      return { status: 'error', message: 'User not found' } unless user

      if validate_preferences(new_preferences)
        user.preferences = new_preferences
        if user.save
          # Assuming MatchingAlgorithmService exists and is used to recalculate matches
          user.updated_at = Time.current
          MatchingAlgorithmService.new(user).execute
          { status: 'success', updated_preferences: user.preferences }
        else
          { status: 'error', message: user.errors.full_messages.join(', ') }
        end
      else
        { status: 'error', message: 'Invalid preferences format' }
      end
    end

    private

    def validate_preferences(preferences)
      # Implement preferences validation logic here
      true
    end
  end
end
