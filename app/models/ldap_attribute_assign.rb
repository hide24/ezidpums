class LdapAttributeAssign < ApplicationRecord
  belongs_to :service_provider
  belongs_to :ldap_attribute
end
