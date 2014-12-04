# Python 2.6.6 - GCC 4.4.7 20120313 (Red Hat 4.4.7-4)
# Parameters: location of file to translate, (optional) where to put copy

import argparse

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('in_fp', help='File path for Penn formatted treebank.')
    parser.add_argument('out_fp', help='File path to send translated NeGra formatted treebank.')
    parser.parse_args()




# Open File for Reading

