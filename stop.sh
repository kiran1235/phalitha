#!/bin/sh

kill -9 $phalitha_web_control_panel_pid
if $? -eq 0
	echo "Phalitha Web Control Panel is shutdown"
else
	echo "Phalitha Web Control Panel not able shutdown"
fi	
kill -9 $phalitha_monitor_pid
if $? -eq 0
	echo "Phalitha Monitor is shutdown"
else
	echo "Phalitha Monitor not able shutdown"
fi	
