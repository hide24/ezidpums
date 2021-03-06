require 'test_helper'

class LdapAttributesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @ldap_attribute = ldap_attributes(:one)
  end

  test "should get index" do
    get ldap_attributes_url
    assert_response :success
  end

  test "should get new" do
    get new_ldap_attribute_url
    assert_response :success
  end

  test "should create ldap_attribute" do
    assert_difference('LdapAttribute.count') do
      post ldap_attributes_url, params: { ldap_attribute: { enable: @ldap_attribute.enable, field_type_id: @ldap_attribute.field_type_id, name: 'cn', order: @ldap_attribute.order } }
    end

    assert_redirected_to ldap_attribute_url(LdapAttribute.last)
  end

  test "should show ldap_attribute" do
    get ldap_attribute_url(@ldap_attribute)
    assert_response :success
  end

  test "should get edit" do
    get edit_ldap_attribute_url(@ldap_attribute)
    assert_response :success
  end

  test "should update ldap_attribute" do
    patch ldap_attribute_url(@ldap_attribute), params: { ldap_attribute: { enable: @ldap_attribute.enable, field_type_id: @ldap_attribute.field_type_id, name: @ldap_attribute.name, order: @ldap_attribute.order } }
    assert_redirected_to ldap_attribute_url(@ldap_attribute)
  end

  test "should destroy ldap_attribute" do
    assert_difference('LdapAttribute.count', -1) do
      delete ldap_attribute_url(@ldap_attribute)
    end

    assert_redirected_to ldap_attributes_url
  end
end
