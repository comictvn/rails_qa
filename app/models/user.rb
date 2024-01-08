class User < ApplicationRecord
  has_many :user_answers, dependent: :destroy
  has_many :swipes, dependent: :destroy
  has_many :matches, dependent: :destroy

  enum gender: %w[male female other], _suffix: true

  # validations

  # end for validations

  class << self
  end
end
