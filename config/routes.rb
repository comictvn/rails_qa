require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  get '/health' => 'pages#health_check'
  get 'api-docs/v1/swagger.yaml' => 'swagger#yaml'

  # Define a new route for potential matches within the Api namespace
  namespace :api do
    get 'users/:id/matches', to: 'base#matches'
    put 'users/:id/preferences', to: 'users#update_preferences'
    post 'feedback', to: 'feedbacks#create'
    post 'swipes', to: 'base_controller#record_swipe' # Added from new code
  end

  # ... other routes ...
end
