FROM node:18-alpine

WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy application files
COPY . .

# Expose service port
EXPOSE 5001

# Start the service
CMD ["node", "server.js"]
