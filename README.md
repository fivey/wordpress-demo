# wordpress-demo

## Test/Production Environment Setup

The [terraform](/terraform) directory contains configuration files to setup an ECS cluster and other resources needed to deploy this project to AWS.

## Deployment

`make deploy ENV=[target environment]`

### Environments

1. local
    - Deploys a local Wordpress server and MySQL database with Docker
    - Server will be available at http://localhost:8080
    - Requires Docker to be installed prior to execution
2. test
    - Deploys a test/sandbox Wordpress server to AWS ECS
    - Will execute Terraform against your currently configured AWS account
    - Terraform will prompt for VPC, subnet, and security group IDs
3. prod
    - (Not Implemented) Deploys a production Wordpress server to AWS ECS