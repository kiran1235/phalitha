require 'eventmachine'
require 'rb-inotify'

notifier = INotify::Notifier.new
notifier.watch("/tmp/inbound/*.xml", :all_events) do  |event|
	watcher=event.notifier.watchers[event.watcher_id]
        puts "#{watcher.path}#{event.name} is created/modified "
end

EM.run do
  EM.watch notifier.to_io do	
     puts "event raised"
     notifier.run
  end
end

puts "process ended"
