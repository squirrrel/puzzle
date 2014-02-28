Puzzle::Application.routes.draw do
  root to: "main#index"
  
  scope 'api' do
    resources :categories, :imagenes, only: [:index]
    resources :sessions, only: [:index, :update, :destroy, :create]
  end 
end
