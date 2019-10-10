#!/bin/bash
mknod /dev/fuse c 10 229
chmod a+w /dev/fuse
if [ -z "$CVMFS_MOUNTS" ]; then
    echo -ne "Mounting all filesystems in /etc/fstab ... "
    mount -a -F > /dev/null 2>&1
    echo -e "DONE"
else
    for MOUNT in ${CVMFS_MOUNTS[@]}; do
	echo -ne "Mounting the filesystem \"${MOUNT}\" ... "
	mount -F ${MOUNT} > /dev/null 2>&1
	echo -e "DONE"
    done
fi

# Set the default shell as bash for docker user.
chsh -s /bin/bash root

# restarts the xdm service
#/etc/init.d/xdm restart

# Create the directory needed to run the sshd daemon
#mkdir /var/run/sshd

# Start the ssh service
#/usr/sbin/sshd -D
