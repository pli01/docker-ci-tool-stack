#!/bin/bash
# Client Env Vars
set -e

if [ "$1" = 'service-config' ]; then

        echo "******* PROCESSING POST CONFIGURATION *********"
        echo "******* STARTING CONFIGURE *********"
        # command line to start process
        # if process is launched with a start service don't forget to tail it
 	bash /opt/run.sh
        sleep infinity
        #while :; do echo 'Hit CTRL+C'; sleep 1; done
else
        exec "$@"
fi

