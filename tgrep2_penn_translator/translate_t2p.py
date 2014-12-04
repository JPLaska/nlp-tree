# Python 2.6.6 - GCC 4.4.7 20120313 (Red Hat 4.4.7-4)

import sys
import t2p_translator

if __name__ != '__main__':
    raise Exception('This is a command line executable module only!')

if not sys.argv[2]:
	raise Exception('Usage: python translate_t2p.py <input_fp> <output_fp>')

t2p_translator.translate(sys.argv[1], sys.argv[2])
