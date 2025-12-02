# --- Stage 1: Builder ---
# Use the current LTS version (replace 20 with the actual latest LTS if needed)
FROM node:20-alpine AS builder

# Set the working directory for the application
WORKDIR /app

# Copy package.json and package-lock.json first to leverage Docker layer caching
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application source code
COPY . .

# (Optional) If you have a build step (like transpiling TypeScript or frontend assets), uncomment this:
# RUN npm run build

# --- Stage 2: Production Runtime ---
# Use a minimal base image for the final runtime for the smallest size and better security
FROM node:20-alpine AS production

# Set the working directory
WORKDIR /app

# Copy only the necessary files from the builder stage
# This includes the node_modules and built/source files
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package*.json ./
COPY --from=builder /app/app.js ./

# Best practice: Run the app as the non-root 'node' user
USER node

# Expose the application port
EXPOSE 8000

# Define the command to run the application
CMD ["node", "app.js"]