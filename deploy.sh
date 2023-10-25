
docker build --tag podcaster .
docker run -p 127.0.0.1:8080:8080 podcaster

#docker attach <container id>