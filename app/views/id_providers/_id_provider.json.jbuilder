json.extract! id_provider, :id, :name, :entity_id, :host_name, :scope, :cert, :key, :ca_cert, :created_at, :updated_at
json.url id_provider_url(id_provider, format: :json)
