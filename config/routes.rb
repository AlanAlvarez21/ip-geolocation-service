Rails.application.routes.draw do
  
  resources :users, only: [:create]
  namespace :auth do
    post '/login', to: 'sessions#create'
    delete '/logout', to: 'sessions#destroy'
  end

  namespace :api do
    namespace :v1 do
      resources :geolocations, only: [ :index, :create, :show, :destroy ]
    end
  end
end
