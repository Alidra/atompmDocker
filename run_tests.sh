#!/bin/bash

#exit on errors
set -e

#run server
echo "Starting server..."
node httpwsd.js &
serverpid=$!
sleep 3

#check if server is dead
if ! kill -0 "$serverpid"; then
    wait $serverpid
    server_status=$?
    exit $server_status
fi

#run mt script
echo "Starting model transformation script..."
python3 mt/main.py &
mtpid=$!
sleep 3

#check if model transformer is dead
if ! kill -0 "$mtpid"; then
    wait $mtpid
    mt_status=$?
    exit $mt_status
fi

#echo "Starting Selenium server."
#java -jar "./node_modules/selenium-server/lib/runner/selenium-server-standalone-3.141.59.jar" &
#seleniumpid=$!
#sleep 3

#check if selenium server is dead
#if ! kill -0 "$seleniumpid"; then
#    wait seleniumpid
#    se_status=$?
 #   exit $se_status
#fi


echo "Starting tests..."
if [ "$#" -ge 1 ]
then
    if [ "$1" == "headless" ]
    then
        if [ -z "$2" ]
        then
            ./node_modules/nightwatch/bin/nightwatch -e run_headless
        else
            ./node_modules/nightwatch/bin/nightwatch -e run_headless $2
        fi
    else
        ./node_modules/nightwatch/bin/nightwatch $1
    fi
else
    ./node_modules/nightwatch/bin/nightwatch
fi


echo "Stopping server and mt script..."
kill "$serverpid"
kill "$mtpid"
#kill "$seleniumpid"



echo "Finished!"

