Wonderpedia::Application.routes.draw do
  devise_for :users

  resources :users, only: [:update]
  resources :wikis
  
  root to: 'welcome#index'
  get 'about' => 'welcome#about'


  resources :charges, only: [:new, :create]


end
