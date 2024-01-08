
class Api::FeedbacksController < ApplicationController
  before_action :doorkeeper_authorize!

  def create
    feedback_service = FeedbackService::Create.new(
      feedback_params[:user_id],
      feedback_params[:match_id],
      feedback_params[:comment]
    )
    result = feedback_service.call

    case result[:status]
    when :success
      render json: { status: 200, message: 'Feedback created successfully' }, status: :ok
    when :error
      render json: { status: 422, message: result[:message] }, status: :unprocessable_entity
    end
  end

  private

  def feedback_params
    params.require(:feedback).permit(:user_id, :match_id, :matched_user_id, :comment)
  end
end
