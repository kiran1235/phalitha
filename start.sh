#!/bin/sh

crpath="`pwd`"
filename="log/phalitha_web_log_`date "+%y_%m_%d_%H_%M_%S"`.log"
echo "`date` : Starting Phalita Monitoring Engine"
#staring monitor
cd "monitor/"
`nohup ruby monitor.rb >> $filename  2>&1 &`


cd $crpath
#start phalitha control pannel
cd "webui/"
echo "`date` : Starting Phalita Web Control Panel"
rails s -p 3000 -d

