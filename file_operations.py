import logging
import subprocess
from config_handlers import get_configurations, handle_net_configs, handle_fix_commands, handle_patterns, handle_deprecated_commands
from utilities import write_modified_lines, read_file

def find_config_files(steam_path):
    """Finds all config.cfg files in the appropriate folders."""
    if not steam_path or not isinstance(steam_path, str):
        logging.error("Invalid Steam path provided.")
        return [], False

    try:
        cfg_files = []

        # Define the userdata directory using the provided steam_path
        userdata_dir = f"{steam_path}\\userdata"

        # Check if the userdata directory exists using subprocess
        result = subprocess.run(f'if exist "{userdata_dir}" (echo exists) else (echo notexists)', shell=True, text=True, capture_output=True, check=False)
        
        if 'notexists' in result.stdout:
            logging.warning(f"The 'userdata' folder does not exist at the path: {userdata_dir}")
            return cfg_files, len(cfg_files) > 0

        # Find all directories within userdata_dir using subprocess
        result = subprocess.run(f'dir /b /ad "{userdata_dir}"', shell=True, text=True, capture_output=True, check=False)
        user_folders = result.stdout.strip().split('\n')

        # Check if any user folders are found
        if not user_folders or 'File Not Found' in user_folders[0]:
            logging.warning(f"No user ID folders found in 'userdata' at the path: {userdata_dir}")
            return cfg_files, len(cfg_files) > 0

        # Loop through each user folder to find config directories
        for user_folder in user_folders:
            cfg_dir = f"{userdata_dir}\\{user_folder}\\730\\local\\cfg"
            
            # If a config directory is found, find all config.cfg files in it using subprocess and dir command
            result = subprocess.run(f'dir /s /b "{cfg_dir}\\config.cfg"', shell=True, text=True, capture_output=True, check=False)
                
            if result.stdout:
                cfg_file_paths = result.stdout.strip().split('\n')
                for cfg_file_path in cfg_file_paths:
                    cfg_files.append((cfg_file_path, user_folder))
        
        # Return the list of config files and a boolean indicating if any were found
        return cfg_files, len(cfg_files) > 0
    except Exception as e:
        logging.error("An unexpected error occurred while searching for config.cfg files: %s", str(e))
        return [], False
    
def prepare_destination(cfg_file, user_folder, cs2_install_path):
    """
    Prepares the destination directory where the modified config file will be saved.
    This function creates the directory (if it does not exist) and generates the new file name.

    :param cfg_file: The path to the original config file.
    :param user_folder: The user folder where the config file is located.
    :param cs2_install_path: The installation path of CS2.
    :return: The path to the destination where the new file is stored.
    """
    try:
        # Check if the cs2_install_path directory exists using subprocess
        result = subprocess.run(f'if exist "{cs2_install_path}" (echo exists) else (echo notexists)', shell=True, text=True, capture_output=True, check=False)
        
        if 'notexists' in result.stdout:
            logging.warning(f"The 'Steam32ID' folder does not exist at the path: {cs2_install_path}")

        # Construct the new file name
        new_file_name = f"{user_folder}.cfg"
        logging.info("Generated new file name: %s", new_file_name)

        # Determine the destination path using string concatenation instead of os.path.join
        destination = f"{cs2_install_path}\\{new_file_name}"

        # Now, instead of copying the original file, you just return the destination
        # path where the new, modified content will be written.
        logging.info("Prepared destination path: %s", destination)

        # Return the destination path
        return destination

    except Exception as e:
        logging.error("An error occurred while preparing the destination: %s", str(e))
        return None

