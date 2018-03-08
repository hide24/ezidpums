json.extract! account, *LdapAttribute.where(enable: true).order(:order).pluck(:name).map(&:to_sym)
json.url account_url(account, format: :json)
