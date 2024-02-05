variable "mytest_region" {
  type = string
}
variable "mytest_vpc_cidr_block" {
  type = string
}

variable "mytest_vpc_tag" {
  type = string
}

variable "mytest_public_subnet_cidr_block" {
  type = string
}
variable "mytest_public_subnet_availability_zone" {
  type = string
}

variable "mytest_private_subnet_cidr_block" {
  type = string
}
variable "mytest_private_subnet_availability_zone" {
  type = string
}

# List of ports to allow
variable "allowed_ports" {
  default = [22, 80]  # Add more ports as needed
}

variable "mytest_project_allowed_ip" {
  type = string
}


variable "mytest_public_sg_name" {
  type = string
}
variable "mytest_private_sg_name" {
  type = string
}

variable "mytest_igw_name" {
  type = string
}
variable "mytest_public_routble_name" {
  type = string
}

variable "mytest_private_routble_name" {
  type = string
}

variable "mytest_public_instance_ami" {
  type = string
}
variable "mytest_public_instance_type" {
  type = string
}

variable "mytest_private_instance_ami" {
  type = string
}
variable "mytest_private_instance_type" {
  type = string
}

variable "mytest_instance_keyname" {
  type = string
}
variable "mytest_public_instance_name" {
  type = string
}

variable "mytest_private_instance_name" {
  type = string
}

