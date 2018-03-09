require 'test_helper'

class IdpAttributeAssignsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @idp_attribute_assign = idp_attribute_assigns(:one)
    @service_provider = service_providers(:one)
    @idp_attribute = idp_attributes(:one)
  end

  test "should get index" do
    get idp_attribute_assigns_url
    assert_response :success
  end

  # Does not support create idp_attribute_assigns record, directry.
  # It should be created by assosiation (ServiceProvider of IdpAttribute)
#  test "should get new" do
#    get new_idp_attribute_assign_url
#    assert_response :success
#  end
#
#  test "should create idp_attribute_assign" do
#    assert_difference('IdpAttributeAssign.count') do
#      post idp_attribute_assigns_url, params: { idp_attribute_assign: { idp_attribute_id: @idp_attribute_assign.idp_attribute_id, service_provider_id: @idp_attribute_assign.service_provider_id } }
#    end
#
#    assert_redirected_to idp_attribute_assign_url(IdpAttributeAssign.last)
#  end

  # Show action displaies ServiceProvider entity, does not IdpAttributeAssign entity.
#  test "should show idp_attribute_assign" do
#    get idp_attribute_assign_url(@service_provider)
#    assert_response :success
#  end

  test "should get edit" do
    get edit_idp_attribute_assign_url(@service_provider)
    assert_response :success
  end

  test "should update idp_attribute_assign" do
    patch idp_attribute_assign_url(@idp_attribute_assign), params: { idp_attribute_id: [@idp_attribute.id] }
    assert_redirected_to idp_attribute_assigns_url
  end

  test "should destroy idp_attribute_assign" do
    assert_difference('IdpAttributeAssign.where(service_provider_id: @idp_attribute_assign.id).count', -1) do
      delete idp_attribute_assign_url(@idp_attribute_assign)
    end

    assert_redirected_to idp_attribute_assigns_url
  end
end
