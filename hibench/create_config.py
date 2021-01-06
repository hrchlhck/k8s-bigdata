from typing import TextIO, List
import sys
import os


def write_items(file: TextIO, sep: str, *items: List) -> None:
    """ Write list items into a TextIO object """
    for _config in items:
        conf = _config.split(sep)
        config = "{}\t{}".format(*conf)
        print("Writing {} to {}".format(config, file.name))
        file.write("{}\n".format(config))


def write_config(prefix:str, filename: str) -> None:
    """ Creates a file containing configurations for HiBench depending on environment variables

        Arguments:
            filename: str  - Output file name

        Example:
            - Env vars
            HIBENCH_HADOOP_HOME=/your/hadoop/home/dir
            HIBENCH_HADOOP_EXECUTABLE=/your/hadoop/home/dir/bin/hadoop
            ...

            - Command line
            $ python3 hdfs.conf

            - hdfs.conf
            hibench.hadoop.home             /your/hadoop/home/dir
            hibench.hadoop.executable       /your/hadoop/home/dir/bin/hadoop

    """

    def filter_config(filename, config_name):
        """ Filter function to distinguish where configuration will be written on file"""
        if "spark" in filename:
            return "spark" in config_name
        elif "hdfs" in filename or "hadoop" in filename:
            return "hdfs" in config_name or "hadoop" in config_name

    with open(filename, mode='w') as file:
        items = list(filter(lambda x: prefix in x[0], os.environ.items()))
        items = list(map(lambda x: (x[0].lower(), x[1].lower()), items))

        # Will filter configuration lines based on the name of the file
        items = list(filter(lambda x: filter_config(file.name, x[0]), items))

        sep = "__" # Separator for str.split()
        items = list(map(lambda x: "{}{}{}".format(
            x[0].replace('_', '.'), sep, x[1]), items))
        write_items(file, sep, *items)


if __name__ == '__main__':
    # Argument count
    argc = len(sys.argv)

    if argc == 3:
        write_config(sys.argv[1], sys.argv[2])
    else:
        print("Usage: create_config.py <PREFIX> <FILENAME>")
        exit(-1)
