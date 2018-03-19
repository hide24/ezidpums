class LdapAttributesController < ApplicationController
  before_action :set_ldap_attribute, only: [:show, :edit, :update, :destroy]

  # GET /ldap_attributes
  # GET /ldap_attributes.json
  def index
    @ldap_attributes = LdapAttribute.all
  end

  # GET /ldap_attributes/1
  # GET /ldap_attributes/1.json
  def show
  end

  # GET /ldap_attributes/new
  def new
    @ldap_attribute = LdapAttribute.new
  end

  # GET /ldap_attributes/1/edit
  def edit
  end

  # POST /ldap_attributes
  # POST /ldap_attributes.json
  def create
    @ldap_attribute = LdapAttribute.new(ldap_attribute_params)

    respond_to do |format|
      if @ldap_attribute.save
        format.html { redirect_to @ldap_attribute, notice: 'Ldap attribute was successfully created.' }
        format.json { render :show, status: :created, location: @ldap_attribute }
        format.js { @status = 'success'}
      else
        format.html { render :new }
        format.json { render json: @ldap_attribute.errors, status: :unprocessable_entity }
        format.js { @status = 'fail' }
      end
    end
  end

  # PATCH/PUT /ldap_attributes/1
  # PATCH/PUT /ldap_attributes/1.json
  def update
    respond_to do |format|
      if @ldap_attribute.update(ldap_attribute_params)
        format.html { redirect_to @ldap_attribute, notice: 'Ldap attribute was successfully updated.' }
        format.json { render :show, status: :ok, location: @ldap_attribute }
        format.js { @status = 'success'}
      else
        format.html { render :edit }
        format.json { render json: @ldap_attribute.errors, status: :unprocessable_entity }
        format.js { @status = 'fail' }
      end
    end
  end

  # DELETE /ldap_attributes/1
  # DELETE /ldap_attributes/1.json
  def destroy
    @ldap_attribute.destroy
    respond_to do |format|
      format.html { redirect_to ldap_attributes_url, notice: 'Ldap attribute was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ldap_attribute
      @ldap_attribute = LdapAttribute.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def ldap_attribute_params
      params.require(:ldap_attribute).permit(:order, :name, :field_type_id, :enable)
    end
end
