from typing import TextIO, List
import sys
import os

def write_items(file: TextIO, *items: List) -> None:
    """ Write list items into a TextIO object """
    for _config in items:
        conf = _config.split(':')
        config = "{}\t{}".format(*conf)
        file.write("{}\n".format(config))

def write_config(filename: str, *configs: List) -> None:
    """ Responsible for writing configurations based on HiBench config templates.
        This function can also configure based on environment variables that have the prefix 'HIBENCH'
        Example:
            HIBENCH_HADOOP_HOME=/your/hadoop/home/dir
            HIBENCH_HADOOP_EXECUTABLE=/your/hadoop/home/dir/bin/hadoop
            ...
        Example:
        $~ python3 create_config.py spark.conf hadoop.home:$HADOOP_HOME hadoop.executable:$HADOOP_HOME/bin/hadoop
    """

    with open(filename, mode='w') as file:
        if 'FROM_ENV' in os.environ:
            items = list(filter(lambda x: 'HIBENCH' in x[0], os.environ.items()))
            items = list(map(lambda x: (x[0].lower(), x[1].lower()), items))
            items = list(map(lambda x: "{}:{}".format(x[0].replace('_', '.'), x[1]), items))
            print(items)
            write_items(file, *items)
        else:
            write_items(file, *configs)


if __name__ == '__main__':
    if len(sys.argv) > 2:
        write_config(sys.argv[1], *sys.argv[2:])
    else:
        write_config(sys.argv[1])
