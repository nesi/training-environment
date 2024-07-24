#!/bin/bash

# Echo the current date and time
echo "$(date)"
echo ""

CONFIG_FILE="vars/ondemand-config.yml.example"


echo "Enter the Git branch you should be on:"
read DESIRED_BRANCH
echo ""

# Check current branch
CURRENT_BRANCH=$(git branch --show-current)
if [ "$CURRENT_BRANCH" != "$DESIRED_BRANCH" ]; then
    echo "Error: You are on branch '$CURRENT_BRANCH'. Please switch to branch '$DESIRED_BRANCH' and rerun the script."
    exit 1
fi
echo "You are on the correct branch: $DESIRED_BRANCH"
echo ""

echo -e  "$(tput setaf 5)REMINDER:$(tput sgr0) Before we go ahead with updating the config files, we recommend doouble checking the $(tput setaf 2)/template$(tput sgr0) directory in your app\nand confirm all the files within it have exectauble permissions"
echo ""

echo "--- Let's start with updating vars/ondemand-config.yml.example ---"
echo ""

echo "Enter the number of Attendees/Users (num_users_create):"
read NUM_USERS_CREATE
echo ""

echo "Enter the number of Instructors/Helpers (num_trainers_create):"
read NUM_TRAINERS_CREATE
echo ""

#Provide options for control plane
while true; do
    echo "Choose the control plane flavour (control_plane_flavour):"
    echo "1) balanced1.2cpu4ram is for $(tput setaf 6)TESTING$(tput sgr0)"
    echo "2) balanced2.4cpu8ram is for $(tput setaf 3)PRODUCTION$(tput sgr0)"
    read -p "Enter the number corresponding to your choice (1 or 2): " CONTROL_PLANE_FLAVOR_CHOICE

    case $CONTROL_PLANE_FLAVOR_CHOICE in
        1)
            CONTROL_PLANE_FLAVOR="balanced1.2cpu4ram"
            break
            ;;
        2)
            CONTROL_PLANE_FLAVOR="balanced2.4cpu8ram"
            break
            ;;
        *)
            echo "Invalid choice, please choose again."
            ;;
    esac
done

echo ""

echo "Enter the number of cluster workers (cluster_worker_count):"
read CLUSTER_WORKER_COUNT
echo ""

# Provide options for worker_flavour
while true; do
    echo "Choose the worker flavour (worker_flavour):"
    echo "1) balanced1.8cpu16ram for $(tput setaf 6)TESTING$(tput sgr0)"
    echo "2) balanced1.32cpu64ram $(tput setaf 3)PRODUCTION$(tput sgr0)"
    read -p "Enter the number corresponding to your choice (1 or 2): " WORKER_FLAVOUR_CHOICE

    case $WORKER_FLAVOUR_CHOICE in
        1)
            WORKER_FLAVOUR="balanced1.8cpu16ram"
            break
            ;;
        2)
            WORKER_FLAVOUR="balanced1.32cpu64ram"
            break
            ;;
        *)
            echo "Invalid choice, please choose again."
            ;;
    esac
done

echo ""

echo "Enter the worker disk size (worker_disksize) - We recommend $(tput setaf 6)60$(tput sgr0):"
read WORKER_DISKSIZE
echo ""


# Print a summary of questions and their respective answers
echo "Number of Users : $(tput setaf 2)$NUM_USERS_CREATE$(tput sgr0)"
echo "Number of Trainers : $(tput setaf 2)$NUM_TRAINERS_CREATE$(tput sgr0)"
echo "Control Plane Flavour (control_plane_favour) : $(tput setaf 2)$CONTROL_PLANE_FLAVOR$(tput sgr0)"
echo "Cluster worker count (cluster_worker_count) : $(tput setaf 2)$CLUSTER_WORKER_COUNT$(tput sgr0)"
echo "Worker flavour (worker_flavour) : $(tput setaf 2)$WORKER_FLAVOUR$(tput sgr0)"
echo "Worker disk dize (worker_disksize) : $(tput setaf 2)$WORKER_DISKSIZE$(tput sgr0)"

echo ""

# Ask the user for confirmation
read -p "Are these values assigned to each attribute correct ? (y/n): " confirmation

if [[ $confirmation == "y" || $confirmation == "Y" ]]; then
    echo "Updating the requested attributes in vars/ondemand-config.yml.example"

    sed -i "s/^num_users_create: .*/num_users_create: $NUM_USERS_CREATE/" $CONFIG_FILE
    sed -i "s/^num_trainers_create: .*/num_trainers_create: $NUM_TRAINERS_CREATE/" $CONFIG_FILE
    sed -i "s/^control_plane_flavor: .*/control_plane_flavor: $CONTROL_PLANE_FLAVOR/" $CONFIG_FILE
    sed -i "s/^cluster_worker_count: .*/cluster_worker_count: $CLUSTER_WORKER_COUNT/" $CONFIG_FILE
    sed -i "s/^worker_flavour: .*/worker_flavour: $WORKER_FLAVOUR/" $CONFIG_FILE
    sed -i "s/^worker_disksize: .*/worker_disksize: $WORKER_DISKSIZE/" $CONFIG_FILE


    echo "vars/ondemand-config.yml.example updated successfully."
