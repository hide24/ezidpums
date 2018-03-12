json.extract! account, *LdapAttribute.attribute_names.map(&:to_sym)
json.url account_url(account, format: :json)
