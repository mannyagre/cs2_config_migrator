import os
import logging
import sys

def resource_path(relative_path):
    """ Get absolute path to resource, works for dev and for PyInstaller """
    base_path = getattr(sys, '_MEIPASS', os.path.dirname(os.path.abspath(__file__)))
    return os.path.join(base_path, relative_path)

def read_file(destination):
    """
    Reads the contents of a file line by line.

    :param destination: The path to the file that needs to be read.
    :return: A list containing all the lines in the file.
    """
    try:
        with open(destination, 'r') as file:
            lines = file.readlines()
            logging.info("Successfully read the file at: %s", destination)
        return lines
    except Exception as e:
        logging.error("An error occurred while reading the file at %s: %s", destination, str(e))
        return None

def write_modified_lines(destination, modified_lines):
    """
    Writes modified lines to the specified file.

    :param destination: The path where the modified lines should be written to.
    :param modified_lines: The lines to write to the file.
    """
    try:
        with open(destination, 'w') as file:
            file.writelines(modified_lines)
            logging.info("Successfully wrote the modified lines to the file at: %s", destination)
    except Exception as e:
        logging.error("An error occurred while writing the modified lines to the file at %s: %s", destination, str(e))
