############################################
# FLARE VM (private subnet)
############################################
resource "aws_instance" "flarevm" {
  ami           = var.flarevm_ami
  instance_type = "t3.large"

  network_interface {
    network_interface_id = aws_network_interface.flare_eni.id
    device_index         = 0
  }

  tags = {
    Name        = "${var.environment}-flarevm"
    Environment = var.environment
  }
}

############################################
# REMnux (private subnet)
############################################
resource "aws_instance" "remnux" {
  ami           = var.remnux_ami
  instance_type = "t3.large"

  network_interface {
    network_interface_id = aws_network_interface.remnux_eni.id
    device_index         = 0
  }

  tags = {
    Name        = "${var.environment}-remnux"
    Environment = var.environment
  }
}

############################################
# Guacamole (public subnet)
############################################
resource "aws_instance" "guacamole" {
  count         = var.enable_guacamole ? 1 : 0
  ami           = var.guacamole_ami
  instance_type = "t3.medium"

  network_interface {
    network_interface_id = aws_network_interface.guac_eni[0].id
    device_index         = 0
  }

  tags = {
    Name        = "${var.environment}-guacamole"
    Environment = var.environment
  }
}

############################################
# Optional wait (Guac image init time)
############################################
resource "time_sleep" "wait_5_min" {
  count           = var.enable_guacamole ? 1 : 0
  depends_on      = [aws_instance.guacamole]
  create_duration = "5m"
}
