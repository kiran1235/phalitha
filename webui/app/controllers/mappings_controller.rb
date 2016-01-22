class MappingsController < ApplicationController
  layout :resolve_layout
  before_filter :default_format_json, :only => [:saveuser]
  def new
    @instance=Instance.find_by_id(params[:instance_id])
    @mapping=@instance.mappings.new
  end
  def create
    @instance=@@user.instances.find(params[:instance_id])
    @mapping = @instance.mappings.new(instance_mapping_new_params)
    @@user.mappings << @mapping
    
    if @@user.save
      log=Log.new
      log[:whatid]='mapping'
      log[:whoid]=@mapping[:id]
      log[:logdata]="#{@@user[:name]} created new mapping (#{@mapping.name}) in #{@instance[:name]}(#{@instance[:id]})"
      log.save 
      
      flash[:info]="Mapping is created"
      #redirect_to instance_mapping_fields_path(@instance,@mapping)
      redirect_to :action => 'show', :id=> @mapping[:id], :instance_id =>params[:instance_id], :s => 2
      # respond_to do |format|
          # format.json do
            # render :json=> {
              # :rc => "0",
              # :remoteform=> instance_mapping_fields_path(@instance,@mapping)
            # }
          # end
      # end    
      # return
    else
      render 'new'
      # respond_to do |format|
          # format.json do
            # render :json=> {
              # :rc => "1",
              # :errors=> @mapping.errors
            # }, :status => 200
          # end
        # end    
        # return
    end 
    return
  end
  
  def show
    @mapping=@@user.mappings.find_by_id_and_instance_id(params[:id],params[:instance_id])
    if @mapping.nil? 
      render 'error.html'
      
      # respond_to do |format|
          # format.json do
            # render :json=> {
              # :rc => "1",
              # :errors=> @instance.errors
            # }, :status => 500
          # end
        # end    
      return
    else
      @instance=@@user.instances.find_by_id(params[:instance_id])
      @mapping_users=@mapping.users
      @fields=@mapping.mapping_fields
      @field_users={}
      @fields.each do |field|
        if field.sensitivity.to_i >= 1
          @field_users["#{field[:id]}"]=[]
          field.users.find_each do |usr|
            @field_users["#{field[:id]}"]  << usr
          end
        end
      end
      if params.has_key?(:s)
        @pagesection=params[:s].to_i
      elsif @fields.size >0
        @pagesection=1
      else
        @pagesection=2
      end
    end
  end
  
  def destroy
    mapping=@@user.mappings.find_by_id_and_instance_id(params[:id],params[:instance_id])
    mapping.users.each do |mu| mu.mappings.delete(mapping) end
    mapping.mapping_fields.each do |mu| mu.delete end
    mapping.destroy
    redirect_to instance_path(params[:instance_id])
  end
  
  def newuser
    @mapping=@@user.mappings.find_by_id_and_instance_id(params[:mapping_id],params[:instance_id])
    mapping_users=[]
    
    @mapping.users.each do|mapping_user|
      mapping_users << mapping_user[:id]
    end
    
    @instance=@@user.instances.find(params[:instance_id])
    @instance_users=@instance.users.select('id','name','username').where('id not in (?)',mapping_users)
    render partial: 'newuser'
  end
  
  def deleteuser
    @mapping=@@user.mappings.find_by_id_and_instance_id(params[:mapping_id],params[:instance_id])
    @mapping_users=@mapping.users
    
    # @mapping.users.each do|mapping_user|
      # mapping_users << mapping_user[:id]
    # end
#     
    @instance=@@user.instances.find(params[:instance_id])
    # @instance_users=@instance.users.select('id','name','username').where('id not in (?)',mapping_users)
    render partial: 'deleteuser'
  end  

  def saveuser
    @mapping=@@user.mappings.find_by_id_and_instance_id(params[:mapping_id],params[:instance_id])
    newusers=params[:user_selected].uniq
    existing_mapping_users=@mapping.users.where('id in (?)',newusers)
    exusers=[]
    existing_mapping_users.each do |eu|
      exusers << eu[:id]
    end
    new_uniq_users=newusers - exusers
    new_mapping_users=User.find(new_uniq_users)
    @mapping.users << new_mapping_users
    
    respond_to do |format|
        format.json do
          render :json=> {
            :rc => "0",
            :redirect => instance_mapping_path(@mapping[:instance_id],@mapping[:id],:s=>3)
          }
        end
    end    
    return
  end

  def removeuser
    @mapping=@@user.mappings.find_by_id_and_instance_id(params[:mapping_id],params[:instance_id])
    newusers=params[:user_selected].uniq
    existing_mapping_users=@mapping.users.where('id in (?)',newusers)
    @mapping.users.delete(existing_mapping_users)
    
    #existing_mapping_users.leave_mapping()
    
    respond_to do |format|
        format.json do
          render :json=> {
            :rc => "0"
          }
        end
    end    
    return
  end 
  
  def startmonitoring
	
  end
  
  
  private
    def resolve_layout
      case action_name
      when "newusers"
        "iframe"
      when "deleteuser"
        "iframe"
      else
        "application"
      end
    end  
    def default_format_json
      if(request.headers["HTTP_ACCEPT"].nil? || params[:format].nil?)
        request.format = "json"
      end
    end    
    def instance_params
      params.permit(:instance_id)
    end  
    def instance_mapping_new_params
      # //"name"=>"", "description"=>"", "sourcetype"=>"database", "sourcefilepath"=>"", "targetfilepath"=>"", "sourcefilename"=>""
# , "hostname"=>"", "portno"=>"11111", "encoding"=>"", "databasename"=>"", "username"=>"", "accesscode"=>"", "sourcename"=>"", "targetname"=>""}
      if !params['mapping'].nil? && params['mapping']['sourcetype'] == "xml" 
        params.require(:mapping).permit(:name, :description, :sourcetype, :sourcefilepath, :targetfilepath, :sourcefilename)
      elsif !params['mapping'].nil? && params['mapping']['sourcetype'] == "database" 
        params.require(:mapping).permit(:name, :description, :sourcetype, :hostname, :portno, :databasename, :username, :accesscode, :sourcename, :targetname, :encoding)
      else
        params.require(:mapping).permit(:name, :description, :sourcetype)
      end
    end  
end
