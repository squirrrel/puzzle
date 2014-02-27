Puzzle::Application.routes.draw do
  root to: "main#index"
  
  scope 'api' do
    resources :categories, only: [:index]
    resources :imagenes, only: [:index, :create]
    resources :sessions, only: [:index, :update, :destroy]
  end 
end
