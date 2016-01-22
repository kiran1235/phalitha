require 'thin'
require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/cross_origin'
require 'sinatra/reloader'
require 'sinatra/param'
require 'json'
require 'yaml'
require 'mysql2'
require 'logger'
require 'rack/csrf'
require 'digest/md5'
require 'erb'
require 'securerandom'
require 'rack/cors'
#require 'rmagick'
#require 'activerecord/session_store'

Dir["/apps/phalitha/webui/app/models/*.rb"].each {|file| require file }
DB_CONFIG = YAML::load(File.open('database.yml'))
#Tilt.register Tilt::ERBTemplate, 'html.erb'



class PhalithaCapcha
	def self.generate(digits,targetlocation)
		granite = Magick::ImageList.new('granite:')
		canvas = Magick::ImageList.new
		canvas.new_image(100, 50, Magick::TextureFill.new(granite))
		text = Magick::Draw.new
		text.font_family = 'helvetica'
		text.pointsize = 16
		text.gravity = Magick::CenterGravity
		text.annotate(canvas, 0,0,2,2, digits) {
			self.fill = 'gray83'
		}

		text.annotate(canvas, 0,0,-1.5,-1.5, digits) {
			self.fill = 'gray40'
		}

		text.annotate(canvas, 0,0,0,0, digits) {
			self.fill = 'darkred'
		}
		
		canvas.write(targetlocation)
		
	end
end

