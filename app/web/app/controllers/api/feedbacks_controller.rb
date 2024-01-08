
class Api::FeedbacksController < ApplicationController
  # existing code...

  private

  def feedback_params
    params.require(:feedback).permit(:user_id, :match_id, :matched_user_id, :comment)
    # Replace :user_id, :match_id, :matched_user_id, :comment with actual feedback attributes
  end
end
