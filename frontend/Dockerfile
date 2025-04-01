# Build stage
FROM node:22-alpine as build

WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the frontend code
COPY . .

# Build the frontend application
RUN npm run build --verbose

# Production stage
FROM nginx:alpine

# Copy built assets from the build stage - using dist for Vite
COPY --from=build /app/dist /usr/share/nginx/html

# Copy nginx config if you have a custom one
# COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose port 80
EXPOSE 80

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
