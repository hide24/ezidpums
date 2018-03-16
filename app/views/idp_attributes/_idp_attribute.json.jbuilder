json.extract! idp_attribute, :id, :order, :name, :attribute_resolver, :enable, :created_at, :updated_at
json.url idp_attribute_url(idp_attribute, format: :json)
