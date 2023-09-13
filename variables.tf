variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
}
variable "public_subnet_cidr_blocks" {
  type        = list(string)
  description = "CIDR blocks for public subnets"
}

