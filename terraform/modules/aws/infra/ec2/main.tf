resource "aws_instance" "main" {

  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = var.security_groups
  subnet_id              = var.subnet_id
  iam_instance_profile   = var.instance_profile
  monitoring             = var.monitoring
  user_data              = var.user_data
  root_block_device {
    volume_size           = var.windows_root_volume_size
    volume_type           = var.windows_root_volume_type
    delete_on_termination = true
    encrypted             = true
  }
  dynamic "ebs_block_device" {
    for_each = var.volumes_attached
    content {
      device_name           = ebs_block_device.value.device_name
      volume_size           = ebs_block_device.value.volume_size
      volume_type           = "gp3"
      encrypted             = true
      delete_on_termination = true
    }
  }
  /* ebs_block_device {
  //   device_name           = "xvdce"
  //   volume_size           = var.windows_data_volume_size
  //   volume_type           = var.windows_data_volume_type
  //   encrypted             = true
  //   delete_on_termination = true
  // }*/
  dynamic "network_interface" {
    for_each = var.nics
    content {
      network_interface_id = network_interface.value
      device_index         = index(var.nics, network_interface.value)
    }
  }

  tags = merge(
    {
      "Name" = format("%s", var.name)
    },
    var.tags,
  )

}


