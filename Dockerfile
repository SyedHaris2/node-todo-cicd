# --- Stage 1: Builder ---
FROM node:20-alpine AS builder

# Set working directory
WORKDIR /app

# Copy package files and install dependencies
COPY package*.json ./
RUN npm install

# Copy all source files (app.js, views, routes, public, etc.)
COPY . .

# --- Stage 2: Production ---
FROM node:20-alpine AS production

WORKDIR /app

# Copy node_modules from builder
COPY --from=builder /app/node_modules ./node_modules

# Copy all app files from builder
COPY --from=builder /app ./

# Run app as non-root
USER node

# Expose port
EXPOSE 8000

# Run the app
CMD ["node", "app.js"]
