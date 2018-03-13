require 'test_helper'

class IdProvidersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @id_provider = id_providers(:one)
  end

  test "should show id_provider" do
    get id_provider_url(@id_provider)
    assert_response :success
  end

  test "should get edit" do
    get edit_id_provider_url(@id_provider)
    assert_response :success
  end

  test "should update id_provider" do
    patch id_provider_url(@id_provider), params: { id_provider: { ca_cert: @id_provider.ca_cert, cert: @id_provider.cert, entity_id: @id_provider.entity_id, key: @id_provider.key, ldap_connecter: @id_provider.ldap_connecter, name: @id_provider.name } }
    assert_response :success
  end
end
