class IdpAttributesController < ApplicationController
  before_action :set_idp_attribute, only: [:show, :edit, :update, :destroy]

  # GET /idp_attributes
  # GET /idp_attributes.json
  def index
    @idp_attributes = IdpAttribute.all
  end

  # GET /idp_attributes/1
  # GET /idp_attributes/1.json
  def show
  end

  # GET /idp_attributes/new
  def new
    @idp_attribute = IdpAttribute.new
  end

  # GET /idp_attributes/1/edit
  def edit
  end

  # POST /idp_attributes
  # POST /idp_attributes.json
  def create
    @idp_attribute = IdpAttribute.new(idp_attribute_params)

    respond_to do |format|
      if @idp_attribute.save
        format.html { redirect_to @idp_attribute, notice: 'IdP attribute was successfully created.' }
        format.json { render :show, status: :created, location: @idp_attribute }
        format.js { @status = 'success'}
      else
        format.html { render :new }
        format.json { render json: @idp_attribute.errors, status: :unprocessable_entity }
        format.js { @status = 'fail' }
      end
    end
  end

  # PATCH/PUT /idp_attributes/1
  # PATCH/PUT /idp_attributes/1.json
  def update
    respond_to do |format|
      if @idp_attribute.update(idp_attribute_params)
        format.html { redirect_to @idp_attribute, notice: 'IdP attribute was successfully updated.' }
        format.json { render :show, status: :ok, location: @idp_attribute }
        format.js { @status = 'success'}
      else
        format.html { render :edit }
        format.json { render json: @idp_attribute.errors, status: :unprocessable_entity }
        format.js { @status = 'fail' }
      end
    end
  end

  # DELETE /idp_attributes/1
  # DELETE /idp_attributes/1.json
  def destroy
  #  @idp_attribute.destroy
    respond_to do |format|
      format.html { redirect_to idp_attributes_url, notice: 'IdP attribute can not be destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_idp_attribute
      @idp_attribute = IdpAttribute.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def idp_attribute_params
      params.require(:idp_attribute).permit(:order, :name, :attribute_resolver, :enable)
    end
end
