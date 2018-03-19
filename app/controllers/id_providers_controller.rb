class IdProvidersController < ApplicationController
  before_action :set_id_provider

  def index
    respond_to do |format|
      format.any { render :edit }
      format.json { render :show, status: :ok, location: @id_provider }
    end
  end

  # GET /id_providers/1
  # GET /id_providers/1.json
  def show
  end

  # GET /id_providers/1/edit
  def edit
  end

  # PATCH/PUT /id_providers/1
  # PATCH/PUT /id_providers/1.json
  def update
    respond_to do |format|
      if @id_provider.update(id_provider_params)
        format.any { render :edit, notice: 'Id provider was successfully updated.' }
        format.json { render :show, status: :ok, location: @id_provider }
      else
        format.any { render :edit }
        format.json { render json: @id_provider.errors, status: :unprocessable_entity }
      end
    end
  end

  def update_settings
    File.open(File.join(::SHIBBOLETH_CONFIG_DIR, 'attribute-resolver.xml'), 'w') do |file|
      file.write @id_provider.attribute_resolver
    end
    File.open(File.join(SHIBBOLETH_CONFIG_DIR, 'attribute-filter.xml'), 'w') do |file|
      file.write @id_provider.attribute_filter
    end
    File.open(File.join(SHIBBOLETH_CONFIG_DIR, 'metadata-providers.xml'), 'w') do |file|
      file.write @id_provider.metadata_providers
    end
    File.open(File.join(SHIBBOLETH_CONFIG_DIR, 'idp.properties'), 'w') do |file|
      file.write @id_provider.idp_properties
    end
    File.open(File.join(SHIBBOLETH_CONFIG_DIR, 'ldap.properties'), 'w') do |file|
      file.write @id_provider.ldap_properties
    end
    File.open(File.join(SHIBBOLETH_CONFIG_DIR, 'saml-nameid.properties'), 'w') do |file|
      file.write @id_provider.saml_nameid_properties
    end

    File.open(File.join(SHIBBOLETH_METADATA_DIR, 'idp-metadata.xml'), 'w') do |file|
      file.write @id_provider.metadata
    end

    File.open(File.join(SHIBBOLETH_CERT_DIR, 'idp.cer'), 'w') do |file|
      file.write @id_provider.cert
    end
    File.open(File.join(SHIBBOLETH_CERT_DIR, 'idp.key'), 'w')do |file|
      file.write @id_provider.key
    end
    if @id_provider.ca_cert.present?
      File.open(File.join(SHIBBOLETH_CERT_DIR, 'ca.cer'), 'w') do |file|
        file.write @id_provider.ca_cert
      end
    end

    flash[:notice] =  ['Shibboleth configration was successfully updated.', 'Please restart Shibboleth IdP service.']
    redirect_to action: 'index'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_id_provider
      @id_provider = IdProvider.first
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def id_provider_params
      params.require(:id_provider).permit(:name, :entity_id, :host_name, :scope, :cert, :key, :ca_cert)
    end
end
