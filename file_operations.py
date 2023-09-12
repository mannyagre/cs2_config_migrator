import logging
import os
import shutil
from config_handlers import get_configurations, handle_net_configs, handle_fix_commands, handle_patterns, handle_deprecated_commands
from utilities import write_modified_lines, read_file, resource_path

def find_config_files(steam_path):
    """Finds all config.cfg files in the appropriate folders."""
    if not steam_path or not isinstance(steam_path, str):
        logging.error("Invalid Steam path provided.")
        return [], False

    try:
        cfg_files = []

        # Define the userdata directory using the provided steam_path
        userdata_dir = os.path.abspath(os.path.join(steam_path, "userdata"))

        # Check if the userdata directory exists
        if not os.path.exists(userdata_dir):
            logging.warning(f"The 'userdata' folder does not exist at the path: {userdata_dir}")
            return cfg_files, len(cfg_files) > 0

        # Find all directories within userdata_dir
        user_folders = [f for f in os.listdir(userdata_dir) if os.path.isdir(os.path.join(userdata_dir, f))]

        # Check if any user folders are found
        if not user_folders:
            logging.warning(f"No user ID folders found in 'userdata' at the path: {userdata_dir}")
            return cfg_files, len(cfg_files) > 0

        # Loop through each user folder to find config directories
        for user_folder in user_folders:
            cfg_dir = os.path.join(userdata_dir, user_folder, "730", "local", "cfg")
            
            # If a config directory is found, find all files in it recursively
            if os.path.isdir(cfg_dir):
                for root, dirs, files in os.walk(cfg_dir):
                    # Loop through each file found in the current directory
                    for file in files:
                        # If the file is a config file, add its path and user folder to the cfg_files list
                        if file.lower() == "config.cfg":
                            cfg_file_path = os.path.join(root, file)
                            cfg_files.append((cfg_file_path, user_folder))  

        # Return the list of config files and a boolean indicating if any were found
        return cfg_files, len(cfg_files) > 0
    except OSError as e:
        logging.error("An OS error occurred while searching for config.cfg files: %s", str(e))
        return [], False
    except Exception as e:
        logging.error("An unexpected error occurred while searching for config.cfg files: %s", str(e))
        return [], False
    
def prepare_destination(cfg_file, user_folder, cs2_install_path):
    """
    Prepares the destination directory where the modified config file will be saved.
    This function creates the directory (if it does not exist), generates the new file name,
    and copies the original file to the destination directory.

    :param cfg_file: The path to the original config file.
    :param user_folder: The user folder where the config file is located.
    :param cs2_install_path: The installation path of CS2.
    :return: The path to the destination where the new file is stored.
    """
    try:
        # Create the directory if it does not exist
        os.makedirs(cs2_install_path, exist_ok=True)
        logging.info("Created or confirmed the existence of the directory: %s", cs2_install_path)

        # Construct the new file name
        new_file_name = f"{user_folder}.cfg"
        logging.info("Generated new file name: %s", new_file_name)

        # Determine the destination path
        destination = os.path.join(cs2_install_path, new_file_name)

        # Copy the original config file to the destination directory
        shutil.copy(cfg_file, destination)
        logging.info("Copied %s to %s", cfg_file, destination)

        # Return the destination path
        return destination

    except Exception as e:
        logging.error("An error occurred while preparing the destination: %s", str(e))
        return None

def modify_lines(lines):
    """
    This function modifies the lines from the configuration file based on various rules defined in 
    get_configurations function. It handles deprecated commands, pattern replacements, fix commands,
    and network configurations. It also appends 'host_writeconfig' and the content of 'echo.txt' 
    (if exists) at the end of the modified lines.
    
    :param lines: A list of strings where each string is a line from the original configuration file.
    :return: A list of modified lines as per the defined configurations and rules.
    """
    # Fetching configurations for modifying the lines
    patterns, cs2_better_net_configs, deprecated_commands, fix_commands = get_configurations()
    
    # Initialize an empty list to store the modified lines
    modified_lines = []

    # Initialize an empty set to keep track of patterns found
    found_patterns = set()

    # Loop through each line in the input lines
    for line in lines:
        # Handle deprecated commands and determine if the line should be deleted
        line, should_delete = handle_deprecated_commands(line, deprecated_commands)
        
        # Handle pattern replacements in the line
        line = handle_patterns(line, patterns)
        
        # Handle fix commands in the line
        line = handle_fix_commands(line, fix_commands)

        # If the line should not be deleted, handle network configurations and add it to the modified lines
        if not should_delete:
            line = handle_net_configs(line, cs2_better_net_configs)
            modified_lines.append(line)
        else:
            continue

    # Add 'host_writeconfig' at the end of the file
    modified_lines.append("host_writeconfig")
    logging.info("Added 'host_writeconfig' at the end of the file")

    # Check if 'echo.txt' exists and if so, append its content at the end of the modified lines
    echo_txt_path = resource_path('echo.txt')
    if os.path.exists(echo_txt_path):
        with open(echo_txt_path, 'r') as echo_file:
            echo_content = echo_file.read()
        modified_lines.append("\n" + echo_content)
    else:
        logging.warning("echo.txt file not found.")

    return modified_lines

def modify_cfg_file(cfg_file, user_folder, cs2_install_path):
    """
    This function coordinates the modification of a cfg file. It prepares the destination, 
    reads the file from the destination, modifies the lines based on various rules defined 
    in the modify_lines function, and writes the modified lines back to the destination.
    
    If the modifications are successful, it returns True, otherwise it returns False.
    
    :param cfg_file: The path to the original cfg file.
    :param user_folder: The user folder where the modified cfg file will be saved.
    :param cs2_install_path: The installation path of CS2.
    
    :return: A boolean indicating whether the modifications were successful.
    """
    try:
        # Initializing config_modified as True assuming successful modification
        config_modified = True
        
        # Preparing the destination for the cfg file
        destination = prepare_destination(cfg_file, user_folder, cs2_install_path)
        
        # Reading the lines from the cfg file located at the destination
        lines = read_file(destination)
        
        # Modifying the lines based on predefined configurations
        modified_lines = modify_lines(lines)
        
        # Writing the modified lines back to the cfg file at the destination
        write_modified_lines(destination, modified_lines)
        
        # Logging the successful modification of the cfg file
        logging.info("Successfully made modifications in the file %s", cfg_file)
        
        # Printing a message to indicate the successful modification and the new location of the cfg file
        print(f"File {cfg_file} copied and modified at {destination}")
        
        # Returning True to indicate successful modification
        return config_modified

    except Exception as e:
        # If an exception occurs, setting config_modified to False
        config_modified = False
        
        # Logging the error that occurred during the modification
        logging.error("An error occurred while modifying or moving the file %s: %s", cfg_file, str(e))
        
        # Returning False to indicate unsuccessful modification
        return config_modified
