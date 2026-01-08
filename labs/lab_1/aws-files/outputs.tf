output "flarevm_ip" {
  description = "FlareVM IP"
  value       = var.enable_guacamole == false ? aws_instance.flarevm.public_ip : aws_instance.flarevm.private_ip
}

output "remnux_ip" {
  description = "REMnux IP"
  value       = var.enable_guacamole == false ? aws_instance.remnux.public_ip : aws_instance.remnux.private_ip
}

#output "guacamole_credentials" {
#  description = "Guacamole credentials"
#  value       = var.enable_guacamole == false ? null : data.external.guacamole_credentials[0].result
#}

output "flarevm_credentials" {
  description = "Default credentials for the FLARE-VM AMI. YOU SHOULD CHANGE THIS!!!"
  value = "Administrator:MalwareLab!2026"
}

output "remnux_credentials" {
  description = "Default credentials for the REMnux AMI. YOU SHOULD CHANGE THIS!!!"
  value = "student:REMnuxLab!2026"
}

output "guacamole_default_username" {
  description = "Default netCUBE Guacamole server username"
  value = "guacadmin" 
}

output "guacamole_instance_id" {
  description = "Guacamole EC2 instance ID"
  value       = var.enable_guacamole ? aws_instance.guacamole[0].id : null
}

output "guacamole_public_ip" {
  description = "Public IP of the Guacamole server"
  value       = var.enable_guacamole ? aws_instance.guacamole[0].public_ip : null
}