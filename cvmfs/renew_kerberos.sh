#!/bin/bash

# Renew the Kerberos ticket.


echo "Running Kerberos renewal script at $(date)" >> /var/log/kerberos_renewal.log


kinit -R >> /var/log/kerberos_renewal.log 2>&1


if [ $? -eq 0 ]; then
    echo "Kerberos ticket renewed successfully at $(date)" >> /var/log/kerberos_renewal.log
else
    echo "Failed to renew Kerberos ticket at $(date)" >> /var/log/kerberos_renewal.log
fi

