"""A hapax legomenon (often abbreviated to hapax) is a word which occurs 
only once in either the written record of a language, the works of an 
author, or in a single text. Define a function that given the file name 
of a text will return all its hapaxes. Make sure your program ignores 
capitalization."""

def hapax(file_name):
	words = [] # Prepare our words list
	# Fill the words list
	with open(file_name, 'r') as f:
		for line in f:
			words += line.lower().split()

	# Filter the hapaxes from the rest
	hapaxes = filter(lambda x: words.count(x) == 1, words)
	
	# Return what we need
	return hapaxes

#test
print hapax('hapax.txt')
