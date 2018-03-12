# create an object class of BigchainDB
from bigchaindb_driver import BigchainDB

# Public and Private keypairs are generated for non-repudiation. 
# Transactions are signed with private key
# Public keys are to verify that the person in question truly did sign the transaction.
from bigchaindb_driver.crypto import generate_keypair

from time import sleep
from sys import exit

#generate keypairs for alice and bob
alice, bob = generate_keypair(), generate_keypair()


# Use YOUR BigchainDB Root URL here
bdb_root_url = 'http://bigchaindb:9984/'

# Our blockchain does not require authentication tokens  
bdb = BigchainDB(bdb_root_url)


# create digital asset payload {'data': {'data name': 'data value'}}
bicycle_asset = {
    'data': {
        'bicycle': {
            'serial_number': 'abcd1234',
            'manufacturer': 'bkfab'
        },
    },
}

# OPTIONAL - assign metadata to the asset
bicycle_asset_metadata = {
    'planet': 'earth'
}

#The asset belongs to Alice and will be transferred to Bob
prepared_creation_tx = bdb.transactions.prepare(
    operation='CREATE',
    signers=alice.public_key,
    asset=bicycle_asset,
    metadata=bicycle_asset_metadata
)

#The transaction will be fulfilled by signing it with Alice's private key
fulfilled_creation_tx = bdb.transactions.fulfill(
    prepared_creation_tx,
    private_keys=alice.private_key
)

#A record of the transaction is sent over a BigchainDB node
sent_creation_tx = bdb.transactions.send(fulfilled_creation_tx)

txid = fulfilled_creation_tx['id']

#code that checks the status of the transaction until it is successful
trials = 0
while trials < 60:
    try:
        if bdb.transactions.status(txid).get('status') == 'valid':
            print('Tx valid in:', trials, 'secs')
            break
    except bigchaindb_driver.exceptions.NotFoundError:
        trials += 1
        sleep(1)
if trials == 60:
    print('Tx is still being processed... Bye!')
    exit(0)

# Find the id of the created asset to be transferred
asset_id = txid
transfer_asset = {
    'id': asset_id
}

# Prepare the transfer transaction
output_index = 0
output = fulfilled_creation_tx['outputs'][output_index]
transfer_input = {
    'fulfillment': output['condition']['details'],
    'fulfills': {
        'output_index': output_index,
        'transaction_id': fulfilled_creation_tx['id']
    },
    'owners_before': output['public_keys']
}
prepared_transfer_tx = bdb.transactions.prepare(
    operation='TRANSFER',
    asset=transfer_asset,
    inputs=transfer_input,
    recipients=bob.public_key,
)

# Fulfill the transaction
fulfilled_transfer_tx = bdb.transactions.fulfill(
    prepared_transfer_tx,
    private_keys=alice.private_key,
)

#Send record of transaction to BigchainDB node
sent_transfer_tx = bdb.transactions.send(fulfilled_transfer_tx)

print("Is Bob the owner?",
    sent_transfer_tx['outputs'][0]['public_keys'][0] == bob.public_key)

print("Was Alice the previous owner?",
    fulfilled_transfer_tx['inputs'][0]['owners_before'][0] == alice.public_key)
