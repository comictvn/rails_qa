class UserAnswer < ApplicationRecord
  belongs_to :user
  belongs_to :personality_question

  # validations

  # end for validations

  class << self
  end
end
