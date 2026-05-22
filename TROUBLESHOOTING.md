# Troubleshooting & Debugging Notes

This document contains common issues faced while building the Terraform-based 3-tier AWS infrastructure project and the solutions implemented during debugging and deployment.

---

# 1. Module Directory Error

## Error
```text
Unreadable module directory
The system cannot find the file specified
```

## Cause
Terraform module path was incorrect or module folder did not exist.

## Solution
Created proper folder structure or removed incorrect module block temporarily.

## Command Used
```bash
terraform init
```

---

# 2. Reference to Undeclared Resource

## Error
```text
Reference to undeclared resource
```

## Cause
Used incorrect local reference:
```hcl
locals.cidr_block
```

## Solution
Changed to:
```hcl
local.cidr_block
```

---

# 3. Missing Resource Instance Key

## Error
```text
Missing resource instance key
```

## Cause
Used resources with `count` but referenced without index.

## Wrong
```hcl
aws_subnet.ntier_private.id
```

## Correct
```hcl
aws_subnet.ntier_private[count.index].id
```

---

# 4. Incorrect Route Block Syntax

## Error
```text
Incorrect attribute value type
```

## Cause
Incorrect route block syntax inside route table.

## Wrong
```hcl
route = {
}
```

## Correct
```hcl
route {
}
```

---

# 5. Invalid Key Pair Error

## Error
```text
InvalidKeyPair.NotFound
```

## Cause
Key pair did not exist in AWS.

## Solution
Created Terraform-managed key pair resource using:
```hcl
aws_key_pair
```

---

# 6. Free Tier Instance Type Error

## Error
```text
The specified instance type is not eligible for Free Tier
```

## Cause
Used unsupported EC2 instance type.

## Solution
Changed instance type to:
```hcl
instance_type = "t3.micro"
```

---

# 7. ALB Target Group Invalid Index Error

## Error
```text
Invalid index
```

## Cause
App instance count and target group attachment count were different.

## Solution
Matched both counts.

## Correct
```hcl
count = 1
```

---

# 8. Security Group Misconfiguration

## Problem
App servers were not accessible correctly.

## Cause
Incorrect security group references.

## Solution
Implemented proper SG segmentation:
- ALB → App
- Bastion → App
- App → DB

## Important Terraform Argument
```hcl
referenced_security_group_id
```

---

# 9. Bastion SSH Permission Denied

## Error
```text
Permission denied (publickey)
```

## Cause
Private SSH key not available inside Bastion.

## Solution
Copied private key to Bastion and fixed permissions.

## Commands Used
```bash
scp -i ~/.ssh/id_rsa ~/.ssh/id_rsa ubuntu@<BASTION_PUBLIC_IP>:~/.ssh/id_rsa
```

```bash
chmod 400 ~/.ssh/id_rsa
```

---

# 10. Unable to SSH into Private App Server

## Cause
Private EC2 instances had no public IP.

## Solution
Used Bastion Host architecture.

## SSH Flow
```text
Laptop → Bastion → Private App Server
```

## Command Used
```bash
ssh ubuntu@<APP_PRIVATE_IP>
```

---

# 11. MySQL Client Missing

## Problem
Could not connect to RDS from App Server.

## Solution
Installed MySQL client.

## Commands Used
```bash
sudo apt update
sudo apt install mysql-client -y
```

---

# 12. RDS Invalid Password Error

## Error
```text
MasterUserPassword is not a valid password
```

## Cause
Used unsupported special characters in password.

## Solution
Changed password to:
```text
StrongPass123
```

---

# 13. MySQL Unknown Host Error

## Error
```text
Unknown MySQL server host
```

## Cause
Used:
```text
hostname:3306
```
inside `-h`.

## Wrong Command
```bash
mysql -h endpoint:3306 -u admin -p
```

## Correct Command
```bash
mysql -h endpoint -u admin -p
```

---

# 14. Successfully Connected to RDS

## Command Used
```bash
mysql -h <RDS-ENDPOINT> -u admin -p
```

## Verified
- Private networking
- DB security groups
- App to DB communication
- Full 3-tier architecture

---

# 15. ALB Verification

## Verified
Application Load Balancer successfully distributed traffic to application servers.

## Tested Using
ALB DNS name in browser.

---

# 16. User Data Automation

## Implemented
Automated nginx installation during EC2 launch.

## Commands Used in user_data
```bash
apt update -y
apt install nginx -y
systemctl enable nginx
systemctl start nginx
```

---

# 17. Custom Application Page Deployment

## Added
Custom HTML page deployment through Terraform user_data.

## Command Used
```bash
echo "<h1>Terraform App Server</h1>" > /var/www/html/index.html
```

---

# 18. Security Improvements Implemented

## Improvements
- Restricted Bastion SSH access using `/32`
- Private application architecture
- Private RDS deployment
- SG-based communication

## Example
```hcl
cidr_ipv4 = "YOUR_PUBLIC_IP/32"
```

---

# 19. Cost Optimization Decisions

## Decisions
Disabled/commented:
- Detailed monitoring
- Deletion protection
- Backup retention

## Reason
AWS Free Tier cost optimization.

---

# 20. Final Architecture Successfully Built

## Final Working Architecture
```text
Internet
   ↓
ALB
   ↓
Private App Server
   ↓
RDS MySQL

Admin Flow:
Laptop
   ↓
Bastion
   ↓
Private App Server
```