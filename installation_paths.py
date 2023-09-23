import logging
from winreg import ConnectRegistry, OpenKey, QueryValueEx, HKEY_CURRENT_USER, KEY_READ, CloseKey

def get_steam_installation_path():
    """Retrieves the installation path of Steam from the Windows registry."""
    try:
        # Connecting to the Windows registry (specifically the HKEY_CURRENT_USER hive) 
        # and opening the key where Steam information is stored
        registry_key = OpenKey(ConnectRegistry(None, HKEY_CURRENT_USER), "Software\\Valve\\Steam")
        
        # Querying the registry to get the value associated with the "SteamPath", 
        # which is the installation path of Steam
        steam_path, reg_type = QueryValueEx(registry_key, "SteamPath")
        
        # Closing the registry key after the necessary information has been retrieved
        CloseKey(registry_key)
        
        # Returning the retrieved Steam installation path and a success flag
        return steam_path, True
    except Exception as e:
        # Logging an error message if any exception occurs during the process
        logging.error(f"Could not retrieve the Steam installation path: {e}")
        
        # Returning None and a failure flag if an error occurred during the retrieval process
        return None, False

def get_cs2_installation_path():
    """Retrieves the installation path of CS2 from the Windows registry."""
    try:
        # Connecting to the registry and opening a specific key to read the CS2 path
        registry_key = OpenKey(HKEY_CURRENT_USER, "Software\\Classes\\csgo\\Shell\\Open\\Command", 0, KEY_READ)
        
        # Querying the registry to get the value associated with the CS2 path
        cs2_path, reg_type = QueryValueEx(registry_key, "")
        
        # Closing the registry key after retrieving the necessary information
        CloseKey(registry_key)
        
        # Extracting the executable path from the registry value (it takes the part between the quotes)
        path = cs2_path.split('"')[1]
        
        # Adjusting the path to point to the configuration folder of CS2 instead of the executable file
        path = path.replace(r"\game\bin\win64\cs2.exe", r"\game\csgo\cfg")
        
        # Returning the modified path and a success flag
        return path, True
    except Exception as e:
        # Logging an error message if any exception occurs during the process
        logging.error(f"Could not retrieve the CS2 installation path: {e}")
        
        # Returning None and a failure flag in case of an error
        return None, False