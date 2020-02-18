Rails.application.routes.draw do
  put "scooters/:id/update", to: 'scooters#update'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
