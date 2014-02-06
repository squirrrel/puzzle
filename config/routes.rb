Puzzle::Application.routes.draw do
  root to: "main#index"
  
  scope 'api' do
    resources :imagenes, :div_containers, :pieces, only: [:index, :create]
  end 
end