class PhalithaEngine
  @@key="^$^|^$^~^$^|^$^h^$^|^$^~^$^|^$^~^$^|^$^|^$^~^$^|^$^~^$^|^$^|^$^~^$^|^$^c^$^|^$^~^$^|^$^u^$^|^$^~^$^|^$^|^$^~^$^|^$^o^$^|^$^~^$^|^$^m^$^|^$^~^$^|^$^$^|^$^~^$^|^$^r^$^|^$^~^$^|^$^k^$^|^$^~^$^|^$^$^|^$^~^$^|^$^y^$^|^$^~^$^|^$^h^$^|^$^~^$^|^$^~^$^|^$^|^$^~^$^|^$^~^$^|^$^|^$^~^$^|^$^c^$^|^$^~^$^|^$^u^$^|^$^~^$^|^$^|^$^~^$^|^$^o^$^|^$^~^$^|^$^m^$^|^$^~^$^|^$^$^|^$^~^$^|^$^r^$^|^$^~^$^|^$^k^$^|^$^~^$^|^$^$^|^$^~^$^|^$^y^$^|^$^~^$^|^$^h^$^|^$^~^$^|^$^~^$^|^$^|^$^~^$^|^$^~^$^|^$^|^$^~^$^|^$^c^$^|^$^~^$^|^$^u^$^|^$^~^$^|^$^|^$^~^$^|^$^o^$^|^$^~^$^|^$^m^$^|^$^~^$^|^$^$^|^$^~^$^|^$^r^$^|^$^~^$^|^$^k^$^|^$^~^$^|^$^$^|^$^~^$^|^$^y^$^|^$^~^$^|^$^h^$^|^$^~^$^|^$^~^$^|^$^|^$^~^$^|^$^~^$^|^$^|^$^~^$^|^$^c^$^|^$^~^$^|^$^u^$^|^$^~^$^|^$^|^$^~^$^|^$^o^$^|^$^~^$^|^$^m^$^|^$^~^$^|^$^$^|^$^~^$^|^$^r^$^|^$^~^$^|^$^k^$^|^$^~^$^|^$^$^|^$^~^$^|^$^y^$^|^$^~^$^|^$^h^$^|^$^~^$^|^$^~^$^|^$^|^$^~^$^|^$^~^$^|^$^|^$^~^$^|^$^c^$^|^$^~^$^|^$^u^$^|^$^~^$^|^$^|^$^~^$^|^$^o^$^|^$^~^$^|^$^m^$^|^$^~^$^|^$^$^|^$^~^$^|^$^r^$^|^$^~^$^|^$^k^$^|^$^~^$^|^$^$^|^$^~^$^|^$^y^$^|^$^~^$^|^$^h^$^|^$^~^$^|^$^~^$^|^$^|^$^~^$^|^$^~^$^|^$^|^$^~^$^|^$^c^$^|^$^~^$^|^$^u^$^|^$^~^$^|^$^|^$^~^$^|^$^o^$^|^$^~^$^|^$^m^$^|^$^~^$^|^$^$^|^$^~^$^|^$^r^$^|^$^~^$^|^$^k^$^|^$^~^$^|^$^$^|^$^~^$^|^$^y^$^|^$^~^$^|^$^h^$^|^$^~^$^|^$^~^$^|^$^|^$^~^$^|^$^~^$^|^$^|^$^~^$^|^$^c^$^|^$^~^$^|^$^u^$^|^$^~^$^|^$^|^$^~^$^|^$^o^$^|^$^~^$^|^$^m^$^|^$^~^$^|^$^$^|^$^~^$^|^$^r^$^|^$^~^$^|^$^k^$^|^$^~^$^|^$^$^|^$^~^$^|^$^y^$^|^$^~^$^|^$^h^$^|^$^~^$^|^$^~^$^|^$^|^$^~^$^|^$^~^$^|^$^|^$^~^$^|^$^c^$^|^$^~^$^|^$^u^$^|^$^~^$^|^$^|^$^~^$^|^$^o^$^|^$^~^$^|^$^m^$^|^$^~^$^|^$^$^|^$^~^$^|^$^r^$^|^$^~^$^|^$^k^$^|^$^~^$^|^$^$^|^$^~^$^|^$^y^$^|^$^~^$^|^$^h^$^|^$^~^$^|^$^~^$^|^$^|^$^~^$^|^$^~^$^|^$^|^$^~^$^|^$^c^$^|^$^~^$^|^$^u^$^|^$^~^$^|^$^|^$^~^$^|^$^o^$^|^$^~^$^|^$^m^$^|^$^~^$^|^$^$^|^$^~^$^|^$^r^$^|^$^~^$^|^$^k^$^|^$^~^$^|^$^$^|^$^~^$^|^$^y^$^|^$^~^$^|^$^h^$^|^$^~^$^|^$^~^$^|^$^|^$^~^$^|^$^~^$^|^$^|^$^~^$^|^$^c^$^|^$^~^$^|^$^u^$^|^$^~^$^|^$^|^$^~^$^|^$^o^$^|^$^~^$^|^$^m^$^|^$^~^$^|^$^$^|^$^~^$^|^$^r^$^|^$^~^$^|^$^k^$^|^$^~^$^|^$^$^|^$^~^$^|^$^y^$^|^$^~^$^|^$^h^$^|^$^~^$^|^$^~^$^|^$^|^$^~^$^|^$^~^$^|^$^|^$^~^$^|^$^c^$^|^$^~^$^|^$^u^$^|^$^~^$^|^$^|^$^~^$^|^$^o^$^|^$^~^$^|^$^m^$^|^$^~^$^|^$^$^|^$^~^$^|^$^r^$^|^$^~^$^|^$^k^$^|^$^~^$^|^$^$^|^$^~^$^|^$^y^$^|^$^~^$^|^$^h^$^|^$^~^$^|^$^~^$^|^$^|^$^~^$^|^$^~^$^|^$^|^$^~^$^|^$^c^$^|^$^~^$^|^$^u^$^|^$^~^$^|^$^|^$^~^$^|^$^o^$^|^$^~^$^|^$^m^$^|^$^~^$^|^$^$^|^$^~^$^|^$^r^$^|^$^~^$^|^$^k^$^|^$^~^$^|^$^$^|^$^~^$^|^$^y^$^|^$^~^$^|^$^h^$^|^$^~^$^|^$^~^$^|^$^|^$^~^$^|^$^~^$^|^$^|^$^~^$^|^$^c^$^|^$^~^$^|^$^u^$^|^$^~^$^|^$^|^$^~^$^|^$^o^$^|^$^~^$^|^$^m^$^|^$^~^$^|^$^$^|^$^~^$^|^$^r^$^|^$^~^$^|^$^k^$^|^$^~^$^|^$^$^|^$^~^$^|^$^y^$^|^$^~^$^|^$^h^$^|^$^~^$^|^$^~^$^|^$^|^$^~^$^|^$^~^$^|^$^|^$^~^$^|^$^c^$^|^$^~^$^|^$^u^$^|^$^~^$^|^$^|^$^~^$^|^$^o^$^|^$^~^$^|^$^m^$^|^$^~^$^|^$^$^|^$^~^$^|^$^r^$^|^$^~^$^|^$^k^$^|^$^~^$^|^$^$^|^$^~^$^|^$^y^$^|^$^~^$^|^$^h^$^|^$^~^$^|^$^~^$^|^$^|^$^~^$^|^$^~^$^|^$^|^$^~^$^|^$^c^$^|^$^~^$^|^$^u^$^|^$^~^$^|^$^|^$^~^$^|^$^o^$^|^$^~^$^|^$^m^$^|^$^~^$^|^$^$^|^$^~^$^|^$^r^$^|^$^~^$^|^$^k^$^|^$^~^$^|^$^$^|^$^~^$^|^$^y^$^|^$^~^$^|^$^h^$^|^$^~^$^|^$^~^$^|^$^|^$^~^$^|^$^~^$^|^$^|^$^~^$^|^$^c^$^|^$^~^$^|^$^u^$^|^$^~^$^|^$^|^$^~^$^|^$^o^$^|^$^~^$^|^$^m^$^|^$^~^$^|^$^$^|^$^~^$^|^$^r^$^|^$^~^$^|^$^k^$^|^$^~^$^|^$^$^|^$^~^$^|^$^y"
  @@iv="^$^|^$^~^$^|^$^h^$^|^$^~^$^|^$^~^$^|^$^|^$^~^$^|^$^~^$^|^$^|^$^~^$^"
  def initialize (key=nil, iv=nil)
	setup(key,iv)
  end  
  def setup (key, iv)
	if key.nil? || key.empty? || key.size <0 
		@@key=@@key
	else
		@@key=key
	end
	
	if iv.nil? || iv.empty? || iv.size <0 
		@@iv=@@iv
	else
		@@iv=iv
	end
  end  
  def getRandomKeyAndIVForAES256
	agent=OpenSSL::Cipher::AES.new(256,:CBC)
	agent.encrypt
	return [:key => agent.random_key.unpack('H*').first, :iv => agent.random_iv.unpack('H*').first]
  end
  def encrypt (value)
	begin
		@agent=OpenSSL::Cipher::AES.new(256,:CBC)
		@agent.encrypt
		@agent.key=@@key
		@agent.iv=@@iv
		encvalue='' << @agent.update(value) << @agent.final
		str=encvalue.unpack('H*').first
		return str
	rescue
		puts $!, $@
		return false
	end
  end
  
  def decrypt(value)
	begin
		@agent=OpenSSL::Cipher::AES.new(256,:CBC)
		@agent.decrypt
		@agent.key=@@key
		@agent.iv=@@iv
		binary=value.scan(/../).map { |x| x.hex.chr }.join
		plain = '' << @agent.update(binary) << @agent.final
		return plain
	rescue
		puts $!, $@
		return false
	end
  end
  
  def xmlparser (sourcefilepath,targetfilepath,fieldoptions)
	begin
		xml_doc=Nokogiri::XML(File.open(sourcefilepath)) do |config|
			config.options = Nokogiri::XML::ParseOptions::STRICT | Nokogiri::XML::ParseOptions::NONET
		end
		
		fieldoptions.each do |option|
			if (option.key?(:xpath)) && (option.key?(:senstivity))
				if option[:senstivity].eql?"AES256"
					elements=xml_doc.xpath(option[:xpath])
					elements.each do |element|
						element.content=encrypt(element.text)
						element["accesscode"]=option[:accesscode]
					end
				end
			end
		end
		File.open(targetfilepath,"w"){ |f| f << xml_doc }
		return true
	rescue
		puts $!, $@
		return false
	end
  end
