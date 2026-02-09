#   get "welcome/index"
#   # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
#
#   # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
#   # Can be used by load balancers and uptime monitors to verify that the app is live.
#   get "up" => "rails/health#show", as: :rails_health_check
#
#   # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
#   # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
#   # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
#
#   # Defines the root path route ("/")
#   # root "posts#index"
# end

Rails.application.routes.draw do
  root "home#index"

  # Home
  get "home", to: "home#index"

  # Login
  get  "login",  to: "login#new"
  post "login",  to: "login#create"
  delete "logout", to: "login#destroy"

  # Sign up
  get  "sign_up",  to: "sign_up#new"
  post "sign_up",  to: "sign_up#create"

  # Forgot password
  get "forgot_password",  to: "forgot_password#new"
  post "forgot_password", to: "forgot_password#create"

  # Password reset
  get   "password/reset", to: "password_reset#edit"
  patch "password/reset", to: "password_reset#update"

  # Logout
  delete "logout", to: "login#destroy"

  # Notes
  post "notes", to: "notes#create"

end
