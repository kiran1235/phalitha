#!/bin/sh

cd "webui/"
echo "`date` : Starting Phalita Web Control Panel"
rails s -p 3000
echo "`date` : Stopped Phalita Web Control Panel"
exit 0