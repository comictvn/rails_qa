class User < ApplicationRecord
  has_many :user_answers, dependent: :destroy
  has_many :swipes, dependent: :destroy
  has_many :matches, dependent: :destroy

  enum gender: %w[male female other], _suffix: true

  # validations

  # end for validations

  class << self
    # Define a scope to retrieve user preferences, interests, and location
    def with_preferences_and_interests(user_id)
      select(:preferences, :interests, :location)
        .find_by(id: user_id)
    end
  end

  # Additional methods related to the User model
  # ...

end
