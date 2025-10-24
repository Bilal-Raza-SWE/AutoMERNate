# AutoMERNate Backend Dockerfile
# Author: Muhammad Bilal Raza Attari
# Multi-stage build for production-ready Node.js backend

# Stage 1: Build Stage
FROM node:18-alpine AS builder

# Set working directory
WORKDIR /app

# Copy package files from root
COPY package*.json ./

# Install ALL dependencies (backend needs them)
RUN npm install && npm cache clean --force

# Stage 2: Production Stage
FROM node:18-alpine

# Set working directory
WORKDIR /app

# Create non-root user for security
RUN addgroup -g 1001 -S nodejs && \
    adduser -S nodejs -u 1001

# Copy dependencies from builder
COPY --from=builder --chown=nodejs:nodejs /app/node_modules ./node_modules

# Copy package.json
COPY --chown=nodejs:nodejs package*.json ./

# Copy backend application files
COPY --chown=nodejs:nodejs ./backend ./backend

# Create uploads directory
RUN mkdir -p uploads && chown -R nodejs:nodejs uploads

# Switch to non-root user
USER nodejs

# Expose port
EXPOSE 5000

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=40s --retries=3 \
  CMD node -e "require('http').get('http://localhost:5000/api/health', (r) => {process.exit(r.statusCode === 200 ? 0 : 1)})"

# Start the application
CMD ["node", "backend/server.js"]
