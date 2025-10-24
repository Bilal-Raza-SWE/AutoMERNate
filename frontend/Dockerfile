# AutoMERNate Frontend Dockerfile
# Author: Muhammad Bilal Raza Attari
# Multi-stage build for optimized React production build

# Stage 1: Build Stage
FROM node:18-alpine AS builder

# Set working directory
WORKDIR /app/frontend

# Copy package files
COPY frontend/package*.json ./

# Install dependencies
RUN npm ci && npm cache clean --force

# Copy application source
COPY frontend/ ./

# Build the application
RUN npm run build

# Stage 2: Production Stage with Nginx
FROM nginx:1.25-alpine

# Copy custom nginx configuration
COPY frontend/nginx.conf /etc/nginx/conf.d/default.conf

# Copy built files from builder
COPY --from=builder /app/frontend/build /usr/share/nginx/html

# Set proper permissions (nginx user already exists in the base image)
RUN chown -R nginx:nginx /usr/share/nginx/html && \
    chown -R nginx:nginx /var/cache/nginx && \
    chown -R nginx:nginx /var/log/nginx && \
    chown -R nginx:nginx /etc/nginx/conf.d && \
    touch /var/run/nginx.pid && \
    chown -R nginx:nginx /var/run/nginx.pid

# Expose port 80
EXPOSE 80

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=10s --retries=3 \
  CMD wget --quiet --tries=1 --spider http://localhost/ || exit 1

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
