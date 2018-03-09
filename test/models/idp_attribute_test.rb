require 'test_helper'

class IdpAttributeTest < ActiveSupport::TestCase
  setup do
    @idp_attribute = idp_attributes(:one)
  end

  test "name should not be empty" do
    @idp_attribute.name = ''
    assert_not  @idp_attribute.save
  end

  test "name should be uniq" do
    @idp_attribute.name = 'mail'
    assert_not @idp_attribute.save
  end
end
