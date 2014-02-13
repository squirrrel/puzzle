Puzzle::Application.routes.draw do
  root to: "main#index"
  
  scope 'api' do
    resources :imagenes, :pieces, only: [:index, :create, :update]
  end 
end
