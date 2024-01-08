class Match < ApplicationRecord
  has_many :messages, dependent: :destroy

  belongs_to :user

  # validations

  # end for validations

  class << self
  end
end
