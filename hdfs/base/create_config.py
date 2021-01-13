from typing import TextIO
import sys
import os

def add_property(file: TextIO, key: str, value: object) -> None:
    _property = "\t<property>\n\t\t<name>{}</name>\n\t\t<value>{}</value>\n\t</property>\n".format(key, value)
    file.write(_property)

def get_env(prefix: str) -> list:
    def clear_text(text: str) -> str:
        unwanted_chars = "\n\r\t?; "
        for char in unwanted_chars:
            text = text.replace(char, "")
        return text

    def map_keys(text: str) -> str:
        # Remove underscores
        text = text.replace("_", ".")

        # Fix configurations that are separated by triple underscores
        if "..." in text:
            text = text.replace("...", "-")
        return text

    # Get environment variables based on prefix
    env_vars = list(filter(lambda x: prefix in x[0], os.environ.items()))

    # Remove unwanted characters and replaces _ by .
    cleared = list(map(lambda x: {map_keys(clear_text(x[0].split(prefix + "_")[1])): clear_text(x[1])}, env_vars))

    return cleared

def add_configuration(prefix: str, filename: str) -> None:
    with open(filename, mode="w") as file:
        file.write("<configuration>\n")
        for env in get_env(prefix):
            name, value = env.popitem()
            add_property(file, name, value)
        file.write("</configuration>")

if __name__ == "__main__":
    argc = len(sys.argv)

    if argc == 3:
        add_configuration(sys.argv[1], sys.argv[2])
    else:
        print("Usage: create_config.py <PREFIX> <FILENAME>")
        exit(-1)
