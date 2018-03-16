require 'test_helper'

class IdpAttributesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @idp_attribute = idp_attributes(:one)
  end

  test "should get index" do
    get idp_attributes_url
    assert_response :success
  end

  test "should get new" do
    get new_idp_attribute_url
    assert_response :success
  end

  test "should create idp_attribute" do
    assert_difference('IdpAttribute.count') do
      post idp_attributes_url, params: { idp_attribute: { attribute_resolver: '@idp_attribute.attribute_resolver', enable: '@idp_attribute.enable', name: '@idp_attribute.name', order: '@idp_attribute.order'.to_i } }
    end

    assert_redirected_to idp_attribute_url(IdpAttribute.last)
  end

  test "should show idp_attribute" do
    get idp_attribute_url(@idp_attribute)
    assert_response :success
  end

  test "should get edit" do
    get edit_idp_attribute_url(@idp_attribute)
    assert_response :success
  end

  test "should update idp_attribute" do
    patch idp_attribute_url(@idp_attribute), params: { idp_attribute: { attribute_resolver: @idp_attribute.attribute_resolver, enable: @idp_attribute.enable, name: @idp_attribute.name, order: @idp_attribute.order } }
    assert_redirected_to idp_attribute_url(@idp_attribute)
  end

  test "should not destroy idp_attribute" do
    assert_difference('IdpAttribute.count', 0) do
      delete idp_attribute_url(@idp_attribute)
    end

    assert_redirected_to idp_attributes_url
  end
end
