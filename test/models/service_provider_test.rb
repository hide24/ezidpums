require 'test_helper'

class ServiceProviderTest < ActiveSupport::TestCase
  setup do
    @service_provider = service_providers(:one)
  end

  test "name should not be empty" do
    @service_provider.name = ''
    assert_not  @service_provider.save
  end

  test "name should be uniq" do
    @service_provider.name = 'MySp2'
    assert_not @service_provider.save
  end

  test "entity_id should be uniq" do
    @service_provider.entity_id = 'https://mysp2/shibboleth-sp/'
    assert_not @service_provider.save
  end
end
