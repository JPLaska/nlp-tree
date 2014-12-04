# Python 2.6.6 - GCC 4.4.7 20120313 (Red Hat 4.4.7-4)

class Translator:
    def __init__(self, in_fp, out_fp):
        penn = open(in_fp)
        negra = open(out_fp)
