# AWS Production Grade VPC Infrastructure with Terraform

This repository contains Terraform configuration files to create a production-ready AWS Virtual Private Cloud (VPC) infrastructure with comprehensive networking components.

## 🏗️ Infrastructure Overview

This Terraform configuration deploys a highly available, secure AWS VPC infrastructure across multiple availability zones with the following components:

### Core Components
- **VPC**: Production-grade Virtual Private Cloud with DNS support
- **Subnets**: Both public and private subnets across multiple availability zones
- **NAT Gateways**: Internet connectivity for private subnets
- **Internet Gateway**: Direct internet access for public subnets
- **Route Tables**: Separate routing for public and private traffic
- **Security Groups**: Default security group with permissive rules
- **VPC Endpoints**: Gateway endpoints for S3 and DynamoDB services
- **Network ACLs**: Additional network-level security
- **Flow Logs**: VPC traffic monitoring and logging

## 📁 File Structure

```
.
├── main.tf          # Main infrastructure resources
├── variables.tf     # Input variables and defaults
├── outputs.tf       # Output values
└── providers.tf     # Terraform and AWS provider configuration
```

## 🚀 Quick Start

### Prerequisites
- [Terraform](https://www.terraform.io/downloads.html) >= 1.0
- AWS CLI configured with appropriate credentials
- AWS account with necessary permissions

### Deployment Steps

1. **Clone the repository**
   ```bash
   git clone https://github.com/manishpcp/aws-vpc-terraform.git
   cd aws-vpc-terraform
   ```

2. **Initialize Terraform**
   ```bash
   terraform init
   ```

3. **Review the plan**
   ```bash
   terraform plan
   ```

4. **Apply the configuration**
   ```bash
   terraform apply
   ```

5. **Verify deployment**
   ```bash
   terraform output
   ```

## ⚙️ Configuration Variables

| Variable | Description | Type | Default |
|----------|-------------|------|---------|
| `region` | AWS region for the VPC | string | `us-east-1` |
| `vpc_cidr` | CIDR block for the VPC | string | `10.0.0.0/16` |
| `public_subnets` | List of CIDR blocks for public subnets | list(string) | `["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]` |
| `private_subnets` | List of CIDR blocks for private subnets | list(string) | `["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]` |
| `availability_zones` | List of availability zones | list(string) | `["us-east-1a", "us-east-1b", "us-east-1c"]` |
| `tags` | Common tags for all resources | map(string) | See variables.tf |

### Customization Example

Create a `terraform.tfvars` file to customize your deployment:

```hcl
region = "us-west-2"
vpc_cidr = "10.1.0.0/16"
public_subnets = ["10.1.1.0/24", "10.1.2.0/24"]
private_subnets = ["10.1.10.0/24", "10.1.20.0/24"]
availability_zones = ["us-west-2a", "us-west-2b"]

tags = {
  Environment = "Staging"
  Project     = "MyApp"
  Owner       = "DevOps Team"
  ManagedBy   = "Terraform"
}
```

## 📤 Outputs

After successful deployment, the following outputs will be available:

| Output | Description |
|--------|-------------|
| `vpc_id` | ID of the created VPC |
| `public_subnets` | List of public subnet IDs |
| `private_subnets` | List of private subnet IDs |
| `nat_gateways` | List of NAT Gateway IDs |
| `internet_gateway` | Internet Gateway ID |
| `vpc_cidr` | CIDR block of the VPC |

## 🔧 Architecture Details

### Network Design
- **Public Subnets**: Host resources that need direct internet access (load balancers, bastion hosts)
- **Private Subnets**: Host internal resources (application servers, databases)
- **Multi-AZ Deployment**: Resources span multiple availability zones for high availability

### Security Features
- **Network ACLs**: Additional layer of security at the subnet level
- **Security Groups**: Instance-level firewall rules
- **Flow Logs**: Monitor and log VPC traffic for security analysis
- **VPC Endpoints**: Secure access to AWS services without internet routing

### Routing Configuration
- **Public Route Table**: Routes internet traffic through Internet Gateway
- **Private Route Tables**: Routes internet traffic through NAT Gateways (one per AZ)

## 🔒 Security Considerations

⚠️ **Important Security Notes:**

1. **Default Security Group**: The current configuration creates a security group with open rules (0.0.0.0/0). **Modify this before production use**.

2. **Network ACLs**: Review and customize the Network ACL rules based on your security requirements.

3. **Flow Logs**: Logs are retained for 30 days. Adjust retention period as needed.

### Recommended Security Enhancements

```hcl
# Example: More restrictive security group
resource "aws_security_group" "web" {
  name_prefix = "web-"
  vpc_id      = aws_vpc.main.id
  
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
```

## 💰 Cost Optimization

This infrastructure includes cost-optimized features:
- **NAT Gateways**: One per availability zone (consider NAT instances for development)
- **VPC Endpoints**: Reduce data transfer costs for S3 and DynamoDB access
- **Flow Logs**: 30-day retention to balance monitoring and costs

## 🔄 Management Commands

### View Current State
```bash
terraform show
terraform state list
```

### Update Infrastructure
```bash
terraform plan
terraform apply
```

### Destroy Infrastructure
```bash
terraform destroy
```

### Format Code
```bash
terraform fmt -recursive
```

### Validate Configuration
```bash
terraform validate
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Run `terraform fmt` and `terraform validate`
5. Submit a pull request

## 📋 Prerequisites Checklist

- [ ] AWS CLI installed and configured
- [ ] Terraform installed (version >= 1.0)
- [ ] AWS account with VPC creation permissions
- [ ] Understanding of AWS networking concepts
- [ ] Review of security group and NACL rules

## 🆘 Troubleshooting

### Common Issues

**Issue**: `Error creating VPC: UnauthorizedOperation`
**Solution**: Ensure your AWS credentials have VPC creation permissions

**Issue**: `Error creating NAT Gateway: InsufficientFreeAddressesInSubnet`
**Solution**: Ensure your public subnets have available IP addresses

**Issue**: `Error creating subnet: AvailabilityZoneNotAvailable`
**Solution**: Verify availability zones exist in your selected region

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 📞 Support

For issues and questions:
- Create an issue in this repository
- Check AWS documentation for service-specific questions
- Review Terraform documentation for configuration questions

***

**⚠️ Important**: Always review and test this configuration in a non-production environment before deploying to production. Customize security groups, NACLs, and other security settings according to your organization's requirements.


[2](https://ppl-ai-file-upload.s3.amazonaws.com/web/direct-files/attachments/81269357/4a7cb914-2f94-4868-83c4-1ee967fe739a/outputs.tf)
[3](https://ppl-ai-file-upload.s3.amazonaws.com/web/direct-files/attachments/81269357/6fd16736-eb1d-4265-9d29-c31b7dd27bcf/providers.tf)
[4](https://ppl-ai-file-upload.s3.amazonaws.com/web/direct-files/attachments/81269357/699c9224-6672-416c-9fd4-f3205b138692/variables.tf)