def echo_lines():
    """
    This function returns an ASCII art that will be added at the end of the config.cfg file.
    :return: A list of strings to be added at the end of the modified lines.
    """
    return [
        'echo "                                             .=-   +#=                                              "',
        'echo "                                            :@@%- :@@@:                                             "',
        'echo "                                            :@@@#=#@@@-  .                                          "',
        'echo "                                         :  .@@@@@@@@@+.=#+                                         "',
        'echo "                                        +@%+#@@@@@@@@@@@@@@+                                        "',
        'echo "                                       :@@@@@@@#=::=#@@@@@@=                                        "',
        'echo "                                       .%@@@@#-      -#@@@#.                                        "',
        'echo "                                        :@@@*..=*=  ...*@@*                                         "',
        'echo "                                         @@#..*%*: .+: .#@@#*+.                                     "',
        'echo "                                      :=#@@- =@%:  :#.- -@@@@%:                                     "',
        'echo "                                     =@@@@#-%@%%%. +@## .%@@@@-                                     "',
        'echo "                                     =@@@@*.+%:=@%*@*=. .*@@@#:                                     "',
        'echo "                                     :#@@@*  :  +@@%.    *@@-                                       "',
        'echo "                                      .:%@*.   .*@@%-   .*@@                                        "',
        'echo "                                        *@#.  +%@*=@%-  .%@@#.                                      "',
        'echo "                                       .%@@- =+%*  =@@: -@@@@%.                                     "',
        'echo "                                      :%@@@#.. ==   +@*.#@@@@#.                                     "',
        'echo "                                      =@@@@@+  -:   .-.*@@###=                                      "',
        'echo "                                      .%@#%@@*:      :*@@#:...                                      "',
        'echo "                                       ...:#@@%*-::-*%@@@*.                                         "',
        'echo "                                           *@@@@@@@@@@@@@%:                                         "',
        'echo "                                          .#@@@%@@@@@##@@@-                                         "',
        'echo "                                          :#@@+:+@@@*. =#=.                                         "',
        'echo "                                           :*=  .%@@=   .                                           "',
        'echo "                                                 *@%-                                               "',
        'echo "                                ::                   :*################=.               .%:         "',
        'echo "                               -%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%=-----.        -@-         "',
        'echo "                             .+@@@@@@@@@@@@@@@@@@@@@@@@@@@%***####**##@@@%****##-       =*-         "',
        'echo "                  .::-=:   -+#@@@@@@@@@@@@@@@@@@@@@@@@@@@@%***%%%%**#%@@@@%%%%%@%*-:...=**=.        "',
        'echo "        .:-=+*##%%@@@@@@**%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@=       "',
        'echo "       =@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%+-       "',
        'echo "       +@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%%%%%%%%%%%#=====+#+--------*#.         "',
        'echo "       +@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%##@@@@@@@@@++++*%@%+:::::::::::.                            "',
        'echo "       +@@@@@@@@@@@@@@@@@@@@%#%@@@@@@@*=..+@@@@@@@@.    :-:                                         "',
        'echo "       +@@@@@@@@@@@@@@@@@@*:...:%@@@@%:-  -%@@@@@@@:                                                "',
        'echo "       +@@@@@@@@@@@@@@@#=      -@@@@@%=...=##@@@@@@=                                                "',
        'echo "       +@@@@@@@@@@@%#+:       .%@@@@*..:-:   %@@@@@#                                                "',
        'echo "       +@@@@@@@@@#+-          *@@@@*         =@@@@@%:                                               "',
        'echo "       +@@@@@@%+:.           -@@@@#.         .@@@@@@*.                                              "',
        'echo "       +@@@@*:.              #@@@@:           +@@@@@@=                                              "',
        'echo "       =@#=                  %@@@*            :@@@@@@@:                                             "',
        'echo "        .                    =@@%:             +@@@@@@%:                                            "',
        'echo "                              --:              :#@@@@@@%=                                           "',
        'echo "                                                -@@@@@@@@+.                                         "',
        'echo "                                                 =@@@@@@@@=                                         "',
        'echo "                                                  +@@@@@@%:                                         "',
        'echo "                                                   +@@@@@=                                          "',
        'echo "                                                    =%@@*                                           "',
        'echo "                                                     -%%.                                           "',
        'echo "                                                      ..                                            "',
        'echo "                                       _____    _____   ___                                         "',
        'echo "                                      / ____|  / ____| |__ \                                        "',
        'echo "                                      | |     | (___      ) |                                       "',
        'echo "                                      | |      \___ \    / /                                        "',
        'echo "                                      | |___   ____) |  / /_                                        "',
        'echo "                                      \_____| |_____/  |____|                                       "',
        'echo "                                                                                                    "',
        'echo "                                 _____                 __   _                                       "',
        'echo "                                / ____|               / _| (_)                                      "',
        'echo "                                | |       ___   _ __  | |_  _   __ _                                "',
        'echo "                                | |      / _ \ | _  \ |  _|| | / _  |                               "',
        'echo "                                | |____ | (_) || | | || |  | || (_| |                               "',
        'echo "                                \_____|  \___/ |_| |_||_|  |_| \__, |                               "',
        'echo "                                                                __/ |                               "',
        'echo "                                                               |___/                                "',
        'echo "                           __  __  _                      _                                         "',
        'echo "                          |  \/  |(_)                    | |                                        "',
        'echo "                          | \  / | _   __ _  _ __   __ _ | |_   ___   _ __                          "',
        'echo "                          | |\/| || | / _  ||  __| / _  || __| / _ \ |  __|                         "',
        'echo "                          | |  | || || (_| || |   | (_| || |_ | (_) || |                            "',
        'echo "                          |_|  |_||_| \__, ||_|    \__,_|\___| \___/ |_|                            "',
        'echo "                                       __/ |                                                        "',
        'echo "                                      |___/                                                         "',
        'echo "                                                                                                    "',
        'echo "                                           By IG: manny_agre                                        "',
        'echo "                                                                                                    "',
        'echo "                                                                                                    "',
        'echo "                                     CONFIG SUCCESFULLY APPLIED                                     "',
        'echo "                                                                                                    "',
        'echo "                                               GLHF :)                                              "'
    ]

