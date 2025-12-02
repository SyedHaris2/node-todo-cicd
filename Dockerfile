# --- Stage 1: Builder ---
FROM node:20-alpine AS builder

# Set the working directory
WORKDIR /app

# 1. Copy package files first for caching
COPY package*.json ./

# 2. Install dependencies (Node dependencies are cached here)
RUN npm install

# 3. Copy only the root files and the views folder
# We only copy the necessary source files and the views folder.
COPY app.js ./
COPY views ./views

# --- Stage 2: Production Runtime ---
FROM node:20-alpine AS production

# Set the working directory
WORKDIR /app

# 4. Copy necessary runtime files from the builder stage
# A. Copy node_modules
COPY --from=builder /app/node_modules ./node_modules

# B. Copy main application files and the views folder
COPY --from=builder /app/app.js ./
COPY --from=builder /app/views ./views

# 5. Security: Run the app as the non-root 'node' user
USER node

# 6. Expose the application port
EXPOSE 8000

# 7. Define the command to run the application
CMD ["node", "app.js"]