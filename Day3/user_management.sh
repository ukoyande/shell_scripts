## Challenge: User Account Management
: ' 
In this challenge, you will create a bash script that provides options for managing user accounts on the system. The script should allow users to perform various user account-related tasks based on command-line arguments.

### Part 1: Account Creation

1. Implement an option `-c` or `--create` that allows the script to create a new user account. The script should prompt the user to enter the new username and password.

2. Ensure that the script checks whether the username is available before creating the account. If the username already exists, display an appropriate message and exit gracefully.

3. After creating the account, display a success message with the newly created username.

### Part 2: Account Deletion

1. Implement an option `-d` or `--delete` that allows the script to delete an existing user account. The script should prompt the user to enter the username of the account to be deleted.

2. Ensure that the script checks whether the username exists before attempting to delete the account. If the username does not exist, display an appropriate message and exit gracefully.

3. After successfully deleting the account, display a confirmation message with the deleted username.

### Part 3: Password Reset

1. Implement an option `-r` or `--reset` that allows the script to reset the password of an existing user account. The script should prompt the user to enter the username and the new password.

2. Ensure that the script checks whether the username exists before attempting to reset the password. If the username does not exist, display an appropriate message and exit gracefully.

3. After resetting the password, display a success message with the username and the updated password.

### Part 4: List User Accounts

1. Implement an option `-l` or `--list` that allows the script to list all user accounts on the system. The script should display the usernames and their corresponding user IDs (UID).

### Part 5: Help and Usage Information

1. Implement an option `-h` or `--help` that displays usage information and the available command-line options for the script.

### Bonus Points (Optional)

If you want to challenge yourself further, you can add additional features to the script, such as:

- Displaying more detailed information about user accounts (e.g., home directory, shell, etc.).
- Allowing the modification of user account properties (e.g., username, user ID, etc.).

Remember to handle errors gracefully, provide appropriate user prompts, and add comments to explain the logic and purpose of each part of the script.

## [Example Interaction: User Account Management Script](./example_interaction_with_usr_acc_mgmt.md)


## Submission Instructions
Create a bash script named `user_management.sh` that implements the User Account Management as described in the challenge.
Add comments in the script to explain the purpose and logic of each part.
Submit your entry by pushing the script to your GitHub repository.
Good luck with the User Account Management challenge! This challenge will test your ability to interact with user input, manage user accounts, and perform administrative tasks using bash scripting. Happy scripting and managing user accounts!
'

function display_usage {
    echo "Usage: $0 [OPTIONS]"
    echo "Options:"
    echo "  -c, --create    Create a new user account"
    echo "  -d, --delete    Delete an existing user"
    echo "  -r, --reset     Reset password for an existing user account."
    echo "  -l, --list      List all user accounts on the system."
    echo "  -h, --help      Display this help and exit."
}

function create_user {
    read -p "Enter  the new username:" username
    #check if username already exists
    if id "$username" &>/dev/null; then
        echo "Error: The Username '$username' already exists. Please choose a different username."
    else
        #Prompt for a password
        read -p "Enter a password for $username: " password

        #Create user account
        useradd -m -p "$password" "$username"
        echo "User account '$username' created succefully"  
    fi
}

function delete_user {
    read -p "Enter a username to delete " username

    if id "$username" &>/dev/null; then
        userdel "$username"
        echo "User account '$username' deleted succefully" 
    else
        echo "Error: the username '$username' does not exits"
    fi
}

function list_users {
    echo "List of users on this system is: "
    awk -F':' '{print "- " $1 " (UID: "$3 ")"  }'/etc/passwd
}

function reset_users {
    read -p "Please enter username to reset password: " username
    #check if the username existis
    if id "$username" &>/dev/null; then
        #prompt for the password
        read -p "Enter the new password for $username: " password

        #set the new password
        echo $username:$password | chpasswd
        echo "Password for user '$username' reset successfully"
    else
        echo "Error: the username '$username' does not exists"

    #passwd "$username"

    #echo "Password reset successfully"    
}

# Check if no arguments are provided or if the -h or --help option is given
if [ $# -eq 0 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    display_usage
    exit 0
fi

#command line argument parsing
while [ $# -gt 0 ]; do
    case "$1" in 
        -c|--create)
            create_user
            ;;
        -d|--delete)
            delete_user
            ;;
        -l|--list)
            list_users
            ;;                     
        -r|--reset)
            reset_password
            ;;            
        *)
            echo "Error: Invalid option '$1'. Use '--help' to see available options."
            ;;
    esac
        shift
done

