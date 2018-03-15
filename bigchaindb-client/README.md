Bigchaindb Client


**To launch the client: **
> `docker run -i -t --rm --name=client --net bigchainnet jaredharringtongibbs/bigchaindb-client:latest`

The bigchaindb client is the user front-end to the blockchain managed via mongodb

In order to create, transfer or query transactions over the blockchain, a python script must be edited and run via the command line.

An example python script has been copied from the official bigchaindb site, for the creation and transfer of a digital asset (bicycle):

> `python3 /scripts/bigchain_transaction.py`

After generating assets / transactions, the blockchain can be queried for strings:

> `http://<YOUR DOCKER MACHINE IP>:59984/api/v1/assets?search="bkfab"`

For examples and further instructions, refer to official documentation here:

https://docs.bigchaindb.com/projects/py-driver/en/latest/usage.html#digital-asset-definition
