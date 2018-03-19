class IdProvider < ApplicationRecord
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

  def metadata_providers
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
