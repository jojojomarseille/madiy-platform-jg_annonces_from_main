Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  authenticate :admin_user do
    mount GoodJob::Engine => "good_job"
  end

  devise_for :users, controllers: {
    registrations: "users/registrations"
  }, path: "mon-compte"

  namespace :users, path: "mon-compte" do
    resources :orders, only: %i[index], path: "mes-commandes"
  end

  devise_for :creators, controllers: {
   sessions: "creators/sessions"
  }, path: "creators"

  resources :creators 
  resources :creator_docs
  
  post "/creators/:id" => "creators#update"
  get "creators/edit/:id" => "creators#edit"

  get "creator_docs/new" => "creator_docs#new"
  post "creator_docs/new" => "creator_docs#create"
  # post "creator_docs/create" => "creator_docs#create"
  
  post "workshops/new" => "workshops#create"  
  get "/workshops/index_creator/:id" => "workshops#index_creator"
  get "/workshops/new" => "workshops#new"
  get "workshops/index_creator/edit/:id" => "workshops#edit_draft"
  get "/workshops/index_creator/workshop_creator_view/:id" => "workshops#workshop_creator_view"
  delete "/workshops/index_creator/:id" => "workshops#destroy"
  patch "/workshops/:id" => "workshops#updatedelete"
  patch "/workshops/publish/:id" => "workshops#publish"
 
 
  patch "/ateliers/:id" => "workshops#update"
  post "ateliers/:id" => "workshops#update"
 
  
  get "workshop_events/:id" => "workshops#edit_event_seats"
  patch "workshop_events/:id" => "workshops#update_event_seats"
  patch "/events/:id" => "workshops#destroy_event"
  # post "workshop_events/:id" => "workshops#update_event_seats"

  resources :showcases, only: %i[index], controller: "workshops/showcases"
  resources :relateds, only: %i[index], controller: "workshops/relateds"
  resources :newsletter_members, only: %i[create]

  scope(path_names: { new: "nouvelle" }) do
    resources :vouchers, only: %i[show new create], path: "cartes-cadeaux"
  end

  scope(path_names: { new: "nouveau", edit: "modifier" }) do
    resource :creator_contacts, only: %i[create]
    resource :specific_workshop_contacts, only: %i[create]

    resources :workshops, only: %i[index show create], path: "ateliers" do
      resources :workshop_event_reminders, only: %i[create]
    end

    resources :kits, only: %i[index]

    resources :bookings, only: %i[show create], path: "reservations"
    resources :discounts, only: %i[create]

    resource :carts, only: %i[show], path: "panier"
    resources :cart_items, only: %i[update destroy]
    resources :billing_details, only: %i[new create update], path: "informations-facturation"
    resources :payments, only: %i[new create], path: "paiements"
    resources :no_payments, only: %i[create]
    resources :card_registrations, only: %i[create]
    resources :shipments, only: %i[edit update]
  end

  get "/mangopay_webhooks", to: "mangopay#update"

  get "/pages/*id" => 'pages#show', as: :page, format: false

  get "/404", to: "errors#error404", :via => :all
  get "/422", to: "errors#error404", :via => :all
  get "/500", to: "errors#error500", :via => :all

  root to: 'pages#show', id: 'home'
end
