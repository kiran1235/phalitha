class WelcomeController < ApplicationController
  protect_from_forgery except: :index
  
  layout :resolve_layout
  #before_filter :default_format_json
  #@@admin_username="superadmin@phalitha.com"
  #@@admin_password="superphalitha"

  def default_format_json
    if(request.headers["HTTP_ACCEPT"].nil? || params[:format].nil?)
      request.format = "json"
    end
  end
  
  def index
    flushFlashMessages
    session[:is_user_validated]=false
    if request.post? then
      if params[:inUsername] !=nil && params[:inPassword] != nil then
        #p User.generate_hashkey(params[:inUsername],params[:inPassword])
        @user=User.find_by_hashkey(User.generate_hashkey(params[:inUsername],params[:inPassword]))
        if !@user.nil? then
          session[:is_user_validated]=true
          session[:user_id]=@user[:id]
          log=Log.new
          log[:whatid]='user'
          log[:whoid]=@user[:id]
          log[:logdata]="#{@user[:name]} logged into the application"
          log.save  
          redirect_to instances_url
          
          # respond_to do |format|
            # format.json do
              # render :json=> {
                # :rc => "0",
                # :redirect=> "#{instances_url}"
              # }
              # return
            # end
          # end    
          
          return
        else
          flash[:error] = "Hi There! Please try again"
          session[:is_user_validated]=false
          # respond_to do |format|
            # format.json do
              # render :json=> {
                # :rc => "1",
                # :message=> "Hi There! Please try again"
              # }
              # return
            # end
          # end    
#           
          # return
        end
      end
    end
  end
  
  def logout
    log=Log.new
    log[:whatid]='user'
    log[:whoid]=@@user[:id]
    log[:logdata]="#{@@user[:name]} signout from the system"
    log.save
    #session.destroy
    session[:is_user_validated]=false
    session[:user_id]=0
    session[:user_name]='Guest'
    
    redirect_to root_url
  end
  
  # def savenewinstance
  # @instance = Instance.new  
  # respond_to do |format|
      # format.json do
        # render :json=> {
          # :rc => "0",
          # :output=> [
            # "id" => 0
          # ]
        # }
        # return
      # end
    # end    
  #end  
  
  private
  def resolve_layout
    case action_name
    when "index"
      "index"
    else
      "application"
    end
  end    
end
