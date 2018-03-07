require 'test_helper'

class OrganizationTest < ActiveSupport::TestCase

  setup do
    @organization = AlTestUtils.organizations(:one)
  end

  test "defalut org must be exist." do
    assert @organization.present?
  end
end
