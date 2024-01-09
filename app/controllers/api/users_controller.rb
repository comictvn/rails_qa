class Api::UsersController < ApplicationController
  before_action :doorkeeper_authorize!
  before_action :set_user, only: [:update_preferences]

  def update_preferences
    authorize @user, policy_class: ApplicationPolicy

    interests = params[:interests]
    preferences = params[:preferences]

    if interests && interests.length > 500
      return render json: { error: "Interests cannot exceed 500 characters." }, status: :bad_request
    end

    if preferences && preferences.length > 500
      return render json: { error: "Preferences cannot exceed 500 characters." }, status: :bad_request
    end

    service = UserService::UpdatePreferences.new(@user.id, { interests: interests, preferences: preferences })
    result = service.execute

    case result[:status]
    when 'success'
      render json: { status: 200, message: "Preferences updated successfully." }, status: :ok
    when 'error'
      render json: { error: result[:message] }, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = User.find_by(id: params[:id])
    render json: { error: "User not found." }, status: :not_found unless @user
  end
end
