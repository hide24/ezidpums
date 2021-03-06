class ServiceProvider < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :entity_id, uniqueness: true

  has_many :idp_attribute_assigns
  has_many :idp_attributes, through: :idp_attribute_assigns
end
