Rails.application.routes.draw do
  devise_for :users, ActiveAdmin::Devise.config

  # Custom routes for ActiveAdmin
  namespace :sudo do
    resources :packages, constraints: { id: /[^\/]+(?<!\.json)/ } # Allow dots in ID

    resources :collections do
      get ":state", action: :index, as: "state", on: :collection
    end
  end

  ActiveAdmin.routes(self)

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  post "levelup" => "pages#levelup"

  resources :packages, path: "(:collection_id)",
    constraints: { id: /[^\/]+(?<!\.json)/ }, # Allow dots in ID
    only: [ :index, :show ]

  # You can have the root of your site routed with "root"
  root 'packages#index'
end
