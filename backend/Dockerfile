# Step 1: Use official Node.js image as base image
FROM node:22.13.1

# Step 2: Set working directory inside the container
WORKDIR /app

# Step 3: Copy package.json and package-lock.json first (to leverage Docker cache for dependencies)
COPY backend/package.json backend/package-lock.json ./

# Step 4: Install backend dependencies
RUN npm install --production

# Step 5: Copy the rest of the backend code into the container
COPY backend /app

# Step 6: Expose the port your app runs on (example: port 3000)
EXPOSE 3000

# Step 7: Start the backend server (replace with your actual start command)
CMD ["npm", "start"]
