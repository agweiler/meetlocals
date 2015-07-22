Rails.application.routes.draw do
  get 'notifications/show'

  devise_for :partners, controllers: { registrations: "partners/registrations" }


  devise_for :hosts, controllers: { registrations: "hosts/registrations" }
  resources :hosts

  # devise_for :guests, controllers: { registrations: "guests/registrations" }
  devise_for :guests, controllers:
   { omniauth_callbacks: "guests/omniauth_callbacks" },
   skip: [:registrations]
    as :guest do
      #modified paths
      post 'guests' => 'registrations#create', as: 'guest_registration'
      get 'guests/sign_up' => 'registrations#new', as: 'new_guest_registration'
      get 'guests/edit' => 'registrations#edit',
       as: 'edit_guest_registration'

      #original devise paths
      get 'guests/cancel' => 'devise/registrations#cancel',
       as: 'cancel_guest_registration'
      patch 'guests' => 'devise/registrations#update'
      put 'guests' => 'devise/registrations#update'
      delete 'guests' => 'devise/registrations#destroy'
    end

  resources :guests
  resources :authentications
  # get '/auth/:provider/callback' => 'authentications#create'
  get '/guests/authentications' => 'authentications#index'

  devise_for :admins

  get 'partners/bookings' => 'partners#bookings', as: :partner_bookings

  post 'parnters/bookings' => 'partners#create_booking', as: :create_booking

  get 'admins/analytics' => 'admins#analytics', as: :admin_analytics

  get 'admins/settings' => 'admins#settings', as: :admin_settings

  patch '/price' => 'admins#changeprice'

  patch '/host' => 'admins#approveuser'

  resources :partners

  resources :admins

  root 'static_pages#home'

  get 'how_it_works' => 'static_pages#how_it_works'

  get 'how_to_be_a_host' => 'static_pages#how_to_be_a_host'

  get 'guests/:id/edit_profile' => 'guests#edit_guest_profile', as: :edit_guest_profile
  patch 'guests/:id/update_profile' => 'guests#update_guest_profile', as: :update_guest_profile

  get 'hosts/:id/edit_profile' => 'hosts#edit_host_profile', as: :edit_host_profile
  patch 'hosts/:id/update_profile' => 'hosts#update_host_profile', as: :update_host_profile

  get 'contact' => 'static_pages#contact'

  get 'find_a_host' => 'static_pages#find_a_host'

  get 'about' => 'static_pages#about'

  get 'explore' => 'static_pages#explore'

  get 'press' => 'static_pages#press'

  get 'terms_of_service' => 'static_pages#terms_of_service'

  post 'complete_profile' => 'hosts#show'

  get 'experiences/:id/bookings/new' => 'bookings#new'

  get '/blog' => 'posts#index'

  post 'hosts_search' => "hosts#index"

  get 'hosts_search' => "hosts#index"

  post 'experiences_search' => 'experiences#index'

  get 'experiences_search' => 'experiences#index'

  get "/bookings/index" => 'bookings#index', as: :booking_index

  get 'bookings/:id/testimonials/new' => 'testimonials#new', as: :make_testimonial

  # get "/bookings/:id" => "bookings#show", as: :show_booking
  get "experiences/:experience_id/bookings/:id" => "bookings#show", as: :show_booking

  # post "/bookings/:id" => "bookings#show"
  post "experiences/:experience_id/bookings/:id" => "bookings#show"

  get "/experiences/new" => "experiences#new"

  get "/experiences/:id" => "experiences#show", as: :show_experience

  get "page_not_found" => 'public#404', as: :error_404

  get "unknown_error" => 'public#500', as: :error_500

  post "/hook" => "bookings#hook"
  get "/hook" => "bookings#hook"

  post 'messages' => 'messages#new'

  post 'bookings/:id/complete' => 'bookings#mark_completion', as: :mark_booking_completion
  # root 'emailapi#index'
  post 'emailapi/subscribe' => 'emailapi#subscribe'

  post 'hosts/:id' => 'hosts#update_holiday'

  get 'notifications/all' => 'notifications#all', as: :all_notifications

  resources :multidinners

  resources :experiences

  resources :bookings

  resources :experiences do
    resources :bookings
  end

  resources :images

  resources :posts

  resources :testimonials
end
