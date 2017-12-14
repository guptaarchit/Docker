#!/bin/bash
echo -e "Starting Xvfb on display ${DISPLAY} with res ${RES}" 
Xvfb ${DISPLAY} -ac -screen 0 ${RES} +extension RANDR &

echo "Start Web Server"
cd /robot_automation
python -m SimpleHTTPServer 80 &

echo "Setting up Python PATH"
PYTHONPATH=${PYTHONPATH}:/robot_automation/lib:/robot_automation/utils
echo $PYTHONPATH
export PYTHONPATH

/bin/bash
