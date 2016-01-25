class ContextController < ApplicationController
  protect_from_forgery #, except: [:auth, :validate, :parse]
  before_filter :default_format_json
  #get method
  def getcontext
    #if (params.has_key?'inuser') and (params.has_key?'inpassword') then
    respond_to do |format|
        format.json do
          render :json=> {
            :context=>params[:id]
          }
        end
    end
  end
  #post method
  def createcontext
    respond_to do |format|
        format.json do
          render :json=> {
            :context=>params[:id]
          }
        end
    end
  end
  #get method
  def gettoken
  end
  #post method
  def createtoken
  end
  def error
    respond_to do |format|
        format.json do
          render :json=> {"rc":-1,"message":"Invalid context/token requested"}
        end
    end
  end
  private
  def default_format_json
    if(request.headers["HTTP_ACCEPT"].nil? || params[:format].nil?)
      request.format = "json"
    end
  end
end
