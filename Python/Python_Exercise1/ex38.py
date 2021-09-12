"""Write a program that will calculate the average word length of a text 
stored in a file (i.e the sum of all the lengths of the word tokens in the 
	text, divided by the number of word tokens)."""

from string import punctuation

def average_word_length(file_name):
	with open(file_name, 'r') as f:
		for line in f:
			# Clean each line of punctuations, we want words only
			line = [x for x in line if x not in punctuation]
			# We get only the length of the words
			words = list(map(len, line.split()))
	print(sum(words) / len(words))

average_word_length('hapax.txt')