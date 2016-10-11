Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  namespace :api do
    resource :session, only: [:create, :destroy]
    resources :tomatoes, only: [:index, :show, :create, :update, :destroy]
    resources :projects, only: [:index, :show, :create, :update, :destroy]
  end

  resources :tags, only: [:index, :show]

  resources :projects

  resources :statistics, only: :index do
    collection do
      get 'users_by_tomatoes'
      get 'total_users_by_day'
      get 'users_by_day'
      get 'tomatoes_by_day'
    end
  end

  resources :rankings, only: :index

  resources :tomatoes do
    member do
      post 'track'
    end
  end

  resources :users, only: [:show, :edit, :update, :destroy] do
    resources :tomatoes, only: [] do
      collection do
        get 'by_day'
        get 'by_hour'
      end
    end
  end

  get '/auth/:provider/callback' => 'sessions#create'
  get '/signin/:provider' => 'sessions#new', :as => :signin
  delete '/signout' => 'sessions#destroy', :as => :signout
  get '/auth/failure' => 'sessions#failure'

  # You can have the root of your site routed with "root"
  root to: 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
