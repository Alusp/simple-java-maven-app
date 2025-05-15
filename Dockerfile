
FROM nginx:1.18.0

ADD index.html /app/
ADD cicd.jpg /app/

EXPOSE 8080
