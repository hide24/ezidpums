class LdapController < ApplicationController
  def index
    @account_exports = AccountExport.order('created_at desc').take(10)
  end

  def all
    @account_exports = AccountExport.order('created_at desc').all

    respond_to do |format|
      format.html { render :index }
      format.js
    end
  end

  def download
    if params[:id] == 'new'
      @account_export = AccountExport.dump
    else
      @account_export = AccountExport.find(params[:id])
    end

    respond_to do |format|
      format.html { send_data @account_export.csv, filename: @account_export.filename('csv') }
      format.csv { send_data @account_export.csv, filename: @account_export.filename('csv') }
      format.xls { send_data @account_export.xls, filename: @account_export.filename('xls') }
    end
  end

  def restore
    @account_export = AccountExport.find(params[:id])
    begin
      @account_export.load
      flash.now[:notice] = ['Account data was successfully restored from backup data that saved at %s.' % @account_export.created_at.to_formatted_s(:date_time)]
    rescue
      flash.now[:warn] = ['Error occured. Plese try again.']
    end

    respond_to do |format|
      format.html { render :index }
      format.js
    end
  end

  def upload
    @account_import = AccountImport.accept(params[:upload_file].read)

    respond_to do |format|
      format.html 
      format.json { render :upload, status: :created, location: @account_import }
      format.js
    end
  end

  def update
    @account_import = AccountImport.find(params[:id])
    
    respond_to do |format|
      if @account_import.load
        format.html { redirect_to({action: 'index'}, {notice: ['Account data was successfully updated.']}) }
        format.js { redirect_to({action: 'index'}, {notice: ['Account data was successfully updated.']}) }
      else
        format.html { redirect_to({action: 'index'}, {flash: {warn: @account_import.errors.full_messages}}) }
        format.js { redirect_to({action: 'index'}, {flash: {warn: @account_import.errors.full_messages}}) }
      end
    end
  end

  private
  def account_import_url(*args)
    url_for(action: 'upload')
  end
end
