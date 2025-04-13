dnf -y install amazon-efs-utils
mkdir -p /mnt/backend
echo "fs-0f25fb05ca800f50c:/ /mnt/backend efs _netdev,tls,iam 0 0" >> /etc/fstab
mount -a
ln -sf /mnt/backend/userapp /opt/userapp
chown -R ec2-user:ec2-user /mnt/backend

rm -rf /home/ec2-user/myapp/app.py