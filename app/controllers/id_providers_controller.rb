class IdProvidersController < ApplicationController
  before_action :set_id_provider, only: [:show, :edit, :update]

  def index
    @id_provider = IdProvider.first
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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_id_provider
      @id_provider = IdProvider.find(params[:id]) rescue IdProvider.first
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def id_provider_params
      params.require(:id_provider).permit(:name, :entity_id, :host_name, :scope, :cert, :key, :ca_cert)
    end
end
