#!/bin/bash
# Show number of HTTP sessions running

while true
do
    date; ps -ef | grep http | wc -l
    sleep 5
done
