require 'test_helper'

class LdapAttributeAssignsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @ldap_attribute_assign = ldap_attribute_assigns(:one)
    @service_provider = service_providers(:one)
    @ldap_attribute = ldap_attributes(:one)
  end

  test "should get index" do
    get ldap_attribute_assigns_url
    assert_response :success
  end

  # Does not support create ldap_attribute_assigns record, directry.
  # It should be created by assosiation (ServiceProvider of LdapAttribute)
#  test "should get new" do
#    get new_ldap_attribute_assign_url
#    assert_response :success
#  end
#
#  test "should create ldap_attribute_assign" do
#    assert_difference('LdapAttributeAssign.count') do
#      post ldap_attribute_assigns_url, params: { ldap_attribute_assign: { ldap_attribute_id: @ldap_attribute_assign.ldap_attribute_id, service_provider_id: @ldap_attribute_assign.service_provider_id } }
#    end
#
#    assert_redirected_to ldap_attribute_assign_url(LdapAttributeAssign.last)
#  end

  # Show action displaies ServiceProvider entity, does not LdapAttributeAssign entity.
#  test "should show ldap_attribute_assign" do
#    get ldap_attribute_assign_url(@service_provider)
#    assert_response :success
#  end

  test "should get edit" do
    get edit_ldap_attribute_assign_url(@service_provider)
    assert_response :success
  end

  test "should update ldap_attribute_assign" do
    patch ldap_attribute_assign_url(@ldap_attribute_assign), params: { ldap_attribute_id: [@ldap_attribute.id] }
    assert_redirected_to ldap_attribute_assigns_url
  end

  test "should destroy ldap_attribute_assign" do
    assert_difference('LdapAttributeAssign.where(service_provider_id: @ldap_attribute_assign.id).count', -1) do
      delete ldap_attribute_assign_url(@ldap_attribute_assign)
    end

    assert_redirected_to ldap_attribute_assigns_url
  end
end
