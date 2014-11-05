Wonderpedia::Application.routes.draw do
  devise_for :users
  get "welcome/index"
  get "welcome/about"
  root to: 'welcome#index'
  get 'about' => 'welcome#about'
end
