Statisfy::Application.routes.draw do
  
  mount Resque::Server.new, :at => "/resque"
  
  root to: "home#index"
  
  resources :shop, only: [:show]
  
  match 'auth/shopify/callback'  => 'login#finalize'
  match 'login'                  => 'login#index',        :as => :login
  match 'login/authenticate'     => 'login#authenticate', :as => :authenticate
  match 'login/finalize'         => 'login#finalize',     :as => :finalize
  match 'login/logout'           => 'login#logout',       :as => :logout
  
  match 'help'                   => 'home#help',          :as => :help
end
