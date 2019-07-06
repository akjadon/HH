"""Write a program that given a text file will create a new text file in 
which all the lines from the original file are numbered from 1 to n 
(where n is the number of lines in the file)."""

import re

# I couldn't think of a better name for this :P
def numberize(file_name):
	# Get basename and extension of provided file to create a better
	# name for the new file
	fname = re.search(r'([\w-]+)(\.[\w.-]+)', file_name)
	basename = fname.group(1)
	extension = fname.group(2)

	# Create our new file and write to it
	with open(file_name, 'r') as f1:
		with open(basename + '-numbered' + extension, 'w') as f2:
			for lnum, lval in enumerate(f1):
				f2.write('%d %s' % (lnum+1, lval))

#test
numberize('poem.txt')
						