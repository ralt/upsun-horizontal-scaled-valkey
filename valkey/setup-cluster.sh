#!/bin/bash
set -e

rm -f /tmp/nodes.conf

echo "Setting up Valkey cluster from /run/peers.json..."

# Parse peers.json and create cluster
echo "Peers found:"
cat /run/peers.json

# Extract IPs and create cluster meet commands
# This will be executed after Valkey starts
jq -r 'to_entries[] | .value' /run/peers.json | while read ip; do
  echo "Will meet with node at $ip:6379"
done

# Save cluster formation commands for runtime
jq -r 'to_entries[] | .value + ":6379"' /run/peers.json > ~/.valkey/cluster_nodes.txt || true

echo "Cluster setup prepared"

# Form the cluster if this is the first node or if new nodes were added
echo "Forming/updating Valkey cluster..."

# Get all node addresses
NODES=$(cat .valkey/cluster_nodes.txt | tr '\n' ' ')

# Use valkey-cli to create cluster
# Note: This assumes automatic yes to prompts
./valkey/src/valkey-cli --cluster create $NODES \
  --cluster-replicas 0 \
  --cluster-yes || echo "Cluster already formed or nodes already part of a cluster"

echo "Cluster formation attempt completed"
