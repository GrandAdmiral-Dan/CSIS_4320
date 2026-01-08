############################################
# VPC
############################################
resource "aws_vpc" "lab_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = "${var.environment}-vpc"
    Environment = var.environment
  }
}

resource "aws_internet_gateway" "lab_igw" {
  vpc_id = aws_vpc.lab_vpc.id

  tags = {
    Name = "${var.environment}-igw"
  }
}

############################################
# Subnets
############################################
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.lab_vpc.id
  cidr_block              = "10.0.0.0/24"
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.environment}-public"
  }
}

resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.lab_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = var.availability_zone

  tags = {
    Name = "${var.environment}-private"
  }
}

############################################
# Route tables
############################################
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.lab_vpc.id
}

resource "aws_route" "public_default" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.lab_igw.id
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.lab_vpc.id
}

resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}

############################################
# Security Groups
############################################
resource "aws_security_group" "guacamole" {
  count  = var.enable_guacamole ? 1 : 0
  name   = "${var.environment}-guacamole"
  vpc_id = aws_vpc.lab_vpc.id

  ingress {
    description = "HTTPS to Guacamole"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Access to lab VPC"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.0.0.0/16"]
  }
}

resource "aws_security_group" "flarevm" {
  name   = "${var.environment}-flarevm"
  vpc_id = aws_vpc.lab_vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.0.0.0/16"]
  }
}

resource "aws_security_group_rule" "flare_rdp_from_guac" {
  count                    = var.enable_guacamole ? 1 : 0
  type                     = "ingress"
  from_port                = 3389
  to_port                  = 3389
  protocol                 = "tcp"
  security_group_id        = aws_security_group.flarevm.id
  source_security_group_id = aws_security_group.guacamole[0].id
}

resource "aws_security_group" "remnux" {
  name   = "${var.environment}-remnux"
  vpc_id = aws_vpc.lab_vpc.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.0.0.0/16"]
  }
}

############################################
# Network Interfaces (fixed private IPs)
############################################
resource "aws_network_interface" "guac_eni" {
  count           = var.enable_guacamole ? 1 : 0
  subnet_id       = aws_subnet.public.id
  private_ips     = ["10.0.0.5"]
  security_groups = [aws_security_group.guacamole[0].id]
}

resource "aws_network_interface" "flare_eni" {
  subnet_id       = aws_subnet.private.id
  private_ips     = ["10.0.1.4"]
  security_groups = [aws_security_group.flarevm.id]
}

resource "aws_network_interface" "remnux_eni" {
  subnet_id       = aws_subnet.private.id
  private_ips     = ["10.0.1.6"]
  security_groups = [aws_security_group.remnux.id]
}
