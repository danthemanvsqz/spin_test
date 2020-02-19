Rails.application.routes.draw do
  put "scooters/:id/update", to: 'scooters#update'
  put "scooters/:id/deactivate", to: 'scooters#deactivate'
  post "scooters/activate", to: 'scooters#activate'
  get "scooters/available", to: 'scooters#available'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
