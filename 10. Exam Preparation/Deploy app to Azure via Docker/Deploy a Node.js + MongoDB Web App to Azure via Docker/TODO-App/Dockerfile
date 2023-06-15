# Using Node.js image as base
FROM node:16

# Create the application directory in the container
WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install the dependencies
RUN npm install

# Copy the rest of the application files
COPY . .

# Copy the database connection files
COPY config/connection.js ./config/
COPY config/keyvault.js ./config/

# Define the storage location of the database data
VOLUME /data/db

# Port on which the application will run
EXPOSE 3000

# Command to start the application
CMD npm start