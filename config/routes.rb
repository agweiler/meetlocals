Rails.application.routes.draw do

  
  root 'static_pages#home'

  get 'how_it_works' => 'static_pages#how_it_works'

  get 'how_to_be_a_host' => 'static_pages#how_to_be_a_host'

  get 'contact' => 'static_pages#contact'

  get 'find_a_host' => 'static_pages#find_a_host'

  get 'about' => 'static_pages#about'

  get 'explore' => 'static_pages#explore'

  get 'terms_of_service' => 'static_pages#terms_of_service'

  devise_for :hosts#, controllers: {
    # registrations: "hosts/registrations"
    # sessions: "hosts/sessions",
    # passwords: "hosts/passwords"
  # }
  devise_for :guests#, controllers: {
  #   registrations: "guests/registrations",
  #   sessions: "guests/sessions",
  #   passwords: "guests/passwords"
  # }
  devise_for :admins
  resources :admins, only: [:index]
   #, controllers: {
  #   registrations: "admins/registrations",
  #   sessions: "admins/sessions",
  #   passwords: "admins/passwords"
  # }


  resources :experiences

  resources :bookings

  resources :images

  resources :testimonials



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
