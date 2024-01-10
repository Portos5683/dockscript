wget https://interfaces.ace3i.com/bin/bin/mail-dev.tar.gz
docker load < mail-dev.tar.gz


cat <<EOF | sudo tee /app/service/ace3i-maildev.yml
version: '3'
services:
  ace3i-maildev:
    image: maildev/maildev
    ports:
      - 1080:1080
      - 1025:1025
    deploy:
      restart_policy:
        condition: on-failure
        delay: 5s
        max_attempts: 3
        window: 120s
EOF
docker swarm init
docker stack rm maildev
docker stack deploy -c /app/service/ace3i-maildev.yml maildev
docker service ls --filter name=maildev_ace3i-maildev 