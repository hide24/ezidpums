class IdpAttributeAssign < ApplicationRecord
  belongs_to :service_provider
  belongs_to :idp_attribute
end
