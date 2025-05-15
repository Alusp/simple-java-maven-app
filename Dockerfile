# FROM nginx:alpine
FROM stable-alpine3.21-slim

COPY index.html /usr/share/nginx/html

COPY cicd.jpg /usr/share/nginx/html

EXPOSE 80