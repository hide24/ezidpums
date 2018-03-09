class IdpAttributeAssignsController < ApplicationController
  before_action :set_service_provider, only: [:edit, :update, :destroy]

  # GET /idp_attribute_assigns
  # GET /idp_attribute_assigns.json
  def index
    @service_providers = ServiceProvider.all
  end

  # GET /idp_attribute_assigns/1/edit
  def edit
    @idp_attributes = IdpAttribute.all
  end

  # PATCH/PUT /idp_attribute_assigns/1
  # PATCH/PUT /idp_attribute_assigns/1.json
  def update
    @service_provider.idp_attribute_ids = params[:idp_attribute_id]
    ref_path = Rails.application.routes.recognize_path(request.referer) rescue {}
    @template = [ref_path[:controller], 'tr'].compact.join('/')

    respond_to do |format|
      if @service_provider.save
        format.html { redirect_to({action: :index}, {notice: 'IdP attribute assign was successfully updated.'}) }
        format.json { render :show, status: :ok, location: @service_provider }
        format.js { @status = 'success' }
      else
        format.html { render :edit }
        format.json { render json: @service_provider.errors, status: :unprocessable_entity }
        format.js { @status = 'fail' }
      end
    end
  end

  # DELETE /idp_attribute_assigns/1
  # DELETE /idp_attribute_assigns/1.json
  def destroy
    IdpAttributeAssign.where(service_provider_id: params[:id]).delete_all
    respond_to do |format|
      format.html { redirect_to({action: :index}, {notice: 'IdP attribute assign was successfully destroyed.'}) }
      format.json { head :no_content }
      format.js { @status = 'success'}
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_service_provider
      @service_provider = ServiceProvider.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def idp_attribute_assign_params
      params.permit(idp_attribute_id: [])
    end
end
