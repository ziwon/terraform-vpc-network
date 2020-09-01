data "aws_availability_zones" "available" {}

#################################################################################
# Shared VPC
#################################################################################
data "aws_vpc" "shared" {
  filter {
    name   = "tag:Name"
    values = [var.vpc_shared.name]
  }
}

data "aws_route_tables" "shared" {
  vpc_id = data.aws_vpc.shared.id

  filter {
    name   = "tag:Group"
    values = [var.vpc_shared.group_id]
  }
}


data "aws_route_tables" "shared_public" {
  vpc_id = data.aws_vpc.shared.id

  filter {
    name   = "tag:Type"
    values = ["public"]
  }
}

data "aws_route_tables" "shared_private" {
  vpc_id = data.aws_vpc.shared.id

  filter {
    name   = "tag:Type"
    values = ["private"]
  }
}

#################################################################################
# DEV VPC
#################################################################################
data "aws_vpc" "dev" {
  filter {
    name   = "tag:Name"
    values = [var.vpc_dev.name]
  }
}

data "aws_route_tables" "dev" {
  vpc_id = data.aws_vpc.dev.id

  filter {
    name   = "tag:Group"
    values = [var.vpc_dev.group_id]
  }
}

data "aws_route_table" "dev_public" {
  vpc_id = data.aws_vpc.dev.id

  filter {
    name   = "tag:Type"
    values = ["public"]
  }
}

data "aws_route_tables" "dev_private" {
  vpc_id = data.aws_vpc.dev.id

  filter {
    name   = "tag:Type"
    values = ["private"]
  }
}
