#!/bin/sh
# ./run.sh

docker run -d -v /home:$HOME/blog/site -p 1313:1313 -e VIRTUAL_HOST="$1" --name gohugo gohugo
