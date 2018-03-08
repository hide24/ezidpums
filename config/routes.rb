Rails.application.routes.draw do
  resources :ldap_attribute_assigns
  resources :ldap_attributes
  resources :service_providers
  resources :accounts
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
