class Swipe < ApplicationRecord
  belongs_to :user

  enum direction: %w[right left], _suffix: true

  # validations

  # end for validations

  class << self
  end
end
