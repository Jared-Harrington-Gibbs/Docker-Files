# Docker telnet server

This is a **_completely insecure_** docker made for testing purposes only!


## Commands
**Run locally**

`docker run -itd --name=telnetServer flemingcsi/telnet-server`

**Get it's ip address**

`docker inspect --format={{.NetworkSettings.IPAddress}} telnetServer`

**Make accessible to other computers** (not recommended)

`docker run -itd --name=telnetServer --network=host flemingcsi/telnet-server`
