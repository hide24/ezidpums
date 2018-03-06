class ServiceProvider < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :entity_id, uniqueness: true

  has_many :ldap_attribute_assigns
  has_many :ldap_attributes, through: :ldap_attribute_assigns

  CERTIFICATION_LIST_VIEW_LENGTH = 16

  def puritty_certification
    certification.to_s[0, CERTIFICATION_LIST_VIEW_LENGTH]
  end
end
