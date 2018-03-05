require 'test_helper'

class LdapAttributeTest < ActiveSupport::TestCase
  setup do
    @ldap_attribute = ldap_attributes(:one)
  end

  test "name should not be empty" do
    @ldap_attribute.name = ''
    assert_not  @ldap_attribute.save
  end

  test "name should be uniq" do
    @ldap_attribute.name = 'mail'
    assert_not @ldap_attribute.save
  end
end
