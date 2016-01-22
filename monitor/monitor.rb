require 'thin'
require 'json'
require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/reloader' if development?
require 'yaml'
require 'mysql2'
require 'logger'
require 'rb-inotify'
#require 'phalithaengine'
require 'thread'
require 'timers'
#require 'eventmachine'
require 'nokogiri'
require 'fileutils'

Dir["/apps/phalitha/webui/app/models/*.rb"].each {|file| require file }
DB_CONFIG = YAML::load(File.open('database.yml'))



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
  
  def decrypt (value)
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

class PhalithaEventHandler
  def initialize (eventqueue, logger)
	@eventqueue=eventqueue
	@logger=logger
	@timers = Timers::Group.new
	@engine=PhalithaEngine.new
	@engine.setup("887f5b14e6f789a282c583726c18f9e9b6f2d62c78872318c0f4c11e815deb3f","c4d72089d73800fee7fd29709144ec6b")
	@fieldoptions={}
  end
  def run(&block)
    prvid=0
	now_and_every_five_seconds = @timers.every(0.5) do
		if @eventqueue.empty?
			prvid=0
		else
			event = @eventqueue.pop
			if prvid != event[:id]
				@logger.info "Processing Job file:(#{event[:source]})"
				prvid=event[:id]
				if File.exist?(event[:source])
					if @fieldoptions["#{event[:id]}"].nil?
						mapping=Mapping.select("id,targetfilepath").find(event[:id])
						fields=mapping.mapping_fields.select("id,searchpath,accesscode").where("sensitivity='1'",event[:id])
						if !fields.nil?
							@fieldoptions["#{event[:id]}"]={
								"options" => []
							}
							fields.each do |field|
								option={
									:fieldid => field[:id],
									:xpath => field[:searchpath],
									:senstivity => "AES256",
									:accesscode => field[:accesscode]
								}
								@fieldoptions["#{event[:id]}"]["options"] << option
							end
						end
					end
					@engine.xmlparser(event[:source],event[:target],@fieldoptions["#{event[:id]}"]["options"])	
				end
			end
		end
	end
	loop { @timers.wait }
  end
end

class PhalithaEventMonitor
	def initialize (eventqueue,logger)
		@eventqueue=eventqueue
		@logger=logger
		@frequency=0.2
		@notifier=INotify::Notifier.new
		
	end
	def run(&block)
		while true
		  if IO.select([@notifier.to_io], [], [], @frequency)
			@notifier.process
		  end
		end
	end
	def watch(id,sourcepath,targetpath,filename)
		exp =[]
		exp << "^"
		filename.split("").each do |c|
				if c=="*"
						exp << "."
						exp << "*"
				elsif c=="."
						exp << "\\"
						exp << "."
				else
						exp << c
				end
		end
		exp << "$"
		exp=exp.join
		regexp=Regexp.new(exp)
		@logger.info "watching for files like #{exp} in #{sourcepath} for mapping(#{id})"
		@notifier.watch(sourcepath,:create,:close_write, :attrib,:delete) do |event|
			watcher=event.notifier.watchers[event.watcher_id]
			matched=regexp.match(event.name)
			if matched.nil? 
				#puts "#{watcher.path}#{event.name} is ignored"
				@logger.info "#{watcher.path}#{event.name} is ignored due to matching critera given for mapping(#{id})"
			else
				event.flags.each do |flag|
					flag=flag.to_s
					case flag
						when 'create' then @logger.info "#{watcher.path}#{event.name} is created"
						when 'delete' then @logger.info "#{watcher.path}#{event.name} is deleted"
						when 'attrib' then @logger.info "#{watcher.path}#{event.name} is attributes updated "
						when 'close_write' then 
							obj={
							:id => "#{id}",
							:source => "#{watcher.path}#{event.name}",
							:target => "#{targetpath}#{event.name}"
							}
							@eventqueue << obj
							@logger.info "#{watcher.path}#{event.name} will proccessed as #{targetpath}#{event.name} with matching critera given for mapping(#{id})"
					end
				end
			end
		end
	end
end



class PhalithaListener < PhalithaEventMonitor
	def initialize
		@logger=Logger.new('PhalithaMonitor.log', 'daily',1)
		@eventqueue = Queue.new
		@job=PhalithaEventHandler.new(@eventqueue,@logger)
		@semaphore = Mutex.new
		super(@eventqueue,@logger)
	end
	def run
		@semaphore.synchronize do
			Thread.new do
				begin
					@logger.info "starting monitoring "
					super
				rescue
					@logger.error "unable to start monitor #{$!.message}"
					@logger.error $!.message
				end
			end
		end
		
		@semaphore.synchronize do
			Thread.new do
				begin
					@logger.info "starting job "
					@job.run
				rescue => err
					@logger.error "unable to start job #{err.message}"
					@logger.error err.backtrace
				end
			end
		end		
	end
end



require 'sinatra'
set :bind, '0.0.0.0'
set :port, 3001
set	:logging, true
set :database, "mysql2://#{DB_CONFIG['username']}:#{DB_CONFIG['password']}@#{DB_CONFIG['host']}:#{DB_CONFIG['port']}/#{DB_CONFIG['database']}"

listener=PhalithaListener.new
listener.run

Mapping.where("iswatching=1").each do |mapping|
	if File.exist?(mapping[:sourcefilepath]) and File.exist?(mapping[:targetfilepath])
		listener.watch(mapping[:id],mapping[:sourcefilepath],mapping[:targetfilepath],mapping[:sourcefilename])
	else
		puts "#{mapping[:targetfilepath]} not found" 
	end
end

get '/' do
	content_type :json
	{ :rc => 1, :key2 => "i m alive" }.to_json
end
get '/status' do
	@mappings=[]
	Mapping.where("iswatching=1").find_each do |mapping|
		m={
			:id => mapping[:id],
			:name => mapping[:name]
		}
		@mappings << m
	end
	content_type :json
	@mappings.to_json
end
get '/watch' do
  if params.has_key?"map"
	begin
		mapping=Mapping.find(params[:map])

		if File.exist?(mapping[:sourcefilepath]) and File.exist?(mapping[:targetfilepath])
			listener.watch(mapping[:id],mapping[:sourcefilepath],mapping[:sourcefilename])
			mapping.update_column(:iswatching,1)
			content_type :json
			{ :rc => 0, :key2 => 'is added' }.to_json
		else
			content_type :json
			{ :rc => 1, :key2 => 'error:: please validate mapping setup like source/target path/names ' }.to_json
		end
	rescue
		content_type :json
		{ :rc => 1, :key2 => 'error:: please validate mapping setup' }.to_json
	end
  else
	content_type :json
	{ :rc => 1, :key2 => 'error:: missing parameters' }.to_json
  end
end		

