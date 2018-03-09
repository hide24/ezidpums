require 'test_helper'

class LdapAttributeTest < ActiveSupport::TestCase
  setup do
    @ldap_attribute = ldap_attributes(:three)
  end

  test "name should not be empty" do
    @ldap_attribute.name = ''
    assert_not  @ldap_attribute.save
  end

  test "name should be uniq" do
    @ldap_attribute.name = 'uid'
    assert_not @ldap_attribute.save
  end

  test "name should take from inetOrgPerson or eduPerson attributes." do
    @ldap_attribute.name = 'foobar'
    assert_not @ldap_attribute.save
  end
end
