Rails.application.routes.draw do

#  namespace :concerns do
    get 'catalog' => 'concerns/static_pages#catalog'
    get 'report/:name' => 'concerns/report#show'
    get 'company' => 'spree/users#show', :department => 'company'
    get 'my_orders' => 'spree/users#show', :department => 'orders'
    get 'vpos/payment/:id/:method_id' => 'spree/vpos#payment'
    get 'vpos/callback' => 'spree/vpos#callback'
    post 'vpos/callback' => 'spree/vpos#callback'
    post 'vpos/do_payment' => 'spree/vpos#do_payment'
    get 'response' => 'spree/vpos#callback'
    post 'response' => 'spree/vpos#callback'
#  end
  DynamicRouter.load
  # This line mounts Spree's routes at the root of your application.
  # This means, any requests to URLs such as /products, will go to Spree::ProductsController.
  # If you would like to change where this engine is mounted, simply change the :at option to something different.
  #
  # We ask that you don't use the :as option here, as Spree relies on it being the default of "spree"

  devise_scope :spree_user do
    #authenticated :spree_user do
      #root :to => 'spree/home#index', as: :authenticated_root
    #  root :to => 'spree/users#show', as: :authenticated_root
    #end
    #unauthenticated :spree_user do
      root :to => 'spree/user_registrations#new' #, as: :unauthenticated_root
    #end
  end
  mount Spree::Core::Engine, :at => '/'
  get 'products/:id/:ref(.:format)' => 'spree/products#show'
          # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

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

Spree::Core::Engine.add_routes do
  namespace :admin do
    resources :invitations
    resources :discounts
    get '/afiiliate_tree' => 'affiliate_tree#index', as: :affiliate_tree
    resources :custom_pages
  end
  namespace :api, defaults: { format: 'json' } do
    resources :invitations
    post 'send_invite' => "invitations#send_invite"
    get 'referals/subordinates' => 'referals#get_subordinates'
    resources :user_accounts
    put 'account_payments/update_recordset' => 'account_payments/update_recordset', :provides => [:json, :xml]
    get 'exchange/new' => 'exchange#new_message', :provides => [:json, :xml]
    put 'exchange/confirm' => 'exchange#confirm', :provides => [:json, :xml]
    put 'exchange/set_plan' => 'exchange#set_plan', :provides => [:json, :xml]
    put 'exchange/confirm_payment' => 'exchange#confirm_payment', :provides => [:json, :xml]
    put 'exchange/user_stats' => 'exchange#user_stats', :provides => [:json, :xml]
    get 'exchange/user/:id' => 'exchange#user', :provides => [:json, :xml]
    resources :account_payments
  end
end
