Puzzle::Application.routes.draw do
  root to: "main#index"
  
  scope 'api' do
    resources :imagenes, :pieces, :sessions, only: [:index, :create, :update, :destroy]
  end 
end
