Wonderpedia::Application.routes.draw do
  devise_for :users

  resources :users, only: [:update]
  resources :wikis do
    resources :collaborators, only: [:index, :new, :create, :update] do
      collection do
        delete 'destroy_multiple'
      end
    end
  end
  resources :charges, only: [:new, :create]
  
  root to: 'welcome#index'
  get 'about' => 'welcome#about'


  


end
