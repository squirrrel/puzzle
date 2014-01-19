Puzzle::Application.routes.draw do
  root to: "main#index"
  
  scope 'api' do
    resources :imagenes, only: [:index]
  	resources :div_containers, only: [:index]
  end 
end
