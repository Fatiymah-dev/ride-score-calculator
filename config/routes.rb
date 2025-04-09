Rails.application.routes.draw do
  resources :drivers, only: [] do
    # resources :rides, only: [:index]
    resources :rides, only: [ :create, :index ]
  end
end
