Wonderpedia::Application.routes.draw do
  devise_for :users
  
  root to: 'welcome#index'
  get 'about' => 'welcome#about'
end
