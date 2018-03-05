class LdapAttribute < ApplicationRecord
  validates :name, presence: true, uniqueness: true
end
