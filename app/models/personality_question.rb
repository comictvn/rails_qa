class PersonalityQuestion < ApplicationRecord
  has_many :user_answers, dependent: :destroy

  # validations

  # end for validations

  class << self
  end
end
