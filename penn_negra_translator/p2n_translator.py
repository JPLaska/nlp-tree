# Python 2.6.6 - GCC 4.4.7 20120313 (Red Hat 4.4.7-4)

import re

def _iterate(tgrep2, penn):
    for line in tgrep2:
        penn.write(re.sub('^[(]TOP  ', '', line))

def translate(in_fp, out_fp):
    with open(in_fp, 'r') as tgrep2:
		with open(out_fp, 'w') as penn:
			_iterate(tgrep2, penn)
