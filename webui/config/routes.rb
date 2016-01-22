Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'welcome#index'
  post 'login' => 'welcome#index'
  get 'logout' => 'welcome#logout'
  get 'api/auth' => 'api#auth'
  post 'api/auth' => 'api#validate'
  post 'api/parse' => 'api#parse'
  #get 'home' => "welcome#home"
  
  #get  'createnewinstance' => 'welcome#createnewinstance'
  #post  'createnewinstance' => 'welcome#savenewinstance'
  #post 'upload' => 'file#upload'

  get 'logs' => 'logs#index'
  get 'logs/instances/:id' => 'logs#instances', as: :logs_instances
  get 'logs/mappings/:id' => 'logs#mappings', as: :logs_mappings
  get 'logs/users/:id' => 'logs#users', as: :logs_users
  
  #resources :users
  resources :instances do
    resources :users
    resources :mappings do
      get 'newuser' => 'mappings#newuser', as: :new_user
      post 'newuser' => 'mappings#saveuser', as: :save_user
      get 'deleteuser' => 'mappings#deleteuser', as: :delete_user
      post 'deleteuser' => 'mappings#removeuser', as: :remove_user
      get 'fields/:id' => "fields#new" , as: :fields_new
      get 'fields/:id/edit' => "fields#edit" , as: :fields_edit
      put 'fields/' => "fields#update" , as: :fields_update
      post 'fields/import' => "fields#import"
      post 'fields/:id/save' => "fields#save", as: :fields_save 
      get 'fields/:id/newuser' => 'fields#newuser', as: :fields_new_user
      post 'fields/:id/newuser' => 'fields#adduser', as: :fields_save_user
      get 'fields/:id/deleteuser' => 'fields#deleteuser', as: :fields_delete_user
      post 'fields/:id/deleteuser' => 'fields#removeuser', as: :fields_remove_user
      
      #resources :users
    end
  end
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
