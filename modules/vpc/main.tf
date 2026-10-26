#1 lay danh sach cac AZ dang hoat dong
data "aws_availability_zones" "available" {
  state = "available"
}

#2 khoi tao khung mang VPC tong
resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = "vpc-${var.env_name}"
    Environment = var.env_name
    ManagedBy   = "Terraform -Dat"
  }
}

#3 cong ket noi internet cho vung public

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "igw-${var.env_name}"
  }
}

#4 tao 2 pubilc subnets trai deu tren 2 AZ ( 1z, 1b)
resource "aws_subnet" "public" {
  count                   = 2
  vpc_id                  = aws_vpc.this.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, count.index + 1)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = false

  tags = {
    Name = "subnet-public-${var.env_name} - ${data.aws_availability_zones.available.names[count.index]}"
    Tier = "Public"
  }
}


#5 tao 2 private Subnets trai deu tren 2 az

resource "aws_subnet" "private" {
  count                   = 2
  vpc_id                  = aws_vpc.this.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, count.index + 11)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = false

  tags = {
    Name = "subnet-private-${var.env_name} - ${data.aws_availability_zones.available.names[count.index]}"
    Tier = "Private"
  }
}


#6 (option) tao Elastic IP va NAT Gateway neu enable_nat_gateway = true 
resource "aws_eip" "nat" {
  count  = var.enable_nat_gateway ? 1 : 0
  domain = "vpc"

  tags = {
    Name = "eip-nat-${var.env_name}"
  }

}

resource "aws_nat_gateway" "this" {
  count         = var.enable_nat_gateway ? 1 : 0
  allocation_id = aws_eip.nat[0].id
  subnet_id     = aws_subnet.public[0].id
  tags = {
    Name = "nat-${var.env_name}"

  }
  depends_on = [aws_internet_gateway.this]
}

#7 bang dinh tuyen Public di ra ngoai internet
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }
  tags = {
    Name = "rt-public-${var.env_name}"
  }

}
resource "aws_route_table_association" "public" {
  count          = 2
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

#8 bang dinh tuyen private

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "rt-private-${var.env_name}"
  }
}

#Neu bat Nat Gateway thi moi them dong dinh tuyen 0.0.0.0/0 qua NAt cho private
resource "aws_route" "private_nat" {
  count                  = var.enable_nat_gateway ? 1 : 0
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.this[0].id
}

resource "aws_route_table_association" "private" {
  count          = 2
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}

#S3 Gateway Endpoint mien phi 
resource "aws_vpc_endpoint" "s3" {
  vpc_id            = aws_vpc.this.id
  service_name      = "com.amazonaws.${var.aws_region}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = [aws_route_table.private.id]
  tags = {
    Name = "vpce-s3-${var.env_name}"
  }

}
