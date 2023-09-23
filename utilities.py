import logging
import subprocess

def read_file(destination):
    """
    Reads the contents of a file line by line using subprocess.

    :param destination: The path to the file that needs to be read.
    :return: A list containing all the lines in the file.
    """
    try:
        result = subprocess.run(f'type "{destination}"', shell=True, check=True, text=True, capture_output=True)
        lines = result.stdout.split('\n')
        logging.info("Successfully read the file at: %s", destination)
        return lines
    except subprocess.CalledProcessError as e:
        logging.error("An error occurred while reading the file at %s: %s", destination, str(e))
        return None
    except Exception as e:
        logging.error("An unexpected error occurred: %s", str(e))
        return None

def write_modified_lines(destination, modified_lines):
    try:
        for line in modified_lines:
            formatted_line = line.strip()
            if formatted_line:  # Solo ejecuta echo si la línea no está vacía
                subprocess.run(f'echo {formatted_line} >> "{destination}"', shell=True, check=True)
            else:
                pass
        logging.info("Successfully wrote the modified lines to the file at: %s", destination)
    except subprocess.CalledProcessError as e:
        logging.error("An error occurred while writing the modified lines to the file at %s: %s", destination, str(e))
    except Exception as e:
        logging.error("An unexpected error occurred: %s", str(e))
