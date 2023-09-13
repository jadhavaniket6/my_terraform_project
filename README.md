# my_terraform_project
Creating a full infrastructure setup including a VPC, subnets, route table, Elastic Load Balancer (ELB), security group, and an Nginx server using Terraform
my_terraform_project/

├── main.tf

├── variables.tf

├── terraform.tfvars

└── credentials.tf


Initialize your Terraform workspace:
terraform init

Apply the Terraform configuration:
terraform apply

This code sets up a VPC with public subnets, an Internet Gateway, a route table, a security group, and an Elastic Load Balancer (ELB). You can add Nginx server resources and customize the security group rules according to your requirements. Make sure to replace "YOUR_ACCESS_KEY" and "YOUR_SECRET_KEY" in the terraform.tfvars file with your actual AWS access and secret keys.




