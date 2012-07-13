MovieRecommendationEngine::Application.routes.draw do
  resources :data, only: [:index]

  resources :movies, only: [:index, :show, :update] do
    member do
      get 'score'
    end
    resources :theaters, only: [:show, :create]
  end

  # match "/movies/score/:id" => "movie#score"
  
  root to: 'movies#index'

end
