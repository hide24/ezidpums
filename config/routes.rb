Rails.application.routes.draw do
  resources :ldap_attributes
  resources :idp_attribute_assigns
  resources :idp_attributes
  resources :service_providers
  resources :accounts

  match 'ldap(/:action(/:id(.format)))', controller: 'ldap', via: [:get, :post]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
