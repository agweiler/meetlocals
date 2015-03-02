Rails.application.routes.draw do
  devise_for :hosts, controllers: {
    registrations: "hosts/registrations"
  }
  resources :hosts
  devise_for :guests
  resources :guests, :only => [:show, :index]

  devise_for :admins
  resources :admins, only: [:index]

  root 'static_pages#home'


  get 'how_it_works' => 'static_pages#how_it_works'

  get 'how_to_be_a_host' => 'static_pages#how_to_be_a_host'



  get 'hosts/:id/edit_profile' => 'hosts#edit_host_profile', as: :edit_host_profile
  patch 'hosts/:id/update_profile' => 'hosts#update_host_profile', as: :update_host_profile

  get 'contact' => 'static_pages#contact'

  get 'find_a_host' => 'static_pages#find_a_host'

  get 'about' => 'static_pages#about'

  get 'explore' => 'static_pages#explore'

  get 'terms_of_service' => 'static_pages#terms_of_service'

  post 'complete_profile' => 'hosts#show'

  get 'users/:id' => 'users#show'

  get 'experiences/:id/bookings/new' => 'bookings#new'

  resources :experiences

  resources :bookings

  resources :images

  resources :testimonials

  resources :messages do
  member do
    post :new
  end
end
resources :conversations do
  member do
    post :reply
    post :trash
    post :untrash
  end
 collection do
    get :trashbin
    post :empty_trash
 end
end

end
