class IdpAttribute < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  has_many :idp_attribute_assigns
  has_many :service_providers, through: :idp_attribute_assigns
end
