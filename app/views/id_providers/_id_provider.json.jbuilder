json.extract! id_provider, :id, :name, :entity_id, :cert, :key, :ca_cert, :ldap_connecter, :created_at, :updated_at
json.url id_provider_url(id_provider, format: :json)
