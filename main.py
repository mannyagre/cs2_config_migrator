import logging
from installation_paths import get_cs2_installation_path, get_steam_installation_path
from file_operations import find_config_files, modify_cfg_file

if __name__ == "__main__":

    logging.basicConfig(level=logging.DEBUG, format='%(levelname)s: %(message)s')

    # Getting steam and cs2 installation path
    steam_path, steam_success = get_steam_installation_path()
    cs2_path, cs2_success = get_cs2_installation_path()
    
    print("Ruta de instalación de steam: ", steam_path)
    print("Ruta de instalación de cs2: ", cs2_path)

    if steam_success and cs2_success:
        # Looking for all config.cfg cs:go files
        config_files, config_files_success = find_config_files(steam_path)

        if config_files_success:
            for cfg_file, user_folder in config_files:
                # Modifies every config.cfg file found
                modify_cfg_file(cfg_file, user_folder, cs2_path)
        else:
            # Error message if no config files were found
            logging.error("No config.cfg files found")
    else:
        # Error message if could't find steam or cs2 installed
        logging.error("Steam or CS2 not found")
