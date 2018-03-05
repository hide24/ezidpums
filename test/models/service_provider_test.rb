require 'test_helper'

class ServiceProviderTest < ActiveSupport::TestCase
  setup do
    @service_provider = service_providers(:one)
  end

  test "puritty_certification should return String" do
    @service_provider.certification = nil
    assert @service_provider.puritty_certification.kind_of?(String)
  end

  test "puritty_certification should not return so long string." do
    @service_provider.certification = 'so_long_string_so_long_string_so_long_string_so_long_string_so_long_string_so_long_string_'
    assert @service_provider.puritty_certification.size <= ServiceProvider::CERTIFICATION_LIST_VIEW_LENGTH
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
