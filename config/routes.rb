MovieRecommendationEngine::Application.routes.draw do

resources :movies

  # # not sure if this is necessary at the moment
  # resources :movies do
  #   resources :rotten_tomatoes
  #   resources :imdb_data_points
  #   resources :tweets
  #   resources :ebert_stars
  #   resources :hsx_data_points
  # end

end
