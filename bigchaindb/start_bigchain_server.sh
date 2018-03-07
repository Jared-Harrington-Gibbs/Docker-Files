sudo useradd -r --uid 999 mongodb

mkdir $HOME/bigchain
sudo rm $HOME/bigchain/* -rf
cd $HOME/bigchain

docker network create mynet

docker run --name=mongodb \
  --detach \
  --net mynet \
  --restart=always \
  --volume=$HOME/bigchain/mongodb_docker/db:/data/db \
  --volume=$HOME/bigchain/mongodb_docker/configdb:/data/configdb \
  mongo:3.4.9 --replSet=bigchain-rs

mongodbIP=$(docker inspect --format={{.NetworkSettings.Networks.mynet.IPAddress}} mongodb)

docker run --interactive \
  --rm \
  --tty \
  --net mynet \
  --volume $HOME/bigchain/bigchaindb_docker:/data \
  --env BIGCHAINDB_DATABASE_HOST=$mongodbIP bigchaindb/bigchaindb -y configure mongodb

docker run --name=bigchaindb \
  --detach \
  --net mynet \
  --publish=59984:9984 \
  --restart=always \
  --volume=$HOME/bigchain/bigchaindb_docker:/data \
  bigchaindb/bigchaindb start

