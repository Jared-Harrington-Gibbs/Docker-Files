#create the mongodb user on linux
sudo useradd -r --uid 999 mongodb

#clean the bigchain storage directory
rm $HOME/bigchain/* -rf
sudo rm $HOME/bigchain/* -rf

#Create the bigchain network
docker network create bigchainnet

#Start the mongodb database
docker run --name=mongodb \
  --detach \
  --net bigchainnet \
  --restart=always \
  mongo:3.4.9 --replSet=bigchain-rs

#Get the mongodb ip address
mongodbIP=$(docker inspect --format={{.NetworkSettings.Networks.bigchainnet.IPAddress}} mongodb)

#Generate the bigchain config
docker run --interactive \
  --rm \
  --tty \
  --net bigchainnet \
  --volume $HOME/bigchain/bigchaindb_docker:/data \
  --env BIGCHAINDB_DATABASE_HOST=$mongodbIP bigchaindb/bigchaindb -y configure mongodb

#Start the bigchain container
docker run --name=bigchaindb \
  --detach \
  --net bigchainnet \
  --publish=59984:9984 \
  --restart=always \
  --volume=$HOME/bigchain/bigchaindb_docker:/data \
  bigchaindb/bigchaindb start

#start the bigchain client
docker run -i -t --rm --name=client --net bigchainnet jaredharringtongibbs/bigchaindb-client:latest
