class LdapAttribute < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validate :name_shuld_be_take_from_ldap_schema

  def name_shuld_be_take_from_ldap_schema
    unless Account.new.have_attribute?(name)
      errors.add(:name, ': name should be take from ldap schema')
    end
  end
end
