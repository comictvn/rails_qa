# frozen_string_literal: true

require_relative '../models/user'

module MatchingAlgorithm
  def self.calculate_compatibility(user, other_users)
    other_users.map do |other_user|
      score = calculate_score(user, other_user)
      { user: other_user, compatibility_score: score }
    end.sort_by { |match| -match[:compatibility_score] }
  end

  private

  def self.calculate_score(user, other_user)
    user_preferences = User.with_preferences_and_interests(user.id)
    other_user_preferences = User.with_preferences_and_interests(other_user.id)

    user_answers = user.user_answers.includes(:personality_question)
    other_user_answers = other_user.user_answers.includes(:personality_question)

    # Placeholder for the actual score calculation logic
    # Should compare user's preferences, interests, location, and answers to questions
    # Here you would implement the actual logic to calculate the compatibility score
    # For example, you could compare the interests and preferences, calculate the distance between locations,
    # and compare answers to personality questions to come up with a score.

    # This is a simplified example where we just return a random score
    # rand(0..100) # Random score for demonstration purposes - This line is commented out as we are using the actual score calculation below

    score = 0
    score += compare_preferences(user_preferences, other_user_preferences)
    score += compare_answers(user_answers, other_user_answers)

    # Additional logic can be added here to further refine the score based on other factors

    score
  end

  def self.compare_preferences(user_prefs, other_user_prefs)
    # Placeholder for comparing preferences logic
    # Should return a numerical value
    50 # Example score for preferences comparison
  end

  def self.compare_answers(user_answers, other_user_answers)
    # Placeholder for comparing answers logic
    # Should return a numerical value
    50 # Example score for answers comparison
  end
end
