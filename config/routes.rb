Rails.application.routes.draw do
  devise_for :hosts, controllers: {
    registrations: "hosts/registrations"
  }
  resources :hosts
  
  devise_for :guests, controllers: {
    registrations: "guests/registrations"
  }
  resources :guests

  devise_for :admins
  resources :admins, only: [:index]
  
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

  get 'terms_of_service' => 'static_pages#terms_of_service'

  post 'complete_profile' => 'hosts#show'

  # get 'users/:id' => 'users#show'


  resources :experiences

  resources :bookings

  resources :images

  resources :testimonials
end
