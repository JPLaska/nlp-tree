# Python 2.6.6 - GCC 4.4.7 20120313 (Red Hat 4.4.7-4)

import collections
import re
import time

class Node(object):
	def __init__(self, tag, morph, edge, parent):
		self.tag = tag
		self.morph = morph
		self.parent = parent
		self.edge = edge

class Word(Node):
	def __init__(self, word, tag, morph, edge, parent):
		super(Word, self).__init__(tag, morph, edge, parent)
		self.word = word

class Phrase(Node):
	def __init__(self, num, tag, morph, edge, parent):
		super(Phrase, self).__init__(tag, morph, edge, parent)
		self.num = num

class Sentence(object):
	def _make_bottom_up(self, node, parent_num):
		# Establish type of node
		if re.search('[ ]$', node.data):
			# Then we have a phrase node (non-terminal)
			# Remove ending space
			data = node.data[:-1]

			# Split tags. Node tag is index 0, edge tags index > 1
			div = re.split('-', data)
			
			# Right now we do not support null co-indexes
			edge = '--'
			if len(div) > 1 and not div[1].isdigit():
				edge = re.sub('[=].*$', '', div[1])

			# Setup the refined node, and recurse to children
			num = self._pop_num()
			self.phrases.append(Phrase(num, div[0], '--', edge, parent_num))
			for child in node.children:
				self._make_bottom_up(child, num)

		else:
			# We have a word node (terminal)
			data = node.data.split()
			if len(data) != 2:
				raise Exception('1')

			# Right now we do not support null co-indexes
			div = re.split('-', data[0])
			edge = '--'
			if len(div) > 1 and not div[1].isdigit():
				edge = re.sub('[=].*$', '', div[1])
				
			# Punctuation gets parent node 0
			if PUNCT.matches(div[0]):
				parent_num = 0
			
			if re.search('NONE', data[0]):
				div[0] = '--'
				data[1] = ''
				edge = '--'
				

			self.words.append(Word(data[1], div[0], '--', edge, parent_num))
	
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
		CHAR.Value(None, '\s'),
		CHAR.Value(' ', '\s'),
		CHAR.Value('\n', '\s'),
		CHAR.Value('\t', '\s'),
		CHAR.Value('\r', '\s'),
		CHAR.Value('\f', '\s'),
		CHAR.Value('\v', '\s')
	]
class DASH(CHAR):
	values = [CHAR.Value('-', '-')]
class STAR(CHAR):
	values = [CHAR.Value('*', '[*]')]
class PERCENT(CHAR):
	values = [CHAR.Value('%', '[%]')]

class PUNCT(CHAR):
	values = [
		CHAR.Value('.', '[.]'),
		CHAR.Value(',', '[,]'),
		CHAR.Value(':', '[:]')
	]

class Treebank(object):
	@staticmethod
	def _scan(fp):
		# A stack of lists, where a list references its children
		stack = [Block()]
		
		with open(fp, 'r') as doc:
			for line in doc:
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
				doc.write('#BOS %s 0 %s 1\n' % (index, self.date))
				
				for node in sentence.words:
					doc.write(fmt % (node.word,
									 node.tag,
									 node.morph,
									 node.edge,
									 node.parent))
				
				for node in sentence.phrases:
					doc.write(fmt % (node.num,
									 node.tag,
									 node.morph,
									 node.edge,
									 node.parent))
				
				doc.write('#EOS %s\n' % index)
	
	def __init__(self, fp):
		self.date = int(time.time())
		raw_tree = Treebank._scan(fp)
		
		self.sentences = []
		for sentence in raw_tree.children:
			self.sentences.append(Sentence(sentence))

def translate(in_fp, out_fp):
	tb = Treebank(in_fp)
	tb.write(out_fp)
		
		
