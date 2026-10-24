# --- Stage 1: Build the Solid application ---
FROM node:20-alpine AS builder

# Install pnpm globally
RUN corepack enable && corepack prepare pnpm@latest --activate

WORKDIR /app

# Copy dependency manifests
COPY package.json pnpm-lock.yaml* ./

# Install dependencies using pnpm
RUN pnpm install --frozen-lockfile

# Copy source code and build
COPY . .
RUN pnpm build

# --- Stage 2: Serve the app with Nginx ---
FROM nginx:alpine

# Copy built static assets from the builder stage to Nginx's public folder
COPY --from=builder /app/dist /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
