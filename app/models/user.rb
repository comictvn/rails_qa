class User < ApplicationRecord
  has_many :user_answers, dependent: :destroy
  has_many :swipes, dependent: :destroy
  has_many :matches, dependent: :destroy

  enum gender: %w[male female other], _suffix: true

  # validations
  validates :age, numericality: { only_integer: true, greater_than_or_equal_to: 18, less_than_or_equal_to: 100, message: I18n.t('activerecord.errors.messages.not_an_integer') }
  validates :gender, inclusion: { in: genders.keys, message: I18n.t('activerecord.errors.messages.in', count: genders.keys.join(', ')) }
  validates :location, presence: true, length: { maximum: 255, message: I18n.t('activerecord.errors.messages.too_long', count: 255) }
  validates :interests, length: { maximum: 1000, message: I18n.t('activerecord.errors.messages.too_long', count: 1000) }
  validates :preferences, length: { maximum: 1000, message: I18n.t('activerecord.errors.messages.too_long', count: 1000) }
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
