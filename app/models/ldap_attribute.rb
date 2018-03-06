class LdapAttribute < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  has_many :ldap_attribute_assigns
  has_many :service_providers, through: :ldap_attribute_assigns
end
