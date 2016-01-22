class LogsController < ApplicationController
  def index
    #@mappings=Mapping.where(id: Log.select("distinct whoid as id").where("whatid = 'mapping'").take(100)).take(100)
    #@instances=Instance.where(id: Log.select("distinct whoid as id").where("whatid = 'instance'").take(100)).take(100)
    #@users=User.where(id: Log.select("distinct whoid as id").where("whatid = 'user'").take(100)).take(100)
    @mappinglogs=Log.eager_load(:mapping).where("whatid = 'mapping' ").order(createddate: :desc).take(100)
    @instancelogs=Log.eager_load(:instance).where("whatid = 'instance' ").order(createddate: :desc).limit(100)
    @userlogs=Log.eager_load(:user).where("whatid = 'user' ").order(createddate: :desc).take(100)
	@userlogs.each do |log|
		p log.user
	end
  end
  
  def instances
    @instance=Instance.find(params[:id] )
    if @instance
      @instancelogs=Log.includes(:instance).where("whatid = 'instance' and whoid= #{params[:id]}").take(100)
    end
  end
  def mappings
    @mapping=Mapping.find(params[:id] )
    if @mapping
      @mappinglogs=Log.includes(:mapping).where("whatid = 'mapping' and whoid= #{params[:id]}").take(100)
    end
    
  end
  def users
    @user=User.find(params[:id] )
    if @user
      @userlogs=Log.includes(:user).where("whatid = 'user' and whoid= #{params[:id]}").take(100)
    end
    
  end

end