else 
    echo "Operation cancelled. ondemand-config.yml.example will not be updated."
fi

echo ""
echo "--- Now we can update terraform/terraform.tfvars file ---"
echo ""

TVFVARS_FILE="terraform/terraform.tfvars"


#Provide options for services_flavor_id
while true; do
    echo "Choose the Services Flavour ID (services_flavor_id):"
    echo "1) 4cpu8ram is for $(tput setaf 6)TESTING$(tput sgr0)"
    echo "2) 8cpu16ram is for usually for $(tput setaf 3)PRODUCTION$(tput sgr0), should be good for up to 45 users"
    echo "3) 16cpu32ram"

    read -p "Enter the number corresponding to your choice (1 or 2 or 3): " SERVICES_FLAVOUR_ID_CHOICE
 
    case $SERVICES_FLAVOUR_ID_CHOICE in
        1)
            SERVICES_FLAVOUR_ID="e07cfee1-43af-4bf6-baac-3bdf7c1b88f8"
            break
            ;;
        2)
            SERVICES_FLAVOUR_ID="2d02e6a4-3937-4ed3-951a-8e27867ff53e"
            break
            ;;
        3)
            SERVICES_FLAVOUR_ID="674fa81a-69c7-4bf7-b3a9-59989fb63618"
            break
            ;;
        *)
            echo "Invalid choice, please choose again."
            ;;
    esac
done

echo ""
echo "Enter the Services Volume Size (services_volume_size) - $(tput setaf 6)for example, if you have 20 users and expect to need 4 GB per user, then services_volume_size: 160 could be a safe choice :$(tput sgr0)"
read SERVICES_VOLUME_SIZE
echo ""


#Provide options for webnode_flavor_id
while true; do
    echo "Choose the Webnode Flavour ID (webnode_flavor_id):"
    echo "1) 4cpu8ram is for $(tput setaf 6)TESTING$(tput sgr0)"
    echo "2) 8cpu16ram is for usually for $(tput setaf 3)PRODUCTION$(tput sgr0), should be good for up to 45 users"
    echo "3) 16cpu32ram:"

    read -p "Enter the number corresponding to your choice (1 or 2 or 3): " WEBNODE_FLAVOUR_ID_CHOICE
 
    case $WEBNODE_FLAVOUR_ID_CHOICE in
        1)
            WEBNODE_FLAVOUR_ID="e07cfee1-43af-4bf6-baac-3bdf7c1b88f8"
            break
            ;;
        2)
            WEBNODE_FLAVOUR_ID="2d02e6a4-3937-4ed3-951a-8e27867ff53e"
            break
            ;;
        3)
            WEBNODE_FLAVOUR_ID="674fa81a-69c7-4bf7-b3a9-59989fb63618"
            break
            ;;
        *)
            echo "Invalid choice, please choose again."
            ;;
    esac
done

echo ""

echo "Enter the Webnode Volume Size (webnode_volume_size) - $(tput setaf 6) We recommend 30:$(tput sgr0)"
read WEBNODE_VOLUME_SIZE
echo ""


# Print a summary of questions and their respective answers
echo "Number of Users : $(tput setaf 2)$NUM_USERS_CREATE$(tput sgr0)"
echo "Number of Trainers : $(tput setaf 2)$NUM_TRAINERS_CREATE$(tput sgr0)"
echo "Control Plane Flavour (control_plane_favour) : $(tput setaf 2)$CONTROL_PLANE_FLAVOR$(tput sgr0)"
echo "Cluster worker count (cluster_worker_count) : $(tput setaf 2)$CLUSTER_WORKER_COUNT$(tput sgr0)"


# Ask the user for confirmation
read -p "Are these values assigned to each attribute correct ? (y/n): " confirmation

if [[ $confirmation == "y" || $confirmation == "Y" ]]; then
    echo "Updating the requested attributes in vars/ondemand-config.yml.example"

    sed -i "s/^services_flavor_id = .*/services_flavor_id = \"$SERVICES_FLAVOUR_ID\"/" $TVFVARS_FILE
    sed -i "s/^services_volume_size = .*/services_volume_size = $SERVICES_VOLUME_SIZE/" $TVFVARS_FILE
    sed -i "s/^webnode_flavor_id = .*/webnode_flavor_id = \"$WEBNODE_FLAVOUR_ID\"/" $TVFVARS_FILE
    sed -i "s/^webnode_volume_size = .*/webnode_volume_size = $WEBNODE_VOLUME_SIZE/" $TVFVARS_FILE

    echo "terraform/terraform.tfvars updated successfully."
else 
    echo "Operation cancelled. terraform/terraform.tfvars will not be updated."
fi

echo ""

# Ask the user for confirmation
read -p "Would you like to commit the changes to remote branch ? (y/n): " confirmation

if [[ $confirmation == "y" || $confirmation == "Y" ]]; then
 
    git add terraform/terraform.tfvars vars/ondemand-config.yml.example
    git commit -m "configuring environment for XXX workshop"
    git push -u origin $DESIRED_BRANCH
else 
    echo "Undestood. You will commit the changes later"
fi