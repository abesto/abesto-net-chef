# abesto-net-chef

The chef repository used to manage abesto.net via chef-solo.

# Getting started

1. Take a freshly baked Ubuntu server
2. Download bootstrap.sh and run it
3. Follow the directions

# Hosted applications

All HTTP requests are handled by HAProxy listening on port 80. The application servers listen only on the localhost interface; requests are routed to them based on the `HOST` HTTP header. The php5-fpm instance is shared.

* blog
 * host: abesto.net
 * server: nginx(8000) -> php5-fpm(9000)
* are-you-board
 * host: board.abesto.net
 * server: nodejs(8001)
* mastermind
 * host: mastermind.abesto.net
 * server: nginx(8002) without php, static
* algo
 * host: algo.abesto.net
 * server: nodejs(8003)
* ttrss
 * host: ttrss.abesto.net
 * server: nginx(8004) -> php5-fpm(9000)
```
