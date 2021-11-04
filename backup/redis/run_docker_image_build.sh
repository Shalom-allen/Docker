#! /bin/bash

# Create Docker for redis image.
echo -e "Please choose docker image name and tag name."
read dimage dtag
echo -e "Where is dockerfile location?"
read dlocate
docker build -t $dimage:$dtag $dlocate
