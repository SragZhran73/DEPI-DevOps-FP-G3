# Use an official nginx image as a parent image
FROM nginx:alpine

# Copy the static files into the nginx html directory
COPY index.html /usr/share/nginx/html/
COPY hotel.html /usr/share/nginx/html/


# COPY hotel_info.html /usr/share/nginx/html/
# COPY styles.css /usr/share/nginx/html/
# COPY scripts.js /usr/share/nginx/html/


# Expose port 80
EXPOSE 80



# Start nginx when the container launches
CMD ["nginx", "-g", "daemon off;"]
