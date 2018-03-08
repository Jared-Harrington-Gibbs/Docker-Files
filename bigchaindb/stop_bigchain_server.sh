docker kill $(docker ps -q)
docker container prune --force
rm $HOME/bigchain* -rf
sudo rm $HOME/bigchain* -rf
docker network rm bigchainnet
