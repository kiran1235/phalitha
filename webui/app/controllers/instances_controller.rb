class InstancesController < ApplicationController
  
  def index
      @instances=@@user.instances
  end
  def new
    @instance = Instance.new
  end
  def create
    @instance = @@user.instances.new(instance_new_params)
    if @@user.save
      log=Log.new
      log[:whatid]='user'
      log[:whoid]=@@user[:id]
      log[:logdata]="#{@@user[:name]} created new instance #{@instance[:name]}(#{@instance[:id]})"
      log.save       
      
      flash[:info]="Instance is created"
      respond_to do |format|
          format.json do
            render :json=> {
              :rc => "0",
              :redirect=> instance_url(@instance) 
            }
          end
        end    
        return
    else
      respond_to do |format|
          format.json do
            render :json=> {
              :rc => "1",
              :errors=> @instance.errors
            }, :status => 200
          end
        end    
        return
    end
  end
  
  def show
    log=Log.new
    log[:whatid]='instance'
    log[:whoid]=params[:id]
    @instance=@@user.instances.find(params[:id])
    # @mappings = @@user.mappings.where(instance_id: params[:id]).take(100)
    @mappings = @instance.mappings
    @users = @instance.users
    log[:logdata]="#{@@user[:name]} is accessing list of instances belongs to #{@instance[:name]}(#{params[:id]}) "
    log.save  
  end
  
 
  def delete
    
  end
  
  private
    def instance_params
      params.permit(:id)
    end  
    def instance_new_params
      params.require(:instance).permit(:name, :description)
    end
end
