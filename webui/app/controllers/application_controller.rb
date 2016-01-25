class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :set_logged_user, :cors_preflight_check
  after_filter :cors_set_access_control_headers

# For all responses in this controller, return the CORS access control headers.

def cors_set_access_control_headers
  headers['Access-Control-Allow-Origin'] = '*'
  headers['Access-Control-Allow-Methods'] = 'PUT,DELETE,AUTH,POST, GET, OPTIONS'
  headers['Access-Control-Allow-Headers'] = '*'
  headers['Access-Control-Max-Age'] = "1728000"
end

# If this is a preflight OPTIONS request, then short-circuit the
# request, return only the necessary headers and return an empty
# text/plain.

def cors_preflight_check
  if request.method == :options
	headers['Access-Control-Allow-Origin'] = '*'
	headers['Access-Control-Allow-Methods'] = 'PUT,DELETE,AUTH,POST, GET, OPTIONS'
	headers['Access-Control-Allow-Headers'] = '*'
	headers['Access-Control-Max-Age'] = '1728000'
	render :text => '', :content_type => 'text/plain'
  end
end

def flushFlashMessages
	flash.each do |name, msg|
		flash.delete(:name)
	end
end

private
  def set_logged_user
    if !(params[:controller].eql? "welcome") and !(params[:controller].eql? "api") and !(params[:controller].eql? "context")
      if session[:is_user_validated]
        @@user=User.find_by_id(session[:user_id])
      else
          redirect_to root_url
      end
    end
  end
end
