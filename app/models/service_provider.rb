class ServiceProvider < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :entity_id, uniqueness: true

  has_many :idp_attribute_assigns
  has_many :idp_attributes, through: :idp_attribute_assigns

  CERTIFICATION_LIST_VIEW_LENGTH = 16

  def puritty_certification
    certification.to_s[0, CERTIFICATION_LIST_VIEW_LENGTH]
  end
end
