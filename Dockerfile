# Stage 1: Build
FROM node:18-alpine AS builder
WORKDIR /app

# Install dependencies
COPY package*.json ./
RUN npm install

# Copy all files and build
COPY . .
RUN npm run build

# Stage 2: Production image
FROM node:18-alpine
WORKDIR /app

# Copy build files
COPY --from=builder /app/package*.json ./
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/public ./public

# Expose port and start app
EXPOSE 3000
CMD ["npm", "start"]
