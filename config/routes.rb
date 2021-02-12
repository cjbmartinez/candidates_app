Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root to: 'candidates#index'
  post "/sync_candidates", to: "candidates#sync_candidates"
end
