Rails.application.routes.draw do
  resources :id_providers
  resource :id_provider
  resources :ldap_attributes
  resources :idp_attribute_assigns
  resources :idp_attributes
  resources :service_providers
  resources :accounts, constraints: {id: /[^\/]+/}

  match 'ldap(/:action(/:id(.format)))', controller: 'ldap', via: [:get, :post]
  match 'id_p/update_settings', controller: 'id_providers', action: 'update_settings', via: [:get, :post]

  root 'id_providers#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
