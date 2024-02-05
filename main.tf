module "mytestvpc_project" {
  source = "./Modules/TestProject"
  mytest_region = var.mytest_region

mytest_vpc_cidr_block = var.mytest_vpc_cidr_block

mytest_vpc_tag=var.mytest_vpc_tag

mytest_public_subnet_cidr_block=var.mytest_public_subnet_cidr_block
mytest_public_subnet_availability_zone=var.mytest_public_subnet_availability_zone

mytest_private_subnet_cidr_block=var.mytest_private_subnet_cidr_block
mytest_private_subnet_availability_zone=var.mytest_private_subnet_availability_zone

mytest_public_sg_name=var.mytest_public_sg_name
mytest_private_sg_name = var.mytest_private_sg_name
mytest_igw_name=var.mytest_igw_name
mytest_project_allowed_ip=var.mytest_project_allowed_ip
mytest_public_routble_name=var.mytest_public_routble_name

mytest_private_routble_name=var.mytest_private_routble_name

mytest_public_instance_ami=var.mytest_public_instance_ami
mytest_public_instance_type=var.mytest_public_instance_type

mytest_private_instance_ami=var.mytest_private_instance_ami
mytest_private_instance_type=var.mytest_private_instance_type

mytest_instance_keyname=var.mytest_instance_keyname

mytest_public_instance_name= var.mytest_public_instance_name

mytest_private_instance_name=var.mytest_private_instance_name


}

