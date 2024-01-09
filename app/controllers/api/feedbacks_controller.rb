
# frozen_string_literal: true

module Api
  class FeedbacksController < BaseController
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
        render json: { status: 201, message: "Feedback submitted successfully." }, status: :created
      when :error
        render json: { status: 422, message: result[:message] }, status: :unprocessable_entity
      end
    end

    private

    def feedback_params
      params.permit(:user_id, :match_id, :comment)
    end
  end
end
