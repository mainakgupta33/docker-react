# Stage 1: Build the React application
FROM node:alpine as builder

WORKDIR '/app'

COPY package.json .
RUN npm install

COPY . .
RUN npm run build

# Stage 2: Serve the React application with Nginx
FROM nginx:stable-alpine
EXPOSE 80

# Remove default Nginx configuration (important to avoid conflicts)
RUN rm /etc/nginx/conf.d/default.conf

# Copy your custom Nginx configuration
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy the built React app to Nginx's serving directory
COPY --from=builder /app/build /usr/share/nginx/html

# Command to start Nginx in the foreground
CMD ["nginx", "-g", "daemon off;"]