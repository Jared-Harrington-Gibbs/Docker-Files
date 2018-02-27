A headless wireshark instance that can be connected to via RDP.

It can be launched by running:
```
docker run -it --rm --network=host \                             
                    --cap-add net_raw \
                    --cap-add net_admin \
                    --name=wireshark \
                    jaredharringtongibbs/wireshark-rdp
```

When connecting via RDP chose:

```
session=sesman-any
ip=127.0.0.1
user=root
password=malware
```

All credit for the amazing password goes to the people who created Remnux ;)
