
# frozen_string_literal: true
require 'app/models/user.rb'
require 'app/models/user_answer.rb'

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

    score = 0
    score += compare_preferences(user_preferences, other_user_preferences)
    score += compare_answers(user_answers, other_user_answers)

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
