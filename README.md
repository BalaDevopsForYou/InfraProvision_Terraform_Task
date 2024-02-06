## OpenTofu AWS Infrastructure Deployment

This OpenTofu configuration deploys a scalable AWS infrastructure for your project, including VPC, subnets, security groups, instances, and more. It utilizes Vault for securely storing access and secret keys.

### Prerequisites

- OpenTofu installed locally ([Install OpenTofu](https://opentofu.io/getting-started))
- Vault installed and configured ([Install Vault](https://learn.hashicorp.com/tutorials/vault/getting-started-install))

### Setup

1. Clone this repository.
2. Navigate to the directory containing this code.
3. Run `opentofu init` to initialize OpenTofu and install necessary modules.
4. Ensure your Vault server is running and accessible.
5. Set up necessary secrets in your Vault server. In this configuration, secrets are expected to be stored under the path `secret/mysecret`, with keys `access_key` and `secret_key`.

### Configuration

#### Variables

- `mytest_region`: AWS region for deployment.
- `mytest_vpc_cidr_block`: CIDR block for the VPC.
- `mytest_vpc_tag`: Tag for the VPC.
- `mytest_public_subnet_cidr_block`: CIDR block for the public subnet.
- `mytest_public_subnet_availability_zone`: Availability zone for the public subnet.
- `mytest_private_subnet_cidr_block`: CIDR block for the private subnet.
- `mytest_private_subnet_availability_zone`: Availability zone for the private subnet.
- `mytest_public_sg_name`: Name for the public security group.
- `mytest_private_sg_name`: Name for the private security group.
- `mytest_igw_name`: Name for the internet gateway.
- `mytest_project_allowed_ip`: Allowed IP for project access.
- `mytest_public_routble_name`: Name for the public route table.
- `mytest_private_routble_name`: Name for the private route table.
- `mytest_public_instance_ami`: AMI ID for the public instance.
- `mytest_public_instance_type`: Instance type for the public instance.
- `mytest_private_instance_ami`: AMI ID for the private instance.
- `mytest_private_instance_type`: Instance type for the private instance.
- `mytest_instance_keyname`: Name for the SSH key pair.
- `mytest_public_instance_name`: Name for the public instance.
- `mytest_private_instance_name`: Name for the private instance.

#### Modules

- `mytestvpc_project`: Custom module for VPC setup.

#### Resources

- `aws_vpc`: VPC configuration.
- `aws_subnet`: Subnet configurations for both public and private.
- `aws_security_group`: Security group configurations for both public and private.
- `aws_internet_gateway`: Internet gateway configuration.
- `aws_route_table`: Route table configurations for both public and private.
- `aws_route_table_association`: Associations between subnets and route tables.
- `aws_nat_gateway`: NAT gateway configuration.
- `aws_instance`: Instance configurations for both public and private.

#### Vault Integration

Vault is used to securely manage access and secret keys required for AWS provider authentication. Ensure your Vault server is set up and secrets are stored at `secret/mysecret` with appropriate keys.

### Usage

1. Update the variables in `terraform.tfvars` to match your requirements.
2. Run `opentofu apply` to create the infrastructure, passing the `terraform.tfvars` file to dynamically assign values.

```bash
opentofu apply -var-file=terraform.tfvars


### Access

Once deployed, you can access your instances using SSH or other appropriate means. Security groups are configured to restrict access based on the specified allowed IP.

### Cleanup

To tear down the infrastructure, run `opentofu destroy`. Ensure you no longer need the resources before executing this command.

### Note

This configuration initially utilizes a local backend to store the `terraform.tfstate` file. For production or collaborative environments, it's recommended to switch to a remote backend. You can configure an S3 bucket for storing the `.tfstate` file and use DynamoDB for state locking to prevent concurrent modifications.

To switch to a remote backend with OpenTofu:

1. Configure an S3 bucket and DynamoDB table in your AWS account.
2. Update the backend configuration in your OpenTofu code to point to the S3 bucket and DynamoDB table.
3. Run `opentofu init` again to initialize OpenTofu with the new backend configuration.
4. Ensure appropriate IAM permissions are set for OpenTofu to access the S3 bucket and DynamoDB table.

Example backend configuration:

```hcl
backend "s3" {
  bucket         = "your-tf-state-bucket"
  key            = "terraform.tfstate"
  region         = "your-aws-region"
  dynamodb_table = "your-dynamodb-lock-table"
}



### Disclaimer

Please review the OpenTofu configuration and ensure it aligns with your security and compliance requirements before deployment.

### Author

This OpenTofu configuration was authored by Bala Krishna Nuthi
