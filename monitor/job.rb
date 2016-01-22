require 'resque'

module Job
  @queue = :default

  def self.perform(events)
		puts "hhhhh"
		events.each do	|id,event|
			puts "Processing Job file:(#{event})"
		end
  end
end