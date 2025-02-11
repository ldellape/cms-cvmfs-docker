#!/bin/bash

# Renew the Kerberos ticket.


echo "Running Kerberos renewal script at $(date)" 


kinit -R


if [ $? -eq 0 ]; then
    echo "Kerberos ticket renewed successfully at $(date)" 
else
    echo "Failed to renew Kerberos ticket at $(date)" 
fi

