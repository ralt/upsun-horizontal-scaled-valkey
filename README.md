# Test Autoshard Valkey

A test project for experimenting with horizontal scaling of Redis/Valkey on Upsun.

## Overview

This repository is designed to explore and test horizontal scaling capabilities for Redis-compatible databases (Valkey) on the Upsun platform. It provides an ephemeral cluster environment for testing distributed caching and data storage scenarios.

## Purpose

The primary goals of this project are to:

- Test horizontal scaling patterns for Redis/Valkey instances
- Experiment with cluster configuration and sharding strategies
- Explore Upsun's infrastructure capabilities for distributed databases

## Project Structure

This is an ephemeral test environment with the following characteristics:

- **Cluster Mode**: Configured for multi-node deployment
- **Ephemeral Storage**: Data does not persist between deployments
- **Clean State**: `nodes.conf` is cleaned on every node startup

## Getting Started

This project is configured to run on Upsun. The cluster configuration is automatically managed and nodes are provisioned according to the project settings.

### Prerequisites

- Upsun account and CLI tools
- Basic understanding of Redis/Valkey clustering

### Deployment

The project automatically configures the cluster on deployment. No manual intervention is required for basic testing scenarios.

## Testing

Use this environment to test various horizontal scaling scenarios:

- Read/write distribution across nodes
- Failover and replication behavior
- Performance benchmarks under load
- Cluster reconfiguration and rebalancing

## Notes

- This is a **test environment** - not intended for production use
- Data is ephemeral and will be lost between deployments
- Configuration is optimized for testing, not durability

## Contributing

This is a personal test project. Feel free to fork and adapt for your own experiments.

## License

This is test code - use at your own discretion.
