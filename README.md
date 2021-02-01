# aws-terraform-poc
A proof-of-concept IaC project in AWS creating a simple VPC environment using terraform-managed infrastructure

### Base Requirements and Assumptions
Requirements:
* 1 VPC – 10.0.0.0/16
* 4 subnets (spread across two availability zones for high availability)
  * Sub1 – 10.0.0.0/24 (public, availability zone 1)
  * Sub2 – 10.0.1.0/24 (public, availability zone 2)
  * Sub3 – 10.0.2.0/24(private (intra), availability zone 1)
  * Sub4 – 10.0.3.0/24(private (intra), availability zone 2)
* 1 compute instance running RedHat in subnet sub1
  * 20 GB storage
  * t2.micro
* 1 compute instance running RedHat in subnet sub3
  * 20 GB storage
  * t2.micro
  * Apache (httpd) installed via scripting
* 1 alb that listens on port 80 and forwards traffic to the instance in sub sub3

### Architecture
![architecture](https://github.com/christian-stano/aws-terraform-poc/blob/develop/img/AWS%20Networking.png)

### Approach and Code Strategy
To build this proof of concept, I followed an iterative process outlined below to iteratively build and test each module:
1. Decompose the requirements into Terraform modules / architectural features
    * Module 1: Networks (VPC, subnets, internet gateway, routing tables)
    * Module 2: Instances (Sub1 and Sub3 EC2 instances, security groups)
    * Module 3: Application Load Balancer
2. Research implementation
    * AWS Terraform Modules: https://github.com/terraform-aws-modules 
    * HashiCorp Terraform Documentation: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/
3. Build
```
├── aws-terraform-poc
│   ├── modules
│       ├── vpc
│           ├── networks.tf
│           ├── variables.tf
│           ├── output.tf
│       ├── instances
│           ├── apache_install.sh
│           ├── public_subnet_instance.tf
│           ├── private_subnet_instance.tf
│           ├── security_groups.tf
│           ├── variables.tf
│           ├── outputs.tf
│       ├── loadbalancer
│           ├── alb.tf
│           ├── variables.tf
│   ├── main.tf
```
* Strategy Resource: https://aws.amazon.com/blogs/apn/terraform-beyond-the-basics-with-aws/
4. Test
  * Leverage terraform plan to validate infrastructure 
  * Spin up resources using terraform apply and visually inspect against requirements
5. Review for Improvements
  * Identify any errors
  * Review resources
  * Test features (i.e. can I SSH into sub1, does my SSH into sub3 get blocked, etc)

### Modules
#### VPC
Requirements Covered:
* 1 VPC – 10.0.0.0/16
* 4 subnets provisioned within the above VPC
  * Sub1 – 10.0.0.0/24 (public, availability zone 1)
  * Sub2 – 10.0.1.0/24 (public, availability zone 2)
  * Sub3 – 10.0.2.0/24(private (intra), availability zone 1)
  * Sub4 – 10.0.3.0/24(private (intra), availability zone 2)
  
Additions:
* Internet Gateway
  * Provides an interface between the internet and the public subnets within the VPC
* Route Tables for Sub1 and Sub2
  * Explicitly route all internet IP traffic to the underlying subents (available to the internet/public)
  * Note: this is not configured for Sub3 or Sub4 to ensure these stay private to the intranetwork
* Leveraging default ACL for DENY ALL 

Resources Used:
* VPC
  * https://github.com/terraform-aws-modules/terraform-aws-vpc
  * https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc
  * https://github.com/azavea/terraform-aws-vpc
  * https://github.com/aws-samples/apn-blog/tree/tf_blog_v1.0/terraform_demo/site
* Subnets
  * https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet
  * https://github.com/jetbrains-infra/terraform-aws-vpc-with-private-subnets-and-nat
* Route Table
  * https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table
  
#### Instances
Requirements Covered:
* 1 compute instance running RedHat in subnet sub1
  * 20 GB storage
  * t2.micro
* 1 compute instance running RedHat in subnet sub3
  * 20 GB storage
  * t2.micro
  * Apache (httpd) installed via scripting
  
Additions:
* Security Groups
  * To control the ingress and egress rules to each instance, I created 2 security groups, 1 for SSH access and 1 for HTTP access. For the sub1 EC2 instance, I supplied both security groups and leveraged the default network interface provided by AWS. For the sub3 EC2 instance, I only provided it the SSH security group to limit the number of possible connections and add an additional layer of security with the requirement of a public/private key pair. 

EC2 Instances:
* AMI: I perform a search of the AWS marketplace to pull the latest RHEL version for the instance
* Networking: I create one instance within the Sub1 public subnet inside the VPC, providing it with both security group rules for ingress and egress, and giving the instance a public IP address to expose it publicly. I created a second instance within the Sub3 private subnet inside the VPC and only provided it with SSH access.
* Storage: I provisioned a 20 GB root block device to meet the need for a 20 GB storage volume mount
* SSH Acccess: I was able to successfully SSH into the instance after manually creating a key pair via the AWS console. My research yielded that this pair needed to be user-provided, which is why I created via console: (https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair)
![screenshot](https://github.com/christian-stano/aws-terraform-poc/blob/develop/img/Sub1_EC2_SSH.png)
I was also able to confirm that the Sub3 instance was inaccessible via SSH from the internet
![screenshot](https://github.com/christian-stano/aws-terraform-poc/blob/develop/img/Sub3_EC2_SSH_Blocked.png)
* Apache Scripting: I leveraged an init script to install Apache (httpd) on RHEL that is run when the instance is provisioned

Resources:
  * https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ec2_instance_type
  * https://github.com/aws-samples/apn-blog/tree/tf_blog_v1.0/terraform_demo/instances
  * https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami
  * https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group
  * https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance
  * https://github.com/terraform-aws-modules/terraform-aws-security-group
  * https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet_ids
  * https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair
  * https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/volume_attachment
  
