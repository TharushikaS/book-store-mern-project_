# Step 1: Use official Node.js image as base image
FROM node:22.13.1

# Step 2: Set working directory inside the container
WORKDIR /app

# Step 3: Copy package.json and package-lock.json to leverage Docker caching for dependencies
COPY frontend/package.json frontend/package-lock.json ./

# Step 4: Install frontend dependencies
RUN npm install

# Step 5: Copy the rest of the frontend code into the container
COPY frontend /app

# Step 6: Build the frontend for production
RUN npm run build

# Step 7: Install a simple HTTP server to serve the static files
RUN npm install -g serve

# Step 8: Expose the port the frontend will run on (typically port 5000 for Vite)
EXPOSE 5000

# Step 9: Serve the built files using the 'serve' command
CMD ["serve", "-s", "dist", "-l", "5000"]
