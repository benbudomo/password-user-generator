#!/bin/bash

# This script creates a new user on the local machine 
# You must supply a username as an argument to the script
# Optionally, you can also provide a comment for the account as an argument
# A password will be automatically generated for the account
# The username, password, and host for the account will be displayed

# Enforces root privileges 
if [[ "${UID}" -ne 0 ]]
then
    echo "Please run the script with root privileges."
    exit 1
fi

# Provide usage statement if user does not supply an account name
if [[ "${#}" -lt 1 ]]
then
    echo "Usage: ${0} USER_NAME [COMMENT]..."
    echo "Create an account on the local system with the name of USER_NAME and a comments field of COMMENT."
    exit 1
fi

# The first parameter is the user name
USER_NAME="${1}"

# The rest of the parameters are for the account comments
shift
COMMENT="${@}"

# Generate a password
PASSWORD=$(date +%s%N | sha256sum | head -c48)

# Create the user with the password
useradd -c "${COMMENT}" -m ${USER_NAME}

# Check to see if useradd command succeeded
if [[ "${?}" -ne 0 ]]
then 
    echo "Mission Failed."
    exit 1
fi

# Set the password for the user
echo ${PASSWORD} | passwd --stdin ${USER_NAME}

# Informs if the password was not created
if [[ "${?}" -ne 0 ]]
then
    echo "Mission Failed."
    exit 1
fi

# Force password change on first login
passwd -e ${USER_NAME}

# Displays username, password, and host
HOST_NAME=$(hostname)
echo
echo "Username: ${USER_NAME}"
echo
echo "Password: ${PASSWORD}"
echo
echo "Host: ${HOST_NAME}"

exit 0