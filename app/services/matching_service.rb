module MatchingService
  require_relative 'matching_algorithm'

  def generate_potential_matches(user_id)
    begin
      user = User.find(user_id)
      user_preferences = user.preferences
      user_interests = user.interests
      user_location = user.location

      user_answers = UserAnswer.where(user_id: user_id)

      potential_matches = User.where.not(id: user_id).map do |other_user|
        compatibility_score = MatchingAlgorithm.calculate_compatibility(user, other_user, user_answers)
        { user: other_user, score: compatibility_score }
      end

      # Sort potential matches by compatibility score
      sorted_matches = potential_matches.sort_by { |match| match[:score] }.reverse

      # Store the potential matches in a temporary data structure
      # This line is redundant as sorted_matches is already being returned
      # sorted_matches

      sorted_matches
    rescue StandardError => e
      logger.error "Error generating potential matches: #{e.message}"
      []
    end
  end
end
