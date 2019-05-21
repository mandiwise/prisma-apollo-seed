FROM node:10-alpine

# Get and set the environment variables
ARG NODE_ENV
ENV NODE_ENV $NODE_ENV
ENV NPM_CONFIG_PREFIX=/home/node/.npm-global
ENV PATH=$PATH:/home/node/.npm-global/bin

# Make directory for the application, owned by the node user
RUN mkdir -p /home/node/app/node_modules && chown -R node:node /home/node/app

# Change into the app directory
WORKDIR /home/node/app

# Switch to the node user
USER node

# Copy the package.json and package-lock.json files
COPY package*.json ./

# Copy the installation script
COPY --chown=node:node scripts/install-packages.sh install-packages.sh

# Install dependencies for development or production
RUN chmod u+x install-packages.sh && ./install-packages.sh ${NODE_ENV} && rm -f install-packages.sh

# Copy the all files and make the node user the owner
COPY --chown=node:node . .