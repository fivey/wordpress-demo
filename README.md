# wordpress-demo

## Test/Production Environment Setup

The `terraform` directory contains configuration files to setup an ECS cluster and other resources needed to deploy this project to AWS.

## Deployment

`make deploy ENV=[target environment]`

### Environments

1. local
    - Deploys a local Wordpress server MySQL database (Requires Docker to be installed)
2. test
    - Deploys a test/sandbox Wordpress server to AWS ECS
3. prod
    - Deploys a production Wordpress server to AWS ECS