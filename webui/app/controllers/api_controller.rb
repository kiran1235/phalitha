class ApiController < ApplicationController
  layout :resolve_layout
  protect_from_forgery #, except: [:auth, :validate, :parse]
  before_filter :default_format_json, except: :auth

    
  # def decrypt
    # test=PhalithaEngine.new
    # test.setup("887f5b14e6f789a282c583726c18f9e9b6f2d62c78872318c0f4c11e815deb3f","c4d72089d73800fee7fd29709144ec6b")
    # puts test.decrypt("8aa999ecbc61b36eb28020892e1c948c")    
    # respond_to do |format|
        # format.json do
          # render :json=> {
            # :rc => "0",
            # :result=> test.decrypt("8aa999ecbc61b36eb28020892e1c948c")  
            # }
        # end
      # end    
  # end
  def auth
		url=url_for(controller: 'api',
				action: 'auth',
				message: 'Login!',
				only_path: false)  
		render 'auth.html', locals: {url: url}
  end
  def validate
	data={:rc => 1,:message => "try again"}
	if (params.has_key?'inuser') and (params.has_key?'inpassword') then
		@user=User.find_by_username_and_hashkey(params[:inuser],User.generate_hashkey(params[:inuser],params[:inpassword]))
		if @user.nil?
			data[:rc] = 1 
			data[:message] = "try again"
	    else
			data[:rc] = 0 
			data[:message] = "welcome"
			data[:url]="//#{request.env["HTTP_HOST"]}/preloader.gif"
			data[:token]="#{SecureRandom.hex(64)}"
			@user.usertokens.new(:data=>data[:token], :requestdata => "User Logged In")
			@user.save
			
		end
	end
    respond_to do |format|
        format.json do
          render :json=> data
        end
      end    
		
  end
  def parse
	@engine=PhalithaEngine.new
	@engine.setup("887f5b14e6f789a282c583726c18f9e9b6f2d62c78872318c0f4c11e815deb3f","c4d72089d73800fee7fd29709144ec6b")
	fields=[]
	
	#sleep(5)
	data={:rc => 1, :message => "Invalid", :values=> fields}  
	if (params.has_key?'data') and (params.has_key?'token') then
		usertoken=Usertoken.find_by_data(params[:token])
		if usertoken.nil? then
			data={:rc => 1, :message => "Not Found", :values=> fields}  
		else
			fieldaccesscodes=[]
			requestdata=[]
			params[:data].split(",").each do |v|
				o=v.split(":")
				fieldaccesscodes << o[0]
				d={
					:accesscode => v,
					:key => o[0],
					:value => o[1]
				}
				requestdata << d
			end
			@user=usertoken.user
			fields=@user.mapping_fields.select('accesscode').where(:accesscode =>fieldaccesscodes)
			fields.each do |field|
				requestdata.each_with_index do |item,index|
					if item[:key].eql? field[:accesscode]
						requestdata[index][:value] = @engine.decrypt(requestdata[index][:value])
					end
				end
			end
			requestdata.each_with_index do |item,index|
				requestdata[index].delete(:key)
			end
			
			
			
			
			data={:rc => 0, :message => "success", :values=> requestdata}  
		end
	end
    respond_to do |format|
        format.json do
          render :json=> data
        end
    end    
  end
  private
  def resolve_layout
	"api"
  end
  def default_format_json
    if(request.headers["HTTP_ACCEPT"].nil? || params[:format].nil?)
      request.format = "json"
    end
  end  
end