end



set :bind, '0.0.0.0'
set :port, 3002
set :protection, true
set :sessions, true
set :session_secret, '*&(^B234'
set	:logging, true
set :root, File.dirname(__FILE__)
set :views, Proc.new { File.join(root, "views") } 
set :public_folder, Proc.new { File.join(root, "public") }
#set :static_cache_control, [:public, :max_age => 300]
set :database, "mysql2://#{DB_CONFIG['username']}:#{DB_CONFIG['password']}@#{DB_CONFIG['host']}:#{DB_CONFIG['port']}/#{DB_CONFIG['database']}"
set :allow_origin, :any
set :allow_methods, [:get, :post, :options]
set :allow_credentials, true
set :max_age, "1728000"
set :expose_headers, ['Content-Type', 'Accept','X-USER-TOKEN', 'X-Requested-With', 'Session', 'Content-Type', 'Content-Range', 'Content-Disposition', 'Content-Description']
set :allow_headers, ['X-USER-TOKEN']
configure do
	enable :cross_origin
end

before do
  def csrf_token
	SecureRandom.hex(6)
  end

  def csrf_tag
	"<input type='hidden' name='_csrf' value='#{csrf_token}' />"
  end
  
  def generate_random_key csrf
	Digest::MD5::hexdigest("#{csrf}")
  end
  
