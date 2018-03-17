#!/bin/sh
# ./stop.sh

docker stop -t 1 gohugo
docker rm gohugo
