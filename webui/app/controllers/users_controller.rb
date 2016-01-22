class UsersController < ApplicationController
  before_filter :default_format_json, only: [:destroy]
  def default_format_json
    if(request.headers["HTTP_ACCEPT"].nil? || params[:format].nil?)
      request.format = "json"
    end
  end
    
  def index
    #az0ScsiGF7ENty/Nxp6eXFruhpmfgttu31YVMewSrOQ=
  end
  def new
    @user=Instance.find_by_id(params[:instance_id]).users.new
  end
  def create
    @instance=Instance.find_by_id(params[:instance_id])
    user = @instance.users.new(user_new_params)
    #user.username=params[:username]
    #user.name=params[:name]
    user.hashkey=User.generate_hashkey(params[:username],params[:hashkey])
    if @instance.save
      log=Log.new
      log[:whatid]='user'
      log[:whoid]=@@user[:id]
      log[:logdata]="#{@@user[:name]} created new user (#{user.username}) in #{@instance[:name]}(#{@instance[:id]})"
      log.save 
      log=Log.new
      flash[:info]="User is created"
      redirect_to instances_url(@instance[:id])
    else
            
    end    
  end  
  def show
    
  end
  
  def destroy
    if params[:id].to_i >=1
        instance=@@user.instances.find(params[:instance_id])
        user=instance.users.find(params[:id])
        user.destroy
        respond_to do |format|
          format.json do
            render :json=> {
              :rc => "0",
              :callback_data_id=> "iu#{params[:instance_id]}_#{params[:id]}"
            }
            return
          end
        end    
    else
        respond_to do |format|
          format.json do
            render :json=> {
              :rc => "1",
              :error=> "requested information is not found"
            }
            return
          end
        end    
    end
    
  end
  
  private
    def user_new_params
      params.require(:user).permit(:username,:name, :hashkey)
    end  
  
  
end
