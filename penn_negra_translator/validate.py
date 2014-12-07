# Python 2.6.6 - GCC 4.4.7 20120313 (Red Hat 4.4.7-4)
# Python built-in libraries
import re
import sys

# Project library - English specifics
import conf

patterns = conf.patterns
tags = conf.tags

# Lists to classify tokens (Valid/Invalid)
valid = []
invalid = []

def _is_valid_tag(tag):
	if tag in tags:
		return True

	else:
		div = re.split('=', tag)

		if div[0] in tags and re.match('^[0-9]+$', div[1]):
			return True
		else:
			return False

def _analyze_token(token):
	matched = None	
	if re.search('^[(]', token):
		matched = True

		split = re.split('-', token[1:])
		for item in split[:-1]:
			if not _is_valid_tag(item):
				matched = False
		if not _is_valid_tag(split[-1]) and not re.match('^[0-9]+$', split[-1]):
			matched = False
			print 'Split ' + split[-1]
			print 'Match ' + str(re.match('^[0-9]+$', split[-1]))

	elif re.search('[)]$', token):
		matched = False

		for pattern in patterns:
			if re.match(pattern, token):
				matched = True

	else:
		raise Exception('Each token must either begin with "(" or end with ")".')

	if matched:
		valid.append(token)
	else:
		invalid.append(token)
	
if __name__ == '__main__':
	if not sys.argv[1]:
		raise Exception('Usage: python check.py <filepath>')
	
	with open(sys.argv[1], 'r') as doc:
		for token in set(doc.read().split()):
			_analyze_token(token)
	
	with open('./report.txt', 'w') as doc:
		doc.write( 'Invalid tokens:\n')
		for token in invalid:
			doc.write('  %s\n' % token)
			
		doc.write('\nValid tokens:\n')
		for token in valid:
			doc.write('  %s\n' % token)
