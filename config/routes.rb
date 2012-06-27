MovieRecommendationEngine::Application.routes.draw do

  resources :movies,   :only => [:index, :show]
  resources :rankings, :only => [:index, :show]


  root to: 'rankings#index'

end