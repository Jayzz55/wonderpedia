Wonderpedia::Application.routes.draw do
  devise_for :users

  resources :wikis
  
  root to: 'welcome#index'
  get 'about' => 'welcome#about'
end
