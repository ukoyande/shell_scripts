#!/bin/bash

INSTANCE_IDS=""
STATUS=""

function display_usage {
    echo "Usage: $0 [OPTIONS]"
    echo "Options:"
    echo "  --start    Start EC2 Instance"
    echo "  --stop     Stop EC2 Instance"
    echo "  --list     List all EC2 Instances"
    echo "  --help     Display this help and exit."
}

function list_instance_id() {
    # Get all running instance IDs
    INSTANCE_IDS=$(aws ec2 describe-instances --query 'Reservations[*].Instances[*].InstanceId' --output text)
    echo "Retuned Instance IDs: $INSTANCE_IDS"
}

function check_instance_state() {

    STATUS=$(aws ec2 describe-instances --instance-ids $1 --query 'Reservations[*].Instances[*].State.Name' --output text)
    echo "$1 instance is $STATUS"

}

function stop_ec2_instance() {
    # Stop EC2 instance
    # Variables
    #INSTANCE_ID="i-xxxxxxxx"  # Replace with your instance ID
    list_instance_id
    check_instance_state $INSTANCE_IDS   
    if [[ $STATUS == "running" ]]; then
        aws ec2 start-instances --instance-ids $INSTANCE_IDS
        echo "Stopped EC2 Instance: $INSTANCE_IDS"
    else
        echo "ERROR: Instance is already running"
    fi

}

function start_ec2_instance() {
    list_instance_id
    check_instance_state $INSTANCE_IDS
    if [[ $STATUS == "stopped" ]]; then
        aws ec2 start-instances --instance-ids $INSTANCE_IDS
        echo "Started EC2 Instance: $INSTANCE_IDS"
    else
        echo "ERROR: Instance is already running"
    fi
}

function list_instance_id_by_tag_name() {
    # Get the instance ID by tag name
    INSTANCE_ID=$(aws ec2 describe-instances --filters "Name=tag:Name,Values=YourInstanceName" --query 'Reservations[*].Instances[*].InstanceId' --output text)
    echo "Instance ID: $INSTANCE_ID"

}


# Check if no arguments are provided or if the -h or --help option is given
if [ $# -eq 0 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    display_usage
    exit 0
fi

#command line argument parsing
while [ $# -gt 0 ]; do
    case "$1" in 
        --stop)
            stop_ec2_instance
            ;;
        --start)
            start_ec2_instance
            ;;
        --list)
            list_instance_id
            ;;                     
        *)
            echo "Error: Invalid option '$1'. Use '--help' to see available options."
            ;;
    esac
        shift
done
