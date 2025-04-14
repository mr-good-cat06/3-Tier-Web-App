resource "aws_efs_file_system" "filesystem" {
    creation_token = "${var.project_name}-efs"
  
}

resource "aws_efs_mount_target" "fs_mount" {
    count = length(var.backend_subnet)
    file_system_id = aws_efs_file_system.filesystem.id
    subnet_id      = var.backend_subnet[count.index]
    security_groups = [ var.efs_sg ]
    
}