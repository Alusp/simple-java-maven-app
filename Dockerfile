FROM nginx:alpine

COPY index.html /usr/share/nginx/html

COPY cicd.jpg /usr/share/nginx/html

EXPOSE 80