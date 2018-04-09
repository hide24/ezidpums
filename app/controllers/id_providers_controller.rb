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
        flash.now[:notice] = 'Id provider information was successfully updated.'
        format.any { render :edit }
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
    end if params[:shibboleth_settings][:attribute_resolver]
    File.open(File.join(SHIBBOLETH_CONFIG_DIR, 'attribute-filter.xml'), 'w') do |file|
      file.write @id_provider.attribute_filter
    end if params[:shibboleth_settings][:attribute_filter]
    File.open(File.join(SHIBBOLETH_CONFIG_DIR, 'metadata-providers.xml'), 'w') do |file|
      file.write @id_provider.metadata_providers(params[:shibboleth_settings][:idp_metadata], params[:shibboleth_settings][:sp_metadata])
    end if params[:shibboleth_settings][:metadata_providers]
    File.open(File.join(SHIBBOLETH_CONFIG_DIR, 'idp.properties'), 'w') do |file|
      file.write @id_provider.idp_properties
    end if params[:shibboleth_settings][:idp_properties]
    File.open(File.join(SHIBBOLETH_CONFIG_DIR, 'ldap.properties'), 'w') do |file|
      file.write @id_provider.ldap_properties
    end if params[:shibboleth_settings][:ldap_properties]
    File.open(File.join(SHIBBOLETH_CONFIG_DIR, 'saml-nameid.properties'), 'w') do |file|
      file.write @id_provider.saml_nameid_properties
    end if params[:shibboleth_settings][:saml_nameid_properties]

    File.open(File.join(SHIBBOLETH_METADATA_DIR, 'idp-metadata.xml'), 'w') do |file|
      file.write @id_provider.metadata
    end if params[:shibboleth_settings][:idp_metadata]
    File.open(File.join(SHIBBOLETH_METADATA_DIR, 'sp-metadata.xml'), 'w') do |file|
      file.write @id_provider.sp_metadata
    end if params[:shibboleth_settings][:sp_metadata]

    if params[:shibboleth_settings][:httpd_certs]
      File.open(File.join(HTTP_SSL_CERT_DIR, 'idp.cer'), 'w') do |file|
        file.write @id_provider.cert_with_header
      end
      File.open(File.join(HTTP_SSL_KEY_DIR, 'idp.key'), 'w')do |file|
        file.write @id_provider.key_with_header
      end
      if @id_provider.ca_cert.present?
        File.open(File.join(HTTP_SSL_CERT_DIR, 'ca.cer'), 'w') do |file|
          file.write @id_provider.ca_cert_with_header
        end
      end
    end

    if params[:shibboleth_settings][:jetty_certs]
      File.open(File.join(SHIBBOLETH_CERT_DIR, 'idp.cer'), 'w') do |file|
        file.write @id_provider.cert_with_header
      end
      File.open(File.join(SHIBBOLETH_CERT_DIR, 'idp.key'), 'w')do |file|
        file.write @id_provider.key_with_header
      end
      if @id_provider.ca_cert.present?
        File.open(File.join(SHIBBOLETH_CERT_DIR, 'idp.cer'), 'a') do |file|
          file.write @id_provider.ca_cert_with_header
        end
      end
      Dir.chdir(SHIBBOLETH_CERT_DIR) do
        `openssl pkcs12 -inkey idp.key -in idp.cer -export -out idp-browser.p12 -password pass:#{JETTY_KEYSTORE_PASSWORD}`
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
