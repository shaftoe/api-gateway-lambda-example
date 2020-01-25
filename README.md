# Serverless Python API scaffolding with AWS + Terraform

Example code used as showcase in [this tutorial][blogpost].

## TL;DL

All you need to deploy a simple Python REST API on AWS Lambda and API Gateway using Terraform.

```bash
clone https://github.com/shaftoe/api-gateway-lambda-example.git
cd api-gateway-lambda-example.git
# edit config.mk.example and save it as config.mk
make deploy
```

## Requirements

- an AWS account with administrator rights
- installed Terraform v.0.11.7 (or higher) with its AWS provider v1.27.0 (or higher)
- installed aws-cli v1.15.53 (or higher)

[blogpost]: https://a.l3x.in/2018/07/25/lambda-api-custom-domain-tutorial.html
