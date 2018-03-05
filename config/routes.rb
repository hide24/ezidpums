Rails.application.routes.draw do
  resources :ldap_attributes
  resources :service_providers
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
