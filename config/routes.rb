MovieRecommendationEngine::Application.routes.draw do

  resources :movies, :only => [:index, :show]

  match "/:rank" => 'movies#show'

  root to: 'movies#index'

end
