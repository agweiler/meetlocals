Rails.application.routes.draw do
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'
  get 'notifications/show'


  devise_for :partners, controllers: { registrations: "partners/registrations" }


  devise_for :hosts, controllers: { registrations: "hosts/registrations", sessions: "hosts/sessions" }
  resources :hosts

  # devise_for :guests, controllers: { registrations: "guests/registrations" }
  devise_for :guests, controllers:
   { omniauth_callbacks: "guests/omniauth_callbacks" ,sessions: "guests/sessions"},
   skip: [:registrations]
    as :guest do
      #modified paths
      
      get 'guest/sign_in' => 'sessions#guest_sign_in'
      post 'guests' => 'registrations#create', as: 'guest_registration'
      get 'guests/sign_up' => 'registrations#new', as: 'new_guest_registration'
      get 'guests/edit' => 'registrations#edit',
       as: 'edit_guest_registration'

      patch 'guests' => 'registrations#update'
      put   'guests' => 'registrations#update'

      #original devise paths
      get 'guests/cancel' => 'devise/registrations#cancel',
       as: 'cancel_guest_registration'
      delete 'guests' => 'devise/registrations#destroy'
    end
  resources :site_images
  resources :static_texts
  resources :guests
  resources :authentications

  resources :charges 
  # get '/auth/:provider/callback' => 'authentications#create'
  # get '/guests/authentications' => 'authentications#index'


  devise_for :admins

  get 'all_hosts' => 'admins#all_hosts'

  post "send_email" => 'admins#send_email'

  get "newsletter_failure" => "static_pages#newsletter_failure"

  get "newsletter_success" => "static_pages#newsletter_success"

  post "payment_failure" => "static_pages#payment_failure"

  get "payment_failure" => "static_pages#payment_failure"

  post "payment_success" => "static_pages#payment_success"

  get "payment_success" => "static_pages#payment_success"

  get "create_exp_success" => "static_pages#create_exp_success"

  get "create_host_success" => "static_pages#create_host_success"

  get "sign_in_as_guest" => "static_pages#sign_in_as_guest"

  get 'partners/bookings' => 'partners#bookings', as: :partner_bookings

  post 'parnters/bookings' => 'partners#create_booking', as: :create_booking

  get 'admins/analytics' => 'admins#analytics', as: :admin_analytics

  get 'admins/settings' => 'admins#settings', as: :admin_settings

  get 'admins/bookings' => 'admins#bookings_list', as: :admin_bookings_list

  get 'admins/booking_type_all' => 'admins#booking_type_all'

  get '/confirmed_report' => 'admins#confirmed_report'

  get '/completed_report' => 'admins#completed_report'

  post 'bookings/:id/host_paid' => 'bookings#host_paid', as: :mark_host_paid

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

  post 'redirect_to_guest' => 'static_pages#redirect_to_guest_signup'

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
  post 'bookings/:id/cancel' => 'bookings#cancel_booking', as: :cancel_booking
  post 'bookings/:id/complete' => 'bookings#mark_completion', as: :mark_booking_completion
  # root 'emailapi#index'
  post 'emailapi/subscribe' => 'emailapi#subscribe'

  post 'hosts/:id' => 'hosts#update_holiday'

  get 'notifications/all' => 'notifications#all', as: :all_notifications

  #301 redirects:

  get '/guests-2', to: redirect('/how_it_works')
  get '/vaerts-tilmelding/', to: redirect('/how_to_be_a_host')
  get '/news/', to: redirect('/blog')

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