end

get '/' do
	content_type :json
	JSON.pretty_generate(request.env)
	#content_type :html
	#erb :'auth.html' ,:locals => {:url => request.env[:path], :csrf_tag => csrf_tag}
end

get '/auth' do
	cross_origin
	param :inuser,           String
	param :inpassword,		 String
	data={}
	data[:rc] = 1 
	data[:message] = "try again"
	if (params.has_key?'inuser') and (params.has_key?'inpassword') then
		@user=User.find_by_username_and_hashkey(params[:inuser],User.generate_hashkey(params[:inuser],params[:inpassword]))
		if @user.nil?
			data[:rc] = 1 
			data[:message] = "try again"
			content_type :json
			data.to_json
		else
			data[:rc] = 0 
			data[:message] = "welcome"
			data[:url]="//#{request.env["HTTP_HOST"]}/preloader.gif"
			response.headers["X-USER-TOKEN"] = "#{generate_random_key(csrf_token)}"
			content_type :json
			data.to_json
		end
	else
		content_type :html
		erb :'auth.html' ,:locals => {:url => "//#{request.env["HTTP_HOST"]}#{request.env["REQUEST_PATH"]}", :csrf_tag => csrf_tag}
	end
end

options '/parse' do
	param :token,          String
	sleep(5)
	return false
end	
get '/parse' do
	param :data,           String
	param :token,          String
	p "hey u"
	p session
	@engine=PhalithaEngine.new
	@engine.setup("887f5b14e6f789a282c583726c18f9e9b6f2d62c78872318c0f4c11e815deb3f","c4d72089d73800fee7fd29709144ec6b")
	fields=[]
	#p request.env
	sleep(5)
	params[:data].split(",").each do |v|
		o=v.split(":")
		field={
			:accesscode => v,
			:value => @engine.decrypt(o[1])
		}
		fields << field
	end
	data={:rc => 0, :message => "success", :values=> fields}
	content_type :json
	data.to_json
end

