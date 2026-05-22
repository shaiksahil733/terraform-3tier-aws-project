# Production-Ready 3-Tier AWS Infrastructure using Terraform

## Project Overview

This project demonstrates a production-style 3-tier AWS infrastructure built using Terraform.

The infrastructure follows a secure and scalable cloud architecture using public and private subnets, load balancing, bastion access, and a private database layer.

The goal of this project is to automate infrastructure provisioning on AWS using Infrastructure as Code (IaC) principles.

---

# Architecture Diagram

```text
                    Internet
                        │
                        ▼
              Application Load Balancer
                        │
        ┌───────────────┴───────────────┐
        │                               │
        ▼                               ▼
   App Server 1                    App Server 2
   (Private EC2)                   (Private EC2)
        │                               │
        └───────────────┬───────────────┘
                        │
                        ▼
                    RDS MySQL
                  (Private DB)

Admin Access Flow:
Laptop → Bastion Host → Private App Servers
```

---

# AWS Services Used

- VPC
- Public & Private Subnets
- Internet Gateway
- NAT Gateway
- Route Tables
- Security Groups
- Bastion Host
- EC2 Instances
- Application Load Balancer (ALB)
- Target Groups
- RDS MySQL
- Elastic IP
- CloudWatch Monitoring (Documented)
- Terraform Variables & Outputs

---

# Features

- Production-style 3-tier architecture
- Multi-AZ deployment
- Public and private subnet separation
- Secure bastion-based SSH architecture
- Application Load Balancer for traffic distribution
- Private EC2 application servers
- Private RDS database deployment
- Security group segmentation
- Automated EC2 configuration using user_data
- Reusable Terraform variables and tfvars
- Dynamic AMI selection using Terraform data source
- Infrastructure outputs for easier access
- Cost-optimized setup for AWS Free Tier learning

---

# Project Structure

```text
terraform-aws-3tier/

├── datasource.tf
├── instance.tf
├── locals.tf
├── main.tf
├── outputs.tf
├── security_groups.tf
├── variables.tf
├── values.tfvars
├── .gitignore
├── README.md
```

---

# Security Architecture

## ALB Security Group
- Allows HTTP (80) and HTTPS (443) from the internet

## Bastion Security Group
- Allows SSH (22) only from trusted public IP

## App Security Group
- Allows HTTP (80) only from ALB
- Allows SSH (22) only from Bastion Host

## DB Security Group
- Allows MySQL (3306) only from App Servers

---

# Infrastructure Workflow

1. Internet traffic reaches the Application Load Balancer
2. ALB distributes traffic across private EC2 app servers
3. App servers communicate with private RDS database
4. Bastion Host provides secure SSH access to private servers
5. NAT Gateway allows outbound internet access for private instances

---

# EC2 User Data Automation

Nginx installation and configuration are automated using Terraform user_data scripts.

Each application server automatically creates a custom webpage during launch.

---

# Terraform Commands

## Initialize Terraform

```bash
terraform init
```

## Validate Configuration

```bash
terraform validate
```

## View Execution Plan

```bash
terraform plan
```

## Apply Infrastructure

```bash
terraform apply
```

## Destroy Infrastructure

```bash
terraform destroy
```

---

# Outputs

Terraform outputs include:

- ALB DNS Name
- Bastion Public IP
- App Server Private IPs
- RDS Endpoint

---

# Cost Optimization Notes

This project was designed for learning purposes using a Free Tier AWS account.

Some production-grade settings were documented but optionally disabled during testing to avoid unnecessary billing:

- Deletion Protection
- Detailed Monitoring
- Backup Retention

---

# Future Improvements

- Terraform Modules
- Auto Scaling Group
- HTTPS using ACM
- Route53 Domain Integration
- CI/CD Pipeline
- Remote Backend using S3 + DynamoDB
- Monitoring & Logging
- Docker/Kubernetes Deployment

---

# Skills Demonstrated

- AWS Networking
- Infrastructure as Code (IaC)
- Terraform
- Linux Administration
- Security Group Design
- Public/Private Architecture
- Load Balancing
- Cloud Infrastructure Automation
- Multi-Tier Architecture Design
## Troubleshooting & Debugging

Common Terraform, AWS, SSH, ALB, and RDS issues faced during development are documented in `TROUBLESHOOTING.md`.

---

# Author

Sahil Shaik
