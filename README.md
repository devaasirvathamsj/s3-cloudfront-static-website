# Static Website Hosting on AWS with S3 and CloudFront (Terraform)

A production-style Infrastructure as Code project that provisions secure static website hosting on AWS. The architecture uses a fully private Amazon S3 bucket as the origin, served exclusively through Amazon CloudFront via Origin Access Control (OAC) — eliminating public bucket access while maintaining global content delivery through a CDN.

## Overview

This project was built to demonstrate a secure, real-world pattern for hosting static content on AWS: instead of making an S3 bucket public (a common anti-pattern), CloudFront is granted scoped access to a private bucket using Origin Access Control and an IAM resource policy restricted to a specific distribution.

## Architecture

```
                     +----------------------+
   User Request ---->|   CloudFront (CDN)   |
                     |  + Origin Access     |
                     |    Control (OAC)     |
                     +----------+-----------+
                                |
                                |  (signed requests only)
                                v
                     +----------------------+
                     |   S3 Bucket          |
                     |   (fully private)    |
                     |   - Versioning       |
                     |   - AES256 Encryption|
                     |   - Public Access    |
                     |     Blocked          |
                     +----------------------+
```

## Live Demo

![Website screenshot](screenshots/homepage.png)

Visit the deployed site: `https://dewc03nu0r7ju.cloudfront.net`

## Deployment Output

Terraform apply completed successfully, provisioning 10 resources and returning the CloudFront domain, bucket name, and distribution ID as outputs.

![Terraform apply output](screenshots/terraform-apply.png)

```
Apply complete! Resources: 10 added, 0 changed, 0 destroyed.

Outputs:

bucket_name             = "deva-devops-v3"
cloud_distribution_name = "E1P5YQBJ9KOZ6"
cloudfront_url           = "dewc03nu0r7ju.cloudfront.net"
```

## Key Features

- Private S3 bucket with all public access blocked at the bucket level
- CloudFront distribution using Origin Access Control (OAC) instead of legacy OAI
- IAM resource policy scoped to a single CloudFront distribution via a `SourceArn` condition (least privilege)
- S3 bucket versioning for object history and recovery
- Server-side encryption (AES256) applied to all stored objects
- Bucket ownership controls (`BucketOwnerEnforced`) in place of deprecated ACL-based access
- Modular Terraform configuration, separated by resource responsibility
- Terraform outputs exposing the CloudFront domain, bucket name, and distribution ID

## Project Structure

```
terraform-s3-cloudfront/
├── terraform-provider.tf              AWS provider configuration
├── terraform-variable.tf              Input variable definitions
├── terraform-s3-bucket.tf             S3 bucket, versioning, encryption, ownership controls, public access block
├── terraform-s3-bucket-object.tf      Uploads website assets (index.html, style.css) to S3
├── terraform-s3-policy.tf             IAM policy document restricting bucket access to CloudFront
├── terraform-cloudfront.tf            CloudFront distribution and Origin Access Control
├── terraform-output.tf                Terraform outputs
├── Website/
│   ├── index.html                     Website homepage
│   └── style.css                      Stylesheet
├── screenshots/
│   ├── homepage.png                   Live site screenshot
│   └── terraform-apply.png            Terraform apply output
└── README.md
```

## Prerequisites

- Terraform version 1.5 or later
- An AWS account with configured credentials (`aws configure` or environment variables)
- IAM permissions to create S3 buckets, CloudFront distributions, and IAM policies

## Configuration

Define the following variables in a `terraform.tfvars` file:

```hcl
bucket_name   = "your-unique-bucket-name"
bucket_region = "us-east-1"
```

Note: S3 bucket names must be globally unique across all AWS accounts.

## Usage

```bash
terraform init
terraform plan
terraform apply
```

Confirm with `yes` when prompted. CloudFront distributions typically take 10–15 minutes to fully deploy; this is expected AWS behavior.

## Outputs

| Output                     | Description                          |
|----------------------------|---------------------------------------|
| `cloudfront_url`           | Public CloudFront domain name         |
| `bucket_name`              | Name of the created S3 bucket         |
| `cloud_distribution_name`  | CloudFront distribution ID            |

## Security Design

- All public access is blocked at the bucket level (`block_public_acls`, `block_public_policy`, `ignore_public_acls`, `restrict_public_buckets` set to `true`).
- Access is granted exclusively to CloudFront through an IAM policy with a `SourceArn` condition tied to the specific distribution ARN, preventing access from any other CloudFront distribution or external caller.
- Bucket ownership is enforced via `BucketOwnerEnforced`, disabling ACLs in favor of policy-based access control, in line with current AWS guidance.

## Cleanup

```bash
terraform destroy
```

## Technologies Used

- Terraform (Infrastructure as Code)
- Amazon S3 (object storage / website origin)
- Amazon CloudFront (content delivery network)
- AWS IAM (access control policies)

## Author

Deva Asirvatham
