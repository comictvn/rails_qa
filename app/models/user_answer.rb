class UserAnswer < ApplicationRecord
  has_many :questions, dependent: :destroy

  belongs_to :user
  belongs_to :personality_question

  # validations

  # end for validations

  class << self
  end
end
