# Include AWS provider configuration

provider "aws" {
  region     = "us-east-1"
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

# Create VPC
resource "aws_vpc" "my_vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = "MyVPC"
  }
}

# Create Public Subnets
resource "aws_subnet" "public_subnets" {
  count             = length(var.public_subnet_cidr_blocks)
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = element(var.public_subnet_cidr_blocks, count.index)
  availability_zone = "us-east-1a"  # Replace with your preferred AZ
  tags = {
    Name = "PublicSubnet-${count.index + 1}"
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id
}

# Create Route Table and associate with Public Subnets
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw.id
  }

  tags = {
    Name = "PublicRouteTable"
  }
}

resource "aws_route_table_association" "public_subnet_associations" {
  count          = length(aws_subnet.public_subnets.*.id)
  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.public_route_table.id
}

# Create a Security Group (Modify as needed)
resource "aws_security_group" "nginx_sg" {
  name_prefix = "nginx-"
  vpc_id      = aws_vpc.my_vpc.id

  # Define inbound and outbound rules here
  # Example:
  # ingress {
  #   from_port   = 80
  #   to_port     = 80
  #   protocol    = "tcp"
  #   cidr_blocks = ["0.0.0.0/0"]
  # }
}

# Create an Elastic Load Balancer (ELB) (Modify as needed)
resource "aws_lb" "my_elb" {
  name               = "my-elb"
  internal           = false
  load_balancer_type = "application"
  subnets            = aws_subnet.public_subnets[*].id
  security_groups    = [aws_security_group.nginx_sg.id]
}

# Add Nginx Server Resources Here
resource "aws_instance" "nginx_server" {
  ami           = "ami-0c55b159cbfafe1f0"  # Replace with the desired Nginx AMI
  instance_type = "t2.micro"  # Replace with the desired instance type
  key_name      = "my-key-pair"  # Replace with your SSH key pair name
  subnet_id     = aws_subnet.public_subnets[0].id  # Use one of your public subnets

  user_data = <<-EOF
    #!/bin/bash
    # Install Nginx
    sudo apt-get update
    sudo apt-get install -y nginx

    # Start Nginx
    sudo systemctl start nginx

    # Enable Nginx to start on boot
    sudo systemctl enable nginx
    EOF

  tags = {
    Name = "NginxServer"
  }
}

# Output variables as needed
output "vpc_id" {
  value = aws_vpc.my_vpc.id
}

output "public_subnet_ids" {
  value = aws_subnet.public_subnets[*].id
}

