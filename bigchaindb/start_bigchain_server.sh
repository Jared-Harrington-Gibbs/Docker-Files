sudo useradd -r --uid 999 mongodb

if [ $? -eq 0 ]; then
    mkdir $HOME/bigchain && cd $HOME/bigchain
fi

if [ $? -eq 0 ]; then
    docker run --name=mongodb --detach --restart=always --volume=$HOME/bigchain/mongodb_docker/db:/data/db  --volume=$HOME/bigchain/mongodb_docker/configdb:/data/configdb mongo:3.4.9  --replSet=bigchain-rs
fi

if [ $? -eq 0 ]; then
    mongodbIP=$(docker inspect --format={{.NetworkSettings.IPAddress}} mongodb)
fi

if [ $? -eq 0 ]; then
    docker run --interactive --rm --tty --volume $HOME/bigchain/bigchaindb_docker:/data  --env BIGCHAINDB_DATABASE_HOST=$mongodbIP bigchaindb/bigchaindb -y configure mongodb
fi

if [ $? -eq 0 ]; then
    docker run --name=bigchaindb --detach --publish=59984:9984  --restart=always  --volume=$HOME/bigchain/bigchaindb_docker:/data bigchaindb/bigchaindb start
fi

