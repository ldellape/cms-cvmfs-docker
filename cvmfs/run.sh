#!/bin/bash
mknod /dev/fuse c 10 229
chmod a+w /dev/fuse
mount -a

# Set the default shell as bash for docker user.
chsh -s /bin/bash root

# restarts the xdm service
/etc/init.d/xdm restart

# Create the directory needed to run the sshd daemon
mkdir /var/run/sshd

# Start the ssh service
/usr/sbin/sshd -D
