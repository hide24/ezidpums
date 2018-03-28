class IdProvider < ApplicationRecord
  before_save :set_host_name, :set_scope
  validates :entity_id, presence: true, uniqueness: true

  def set_host_name
    retun if host_name.present? 

    entity_id_uri = URI.parse(entity_id)
    self.host_name = entity_id_uri.host.to_s
  rescue
    nil
  end
  
  def set_scope
    retun if scope.present? 

    entity_id_uri = URI.parse(entity_id)
    self.scope = entity_id_uri.host.to_s.gsub(/^idp\./, '')
  rescue
    nil
  end

  def attribute_resolver
    @idp_attributes = IdpAttribute.where(enable: true).order(:order)
    render('id_providers/attribute_resolver')
  end

  def attribute_filter
    @service_providers = ServiceProvider.where(enable: true)
    render('id_providers/attribute_filter')
  end

  def metadata
    @id_provider = self
    render('id_providers/metadata')
  end

  def sp_metadata
    @service_providers = ServiceProvider.where(enable: true).order(:id)
    render('id_providers/sp_metadata')
  end

  def metadata_providers(*options)
    @idp_metadata, @sp_metadata, @options = options
    if @idp_metadata.kind_of?(Hash)
      @options = @idp_metadata
      @idp_metadata = nil
      @sp_metadata = nil
    elsif @sp_metadata.kind_of?(Hash)
      @options = @sp_metadata
      @sp_metadata = nil
    end
    if @options.kind_of?(Hash)
      @idp_metadata = @options[:idp_metadata] if @options.key?(:idp_metadata)
      @sp_metadata = @options[:sp_metadata] if @options.key?(:sp_metadata)
      @gakunin_fed = @options[:gakunin_fed] if @options.key?(:gakunin_fed)
      @gakunin_test = @options[:gakunin_test] if @options.key?(:gakunin_test)
    end

    render('id_providers/metadata_providers')
  end

  def idp_properties
    @id_provider = self
    render('id_providers/idp_properties')
  end

  def ldap_properties
    render('id_providers/ldap_properties')
  end

  def saml_nameid_properties
    render('id_providers/saml_nameid_properties')
  end
end
