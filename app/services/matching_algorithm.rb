# frozen_string_literal: true

module MatchingAlgorithm
  def self.calculate_compatibility(user, other_users)
    # Assuming that there is a method to calculate the compatibility score
    # This is a placeholder for the actual matching algorithm
    other_users.map do |other_user|
      score = calculate_score(user, other_user)
      { user: other_user, compatibility_score: score }
    end.sort_by { |match| -match[:compatibility_score] }
  end

  private

  def self.calculate_score(user, other_user)
    # Placeholder for the actual score calculation logic
    # Should compare user's preferences, interests, location, and answers to questions
    rand(0..100) # Random score for demonstration purposes
  end
end
