FROM ubuntu
RUN apt-get update && apt-get install -y nginx
EXPOSE 80/tcp
ADD index.html /var/www/html
CMD ["nginx", "-g", "daemon off;"]
