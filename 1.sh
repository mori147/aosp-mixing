docker compose run --rm toor

docker stop aosp-builder

docker compose up -d --build

newgrp docker
docker compose exec aosp bash