#!/bin/sh

NODE_ENV=${1} # Has to be all caps to match Docker Compose env variable

npm install --no-optional prisma -g

if [ "${NODE_ENV}" = "development" ]; then 
    npm install --no-optional nodemon -g
    npm install --no-optional && npm cache clean --force
else
    npm install --no-optional --only=production && npm cache clean --force
fi