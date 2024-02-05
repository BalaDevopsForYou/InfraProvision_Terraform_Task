#vpc configuration
resource "aws_vpc" "mytest_vpc" {
  cidr_block = var.mytest_vpc_cidr_block

  tags = {
    Name = var.mytest_vpc_tag
  }
}

#public subnet configuration
resource "aws_subnet" "mytest_public_subnet" {
  vpc_id                  = aws_vpc.mytest_vpc.id
  cidr_block              = var.mytest_public_subnet_cidr_block
  availability_zone       = var.mytest_public_subnet_availability_zone
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet"
  }
}

#private subnet configuration
resource "aws_subnet" "mytest_private_subnet" {
  vpc_id                  = aws_vpc.mytest_vpc.id
  cidr_block              = var.mytest_private_subnet_cidr_block
  availability_zone       = var.mytest_private_subnet_availability_zone

  tags = {
    Name = "private-subnet"
  }
}

#public security group
resource "aws_security_group" "mytest_public_sg" {
  vpc_id = aws_vpc.mytest_vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.mytest_public_sg_name
  }
}

#internet gateway
resource "aws_internet_gateway" "mytest_igw" {
 vpc_id =  aws_vpc.mytest_vpc.id
 tags = {
   Name = var.mytest_igw_name
 }
}

resource "aws_route_table" "mytest_public_route_table" {
  vpc_id = aws_vpc.mytest_vpc.id
    
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.mytest_igw.id
  }
  tags = {
    Name = var.mytest_public_routble_name
  }
}

resource "aws_route_table_association" "mytest_rtb-public_subnet_assctn" {
    subnet_id = aws_subnet.mytest_public_subnet.id
    route_table_id = aws_route_table.mytest_public_route_table.id
}

#private security group
resource "aws_security_group" "mytest_private_sg" {
  vpc_id = aws_vpc.mytest_vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    security_groups  = [aws_security_group.mytest_public_sg.id]
  }
  tags = {
    Name = var.mytest_private_sg_name
  }
}

resource "aws_eip" "mytest_eip" {
  depends_on = [ aws_internet_gateway.mytest_igw ]
}

resource "aws_nat_gateway" "mytest_natgateway" {
  allocation_id = aws_eip.mytest_eip.id
  subnet_id = aws_subnet.mytest_public_subnet.id

  tags = {
    Name = "nategateway"
  }
}

#private route tables
resource "aws_route_table" "mytest_private_route_table" {
  vpc_id = aws_vpc.mytest_vpc.id
    
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.mytest_natgateway.id
  }
  tags = {
    Name = var.mytest_private_routble_name
  }
}

#private subnet association with private route table
resource "aws_route_table_association" "mytest_rtb-private_subnet_assctn" {
    subnet_id = aws_subnet.mytest_private_subnet.id
    route_table_id = aws_route_table.mytest_private_route_table.id
}

# Generate SSH key pair
resource "tls_private_key" "mytest_ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
resource "local_file" "private_key" {
  content  = tls_private_key.mytest_ssh_key.private_key_pem
  filename = "mytest_key"
}

# Upload public key to AWS
resource "aws_key_pair" "mytest_key_pair" {
  key_name   = var.mytest_instance_keyname
  public_key = tls_private_key.mytest_ssh_key.public_key_openssh
}


#public instance
resource "aws_instance" "mytest_public_instance" {
  ami             = var.mytest_public_instance_ami
  instance_type   = var.mytest_public_instance_type
  subnet_id       = aws_subnet.mytest_public_subnet.id
  key_name        = aws_key_pair.mytest_key_pair.key_name
  vpc_security_group_ids  = [aws_security_group.mytest_public_sg.id]
  associate_public_ip_address = true
  tags = {
    Name = var.mytest_public_instance_name
  }
}
# Local variable to generate security group rules
locals {
  dynamic_rules = flatten([
    for port in var.allowed_ports : [
      {
        from_port   = port
        to_port     = port
        protocol    = "tcp"
        cidr_blocks = ["${var.mytest_project_allowed_ip}/32"]
      }
    ]
  ])
  }

# Security group rules for dynamic ports
resource "aws_security_group_rule" "mytest_public_sg_dynamic_rules" {
  security_group_id = aws_security_group.mytest_public_sg.id
  type              = "ingress"

  count = length(local.dynamic_rules)

  from_port   = local.dynamic_rules[count.index].from_port
  to_port     = local.dynamic_rules[count.index].to_port
  protocol    = local.dynamic_rules[count.index].protocol
  cidr_blocks = local.dynamic_rules[count.index].cidr_blocks
}



#private instance
resource "aws_instance" "mytest_private_instance" {
  ami             = var.mytest_private_instance_ami
  instance_type   = var.mytest_private_instance_type
  subnet_id       = aws_subnet.mytest_private_subnet.id
  key_name        =  aws_key_pair.mytest_key_pair.key_name
  vpc_security_group_ids  = [aws_security_group.mytest_private_sg.id]

  tags = {
    Name = var.mytest_private_instance_name
  }
}
