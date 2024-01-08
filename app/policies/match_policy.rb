class MatchPolicy < ApplicationPolicy
  def show?
    user.present?
  end
end

# In the BaseController (or the relevant controller for the matches action)
# before_action :authorize_match, only: [:matches]

# def authorize_match
#   authorize MatchPolicy.new(current_user, nil)
# end
