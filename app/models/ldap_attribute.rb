class LdapAttribute < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validate :name_shuld_be_take_from_ldap_schema

  def name_shuld_be_take_from_ldap_schema
    unless Account.new.have_attribute?(name)
      errors.add(:name, ': name should be take from ldap schema')
    end
  end

  def self.attribute_names
    self.where(enable: true).order(:order).pluck(:name)
  end

  def field_type
    FieldType.find(field_type_id)
  end
end
