require 'securerandom'
class ContextController < ApplicationController
  protect_from_forgery #, except: [:auth, :validate, :parse]
  before_filter :default_format_json
  #get method
  def getcontext
    #if (params.has_key?'inuser') and (params.has_key?'inpassword') then
	context=Context.find_by_accesskey_and_instance_id(params[:id],params[:instance_id])
	if context.nil?
    respond_to do |format|
        format.json do
          render :json=> {"rc":-1,"message":"Invalid context/token requested", "status":"errored"}
        end
    end
	else
		respond_to do |format|
			format.json do
			  render :json=> {
				:rc=>0,
				:instance=>params[:instance_id],
				:context=>{
					:id=>context.id,
					:accesskey=>context.accesskey,
					:securekey=>context.rawdata,
					:hashkey=>context.hashkey
				},
				:status=>'validated'
			  }
			end
		end
	end
  end
  #post method
  def createcontext
	respond_to do |format|
		format.json do
		  render :json=> {
			:rc=>0,
			:instance=>params[:instance_id],
			:context=>SecureRandom.hex(16),
			:status=>'generated'
		  }
		end
	end
  end
  #put method
  def savecontext
    instance=Instance.find_by_id(params[:instance_id])
	if instance.nil?
		respond_to do |format|
			format.json do
          render :json=> {"rc":-1,"message":"Invalid context/token requested", "status":"errored"}
			end
		end
	else
		context = instance.contexts.new(:accesskey=>params[:id])
		if instance.save
			respond_to do |format|
				format.json do
				  render :json=> {
					:rc=>0,
					:instance=>params[:instance_id],
					:context=>{
						:id=>context.id,
						:accesskey=>context.accesskey,
						:securekey=>context.rawdata,
						:hashkey=>context.hashkey
					},
					:status=>'saved'
				  }
				end
			end
		else
			respond_to do |format|
				format.json do
			  render :json=> {"rc":-1,"message":"Invalid context/token requested", "status":"errored"}
				end
			end
		end
	end		
  end  
  #get method
  def gettoken
  end
  #post method
  def createtoken
 	context=Context.find_by_accesskey_and_instance_id(params[:context_id],params[:instance_id])
	if context.nil?
		respond_to do |format|
			format.json do
			  render :json=> {"rc":-1,"message":"Invalid context/token requested", "status":"errored"}
			end
		end
	else
		token=context.contexttokens.new(:context_token_data=>params[:value])
		if context.save
			respond_to do |format|
				format.json do
				  render :json=> {
					:rc=>0,
					:instance=>params[:instance_id],
					:context=>params[:context_id],
					:token=>token.context_token,
					:status=>'token generated'
				  }
				end
			end
		else
			respond_to do |format|
				format.json do
				  render :json=> {"rc":-1,"message":"Invalid context/token requested", "status":"errored"}
				end
			end
		end
	end
  end
  
  def error
    respond_to do |format|
        format.json do
          render :json=> {"rc":-1,"message":"Invalid context/token requested", "status":"errored"}
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


