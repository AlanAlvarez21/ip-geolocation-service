Rails.application.routes.draw do
  # Defines the root path route ("/")
  # root "posts#index"
  resources :geolocations, only: [ :index, :create, :show, :destroy ]
end
