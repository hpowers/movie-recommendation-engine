MovieRecommendationEngine::Application.routes.draw do

  resources :movies, only: [:index, :show] do
    resources :theaters, only: [:show, :create]
  end
  
  root to: 'movies#index'

end