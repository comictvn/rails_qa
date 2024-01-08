# typed: ignore
module Api
  require_relative '../../services/matching_service'
  class BaseController < ActionController::API
    include ActionController::Cookies
    include Pundit::Authorization

    # =======End include module======

    rescue_from ActiveRecord::RecordNotFound, with: :base_render_record_not_found
    rescue_from ActiveRecord::RecordInvalid, with: :base_render_unprocessable_entity
    rescue_from Exceptions::AuthenticationError, with: :base_render_authentication_error
    rescue_from ActiveRecord::RecordNotUnique, with: :base_render_record_not_unique
    before_action :doorkeeper_authorize!, only: [:record_swipe, :matches]
    rescue_from Pundit::NotAuthorizedError, with: :base_render_unauthorized_error

    def error_response(resource, error)
      {
        success: false,
        full_messages: resource&.errors&.full_messages,
        errors: resource&.errors,
        error_message: error.message,
        backtrace: error.backtrace
      }
    end

    private

    def base_render_record_not_found(_exception)
      render json: { message: I18n.t('common.404') }, status: :not_found
    end

    def base_render_unprocessable_entity(exception)
      render json: { message: exception.record.errors.full_messages }, status: :unprocessable_entity
    end

    def base_render_authentication_error(_exception)
      render json: { message: I18n.t('common.404') }, status: :not_found
    end

    def base_render_unauthorized_error(_exception)
      render json: { message: I18n.t('common.errors.unauthorized_error') }, status: :unauthorized
    end

    def base_render_record_not_unique
      render json: { message: I18n.t('common.errors.record_not_uniq_error') }, status: :forbidden
    end

    def custom_token_initialize_values(resource, client)
      token = CustomAccessToken.create(
        application_id: client.id,
        resource_owner: resource,
        scopes: resource.class.name.pluralize.downcase,
        expires_in: Doorkeeper.configuration.access_token_expires_in.seconds
      )
      @access_token = token.token
      @token_type = 'Bearer'
      @expires_in = token.expires_in
      @refresh_token = token.refresh_token
      @resource_owner = resource.class.name
      @resource_id = resource.id
      @created_at = resource.created_at
      @refresh_token_expires_in = token.refresh_expires_in
      @scope = token.scopes
    end

    def current_resource_owner
      return super if defined?(super)
    end

    def record_swipe
      swiper_id = params[:swiper_id]
      swiped_id = params[:swiped_id]
      direction = params[:direction]

      unless User.exists?(swiper_id)
        return render json: { message: "User not found." }, status: :bad_request
      end

      unless User.exists?(swiped_id)
        return render json: { message: "User not found." }, status: :bad_request
      end

      unless Swipe.directions.include?(direction)
        return render json: { message: "Invalid swipe direction." }, status: :unprocessable_entity
      end

      swipe_service = SwipeService::Create.new
      result = swipe_service.record_swipe_action(swiper_id: swiper_id, swiped_id: swiped_id, direction: direction)

      if result[:swipe_recorded]
        render json: { status: 201, message: "Swipe action recorded successfully." }, status: :created
      else
        render json: { message: "An unexpected error occurred." }, status: :internal_server_error
      end
    rescue StandardError => e
      render json: { message: e.message }, status: :internal_server_error
    end

    def matches
      unless params[:id].to_s.match?(/\A\d+\z/)
        return render json: { message: "Wrong format." }, status: :bad_request
      end

      # Continue with existing code if "id" is a number

      begin
        user = User.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        return render json: { message: "User not found." }, status: :not_found
      end

      begin
        potential_matches = MatchingService.new.generate_potential_matches(user.id)
        matches_response = potential_matches.map do |match|
          {
            id: match[:user].id,
            age: match[:user].age,
            gender: match[:user].gender,
            location: match[:user].location,
            interests: match[:user].interests,
            compatibility_score: match[:score]
          }
        end
        render json: { status: 200, matches: matches_response }, status: :ok
      rescue => e
        render json: { message: e.message }, status: :internal_server_error
      end
    end
  end
end
