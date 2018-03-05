class ServiceProvider < ApplicationRecord
  CERTIFICATION_LIST_VIEW_LENGTH = 16

  def puritty_certification
    certification.to_s[0, CERTIFICATION_LIST_VIEW_LENGTH]
  end
end
