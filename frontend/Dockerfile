# Stage 1: Build the Flutter application
FROM debian:latest AS build

# Install necessary dependencies
RUN apt-get update && apt-get install -y curl git unzip

# Install Flutter
RUN git clone https://github.com/flutter/flutter.git /flutter
ENV PATH="/flutter/bin:${PATH}"
RUN flutter doctor

# Set up the project
WORKDIR /app
COPY . .
RUN flutter pub get
RUN flutter build web --release

# Stage 2: Create a lightweight web server to serve the application
FROM nginx:alpine

# Copy the built files to the nginx server
COPY --from=build /app/build/web /usr/share/nginx/html

# Configure nginx to handle Flutter routes properly
RUN echo 'server { \
    listen 80; \
    location / { \
        root /usr/share/nginx/html; \
        index index.html index.htm; \
        try_files $uri $uri/ /index.html; \
    } \
}' > /etc/nginx/conf.d/default.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]