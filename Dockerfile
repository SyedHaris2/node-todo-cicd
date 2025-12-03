# --- Stage 1: Builder ---
FROM node:20-alpine AS builder

WORKDIR /app

# Install dependencies
COPY package*.json ./
RUN npm install

# Copy full project (app.js, views, routes, etc.)
COPY . .

# Force rebuild for EJS templates
RUN touch /app/views/*


# --- Stage 2: Production ---
FROM node:20-alpine AS production

WORKDIR /app

# Copy node_modules
COPY --from=builder /app/node_modules ./node_modules

# Copy application code
COPY --from=builder /app/app.js ./app.js
COPY --from=builder /app/views ./views

# Run as non-root user
USER node

EXPOSE 8000

CMD ["node", "app.js"]
