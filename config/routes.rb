Rails.application.routes.draw do
  # Defines the root path route ("/")
  # root "posts#index"

  namespace :api do
    namespace :v1 do
      resources :geolocations, only: [ :index, :create, :show, :destroy ]
    end
  end
end