def modify_lines(lines):
    """
    This function modifies the lines from the configuration file based on various rules defined in 
    get_configurations function. It handles deprecated commands, pattern replacements, fix commands,
    and network configurations. It also appends 'host_writeconfig' and the content of echo_lines
    at the end of the modified lines.
    
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
    modified_lines.append("host_writeconfig\n")
    logging.info("Added 'host_writeconfig' at the end of the file")

    # Append echo's content at the end of the modified lines
    echo_lines_content = echo_lines()
    for echo_line in echo_lines_content:
        modified_lines.append(echo_line + "\n")
    logging.info("Added echos at the end of the file")

    return modified_lines

def modify_cfg_file(cfg_file, user_folder, cs2_install_path):
    try:
        # Inicializando config_modified como True suponiendo una modificación exitosa
        config_modified = True
        
        # Leyendo las líneas del archivo cfg original con permisos de solo lectura
        lines = read_file(cfg_file)
        
        # Modificando las líneas en memoria basándose en configuraciones predefinidas
        modified_lines = modify_lines(lines)
        
        # Preparando el destino para el archivo cfg
        destination = prepare_destination(cfg_file, user_folder, cs2_install_path)
        
        # Escribiendo las líneas modificadas en el archivo cfg en el destino
        write_modified_lines(destination, modified_lines)
        
        # Logging the successful modification of the cfg file
        logging.info("Se hicieron modificaciones exitosas del archivo %s", cfg_file)
        
        # Devolviendo True para indicar una modificación exitosa
        return config_modified

    except Exception as e:
        # Si ocurre una excepción, estableciendo config_modified en False
        config_modified = False
        
        # Logging the error that occurred during the modification
        logging.error("Ocurrió un error mientras se modificaba o movía el archivo %s: %s", cfg_file, str(e))
        
        # Devolviendo False para indicar una modificación no exitosa
        return config_modified
