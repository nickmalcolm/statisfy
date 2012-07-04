Statisfy::Application.routes.draw do
  root to: "home#index"
  
  match 'auth/shopify/callback'  => 'login#finalize'
  match 'login'                  => 'login#index',        :as => :login
  match 'login/authenticate'     => 'login#authenticate', :as => :authenticate
  match 'login/finalize'         => 'login#finalize',     :as => :finalize
  match 'login/logout'           => 'login#logout',       :as => :logout
end
