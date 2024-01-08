
class Api::FeedbacksController < ApplicationController
  before_action :doorkeeper_authorize!

  def create
    feedback_service = FeedbackService::Create.new(*feedback_params.values_at(
      :user_id, :matched_user_id, :comment
    ))
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
    params.require(:feedback).permit(:user_id, :matched_user_id, :comment)
  end
end
