Myapp::Application.routes.draw do
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products
  resources :main do
    collection do
      get 'test'
      get 'ffmpeg'
    end
  end

  resources :video do
    collection do
      get 'show'
      get 'new'
      post 'upload' 
      post '_write_to_local'
      get 'end'
      get 'get'
      post 'rewrite'
    end
  end

  resources :post do
    collection do
      get 'show'
      get 'new'
      post 'new_file'
      get 'get'
      get 'deactivate'
      get 'upload'
      get 'updater'
      post 'upload'
      post 'upload_file'
      post 'put_file'
    end
  end

  resources :text do
    collection do
      get 'show'
      get 'new'
      get 'updater'
      get 'get'
      get 'deactivate'
      get 'put_text'
    end
  end

  resources :college do
    collection do
      get 'show'
      get 'new'
      get 'get'
    end
  end

  resources :course do
    collection do
      get 'show'
      get 'new'
      get 'get'
      get 'getAllWithVideos'
    end
  end

  resources :user do
    collection do
      get 'show'
      get 'new'
      get 'get'
      get 'auth'
      get 'login'
      get 'logout'
    end
  end
  
  resources :content do
    collection do
      get 'get_content'
    end
  end

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => 'main#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
