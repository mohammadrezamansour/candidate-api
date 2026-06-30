# Candidate API Infrastructure

This repository contains the Infrastructure as Code (IaC) and AWS Lambda implementation for a serverless Candidate API.

The infrastructure is provisioned with Terraform and deploys a secure serverless architecture on AWS.

## Architecture

The solution consists of:

- Amazon API Gateway (HTTP API)
- Amazon Cognito (OAuth2 Client Credentials)
- AWS Lambda
- Amazon DynamoDB
- Amazon S3
- IAM Roles and Policies

```
                   +----------------------+
                   |      Cognito         |
                   | OAuth2 / JWT Tokens  |
                   +----------+-----------+
                              |
                              |
                              v
+---------+         +-------------------+
| Client  |-------> |   API Gateway     |
+---------+         +---------+---------+
                              |
                              |
                              v
                     +-------------------+
                     |      Lambda       |
                     +----+---------+----+
                          |         |
                          |         |
                          v         v
                  +-----------+  +-----------+
                  | DynamoDB  |  |    S3     |
                  +-----------+  +-----------+
```

## Project Structure

```text
.
candidate-api/
├── README.md
└── terraform/
    ├── candidate_api/
    │   ├── iam.tf
    │   ├── lambda/
    │   ├── locals.tf
    │   ├── main.tf
    │   ├── outputs.tf
    │   ├── prod.tfvars
    │   ├── providers.tf
    │   ├── variables.tf
    │   └── versions.tf
    │
    └── modules/
        ├── api_gateway_lambda/
        ├── cognito/
        ├── dynamodb/
        ├── lambda/
        └── s3/

```

## Features

- Infrastructure managed with Terraform
- Modular Terraform design
- OAuth2 authentication using Amazon Cognito
- JWT validation in API Gateway
- Serverless Lambda backend
- Candidate metadata stored in DynamoDB
- Candidate resumes stored in S3
- Pre-signed URLs for secure resume downloads
- Least-privilege IAM permissions

## Security

The project implements several security best practices:

- OAuth2 Client Credentials authentication
- JWT Authorizer in API Gateway
- Least-privilege IAM policies
- Private S3 bucket
- Pre-signed URLs for resume downloads
- Input validation in Lambda
- Environment variables for resource configuration

## Deployment

Initialize Terraform:

```bash
terraform init
```

Review the execution plan:

```bash
terraform plan -var-file="prod.tfvars"
```

Deploy:

```bash
terraform apply -var-file="prod.tfvars"
```

Destroy the infrastructure:

```bash
terraform destroy -var-file="prod.tfvars"
```

## API

### Create Candidate

```
POST /candidate
```

Creates a candidate, uploads the resume to Amazon S3 and stores candidate metadata in DynamoDB.

### Get Candidate

```
GET /candidate/{id}
```

Returns candidate information and a pre-signed URL for downloading the resume.

## Authentication

The API is protected using Amazon Cognito.

Workflow:

1. Request an OAuth2 access token using the Client Credentials flow.
2. Include the access token in the Authorization header.

```
Authorization: Bearer <access_token>
```

## Lambda

The Lambda function:

- validates requests
- uploads resumes to S3
- stores metadata in DynamoDB
- generates pre-signed download URLs
- returns appropriate HTTP status codes

## Modules

Each Terraform module contains its own documentation generated with terraform-docs.

- api_gateway_lambda
- cognito
- lambda
- s3
- dynamodb

## Testing

The project was tested using Postman.

Verified scenarios:

- OAuth2 authentication
- Candidate creation
- Candidate retrieval
- S3 upload
- DynamoDB persistence
- Unauthorized requests
- Validation errors

## Author

MANSOUR Mohammadreza