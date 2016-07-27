#!/bin/bash
mknod /dev/fuse c 10 229
chmod a+w /dev/fuse
mount -a
/usr/sbin/sshd -D
