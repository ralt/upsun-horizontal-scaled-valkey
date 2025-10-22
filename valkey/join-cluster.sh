#!/usr/bin/env python3

import json
import socket

with open("/run/peers.json") as peers_f:
    peers = json.load(peers_f)

my_ip = socket.gethostbyname(socket.gethostname())

for node, ip in peers.items():
    if ip == my_ip:
        continue
    subprocess.check_call(["./valkey/src/valkey-cli", "--cluster", "add-node", "0.0.0.0:6379", f"{ip}:6379"])
    break
