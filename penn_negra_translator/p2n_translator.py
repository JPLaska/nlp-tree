# Python 2.6.6 - GCC 4.4.7 20120313 (Red Hat 4.4.7-4)

import collections
import re
import time

reserved_map = {
	'-LRB-': '(',
	'-RRB-': ')',
	'-LSB-': '[',
	'-RSB-': ']',
	'-LCB-': '{',
	'-RCB-': '}',
	'-NONE-': '--',
	'-None-': '--'
}

class Node(object):
	def __init__(self, tag, morph, edge, parent):
		if not tag or not edge:
			raise Exception('Tag: %s Edge: %s' % (repr(tag), repr(edge)))
		self.tag = tag
		self.morph = morph
		self.parent = parent
		self.edge = edge

class Word(Node):
	def __init__(self, word, tag, morph, edge, parent):
		super(Word, self).__init__(tag, morph, edge, parent)
		if not word:
			raise Exception(word)
		
		# Convert reserved representation strings into actual character		
		for k, v in reserved_map.items():
			self.word = re.sub(k, v, word)

class Phrase(Node):
	def __init__(self, num, tag, morph, edge, parent):
		super(Phrase, self).__init__(tag, morph, edge, parent)
		
		if not num:
			raise Exception(num)

		self.num = num

class Sentence(object):
	def _make_bottom_up(self, node, parent_num):
		tag = None
		edge = None
		
		# Establish type of node
		if re.search('[ ]$', node.data):
			# Then we have a phrase node (non-terminal)
			# Remove ending space
			data = node.data[:-1]

			# Split tags. Node tag is index 0, edge tags index > 1			
			if re.match('^[-].*$', data):
				for key in bracket_map.keys():
					if re.match(key, data):
						tag = reserved_map[key]
						edge = '-'
						break
				if not tag:
					raise Exception(data)
			
			else:				
				div = re.split('-', data)
				tag = div[0]
				if len(div) > 1 and not div[1].isdigit():
					edge = div[1]
				else:
					edge = '-'

			# Setup the refined node, and recurse to children
			num = self._pop_num()
			self.phrases.append(Phrase(num, tag, '--', edge, parent_num))
			for child in node.children:
				self._make_bottom_up(child, num)

		else:
			# We have a word node (terminal)
			
			if re.search('[*]', node.data):
				# Then we want nothing to do with it. We are not supporting
				# null co-indexing.
				return
			
			parts = node.data.split()
			if len(parts) != 2:
				# In our corpus, spaces are never used in word nodes,
				# except to separate the tags from the actual word.
				# If that ends up not being true, this should catch it.
				raise Exception(node.data)
			
			tag_data = parts[0]
			word_data = parts[1]
			
			if re.match('^[-].*$', tag_data):
				for key in reserved_map.keys():
					if re.match(key, tag_data):
						tag = reserved_map[key]
						word = tag
						edge = '-'
						break
				
				if not tag:
					raise Exception(node.data)

			else:
				div = re.split('-', tag_data)
				tag = div[0]
				word = word_data
				if len(div) > 1 and not div[1].isdigit():
					edge = div[1]
				else:
					edge = '-'

			self.words.append(Word(word, tag, '--', edge, parent_num))
	
	def _pop_num(self):
		num = self.num
		self.num += 1
		return num
		
	def __init__(self, root):
		self.words = []
		self.phrases = []
		self.num = 500
		self._make_bottom_up(root.children[0], 0)

class Block:
	def __init__(self):
		self.data = ''
		self.children = []

# Important char classes. Some only contain one possible char val.
class CHAR:
	Value = collections.namedtuple('Value', ['char', 're'])
	values = []
	
	@classmethod
	def within(cls, string):
		for value in cls.values:
			if re.search(value.re, string):
				return True
		return False
	
	@classmethod
	def matches(cls, string):
		for value in cls.values:
			if re.match(value.re, string):
				return True
		return False
		
class L_PAREN(CHAR):
	values = [CHAR.Value('(', '[(]')]
class R_PAREN(CHAR):
	values = [CHAR.Value(')', '[)]')]
class W_SPACE(CHAR):
	values = [
		CHAR.Value(' ', '\s'),
		CHAR.Value('\n', '\s'),
		CHAR.Value('\t', '\s'),
		CHAR.Value('\r', '\s'),
		CHAR.Value('\f', '\s'),
		CHAR.Value('\v', '\s')
	]

class Treebank(object):
	def _scan(self, fp):
		# A stack of lists, where a list references its children
		stack = [Block()]
		line_num = 0
		
		with open(fp, 'r') as doc:
			for line in doc:
				line_num += 1
				if line_num % 1000 == 0:
					percent = 100.0 * (float(line_num) / float(self.num_lines))		
					print 'Scanning (%s%%): Line %s of %s' % (int(percent),
															line_num,
															self.num_lines)
				# remove comments
				line = re.sub('[%][%].*$', '', line)		
				for ch in line:
					if L_PAREN.matches(ch):
						blk = Block()
						stack[-1].children.append(blk)
						stack.append(blk)
					
					elif R_PAREN.matches(ch):
						stack.pop()

					elif W_SPACE.matches(ch):
						if stack[-1].data and not re.match(W_SPACE.values[0].re, stack[-1].data[-1]):
							stack[-1].data += ch
					
					elif not re.match(W_SPACE.values[0].re, ch):
						stack[-1].data += ch
		return stack[-1]
		
	def write(self, fp):
		with open(fp, 'w') as doc:
			doc.write('#FORMAT 3\n')
			
			doc.write('#BOT ORIGIN\n')
			doc.write('0\t--\n')
			doc.write('1\t%s\n' % re.split('[/]', fp)[-1])
			doc.write('#EOT ORIGIN\n')
			
			doc.write('#BOT EDITOR\n')
			doc.write('-1\t--\t<automatic>\n')
			doc.write('0\t--\t<not named>\n')
			doc.write('#EOT EDITOR\n')
			
			doc.write('%% word\ttag\tmorph\tedge\tparent\n')
			fmt = '%s\t%s\t%s\t%s\t%s\n'
			
			for index, sentence in enumerate(self.sentences):
				percent = 100.0 * float(index + 1) / (float(len(self.sentences)))
				print 'Writing (%s%%): Sentence %s of %s' % (int(percent),
														   index + 1,
														   len(self.sentences))
				
				doc.write('#BOS %s 0 %s 1\n' % (index + 150, self.date))
				
				
				for node in sentence.words:
					if node.word == '--':
						continue

					doc.write(fmt % (node.word,
									 node.tag,
									 node.morph,
									 node.edge,
									 node.parent))
				
				for node in sentence.phrases:
					doc.write('#' + fmt % (node.num,
										   node.tag,
										   node.morph,
										   node.edge,
										   node.parent))
				
				doc.write('#EOS %s\n' % index)
	
	def __init__(self, fp):
		self.date = int(time.time())
		
		# Check number of lines quick for debug purposes
		doc = open(fp, 'r')
		self.num_lines = 0
		for line in doc:
			self.num_lines += 1
		doc.close()
		
		raw_tree = self._scan(fp)
		
		self.sentences = []
		for index, sentence in enumerate(raw_tree.children):
			percent = 100.0 * float(index + 1) / float(len(raw_tree.children))
			print 'Parsing (%s%%): Sentence %s of %s' % (int(percent),
													   index + 1,
													   len(raw_tree.children))
			self.sentences.append(Sentence(sentence))

def translate(in_fp, out_fp):
	tb = Treebank(in_fp)
	tb.write(out_fp)
		
		
