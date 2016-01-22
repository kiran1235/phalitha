
require 'rubygems'
require 'eventmachine'

module PhalithaListener
	def post_init
		puts "-- someone connected to the echo server!"
	end
	def receive_data data
		send_data ">>> you sent: #{data}"		
	end
end


EventMachine::run {
    EventMachine::start_server "0.0.0.0", 8081, PhalithaListener
    puts 'running echo server on 8081'
}
