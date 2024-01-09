module UserService
  class UpdateProfile < BaseService
    attr_reader :user_id, :profile_params

    def initialize(user_id, profile_params)
      @user_id = user_id
      @profile_params = profile_params
    end

    def call
      user = User.find_by(id: user_id)
      raise ActiveRecord::RecordNotFound, "User not found" unless user

      validate_profile_params

      user.update!(profile_params)

      update_user_answers(user) if profile_params[:answers]

      user.update!(profile_complete: true)

      { status: 'Profile completed', user: user }
    rescue StandardError => e
      logger.error "Failed to update user profile: #{e.message}"
      { status: 'Profile update failed', error: e.message }
    end

    private

    def validate_profile_params
      # Implement validation logic here
    end

    def update_user_answers(user)
      profile_params[:answers].each do |answer|
        question_id = answer[:question_id]
        user.user_answers.find_or_initialize_by(personality_question_id: question_id).update!(answer: answer[:answer])
      end
    end
  end
end
