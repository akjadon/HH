"""An alternade is a word in which its letters, taken alternatively in a 
strict sequence, and used in the same order as the original word, make up at 
least two other words. All letters must be used, but the smaller words are not 
necessarily of the same length. For example, a word with seven letters where 
every second letter is used will produce a four-letter word and a three-letter 
word. Here are two examples:

  "board": makes "bad" and "or".
  "waists": makes "wit" and "ass".
Using the word list at http://www.puzzlers.org/pub/wordlists/unixdict.txt, 
write a program that goes through each word in the list and tries to make two 
smaller words using every second letter. The smaller words must also be members 
of the list. Print the words to the screen in the above fashion."""

import re
from collections import defaultdict

# I'm still not sure if this is the best solution.
# But I think it does what the problem asks for :/
# But my, my, my, it takes around 2 minutes to finish building.
# Please, help!
def alternade_finder(file_name):
	# Get our words
	with open(file_name, 'r') as f:
		words = re.findall(r'\w+', f.read())

	# Prepare our dictionary
	foundalternades = defaultdict(list)

	# For each word in the list
	for word in words:
		# We make a copy of the words list and prepare our variables
		wordlist, smallerwordeven, smallerwordodd = words[:], '', ''
		# We remove the word from the list so it doesn't choose itself
		# as an alternade
		wordlist.remove(word)

		# We only do that for words that are longer than 1 letter
		if len(word) > 1:
			for letters in word: # For each letter in the word
				# Get the position of this letter
				letter_pos = word.index(letters)

				# If the letter is at an even position
				if letter_pos % 2 == 0:
					smallerwordeven += letters # Add this letter to the variable
					# If the smaller word is in the words list and is not yet
					# in the dictionary for the current word, add it to the dict
					if smallerwordeven in wordlist and \
					smallerwordeven not in foundalternades[word]:
						foundalternades[word].append(smallerwordeven)

				# If the letter is at an odd position
				if letter_pos % 2 != 0:
					smallerwordodd += letters # Add this letter to the variable
					# If the smaller word is in the words list and is not yet
					# in the dictionary for the current word, add it to the dict
					if smallerwordodd in wordlist and \
					smallerwordodd not in foundalternades[word]:
						foundalternades[word].append(smallerwordodd)

	# For each word in the dictionary
	for word, alternades in foundalternades.items():
		# Make a string out of all the alternades
		alt = reduce(lambda x, y: x + y, alternades)
		# If all the letters in the word have been used to create all
		# the alternades, print this word and its alternades
		if sorted(alt) == sorted(word):
			print '"%s": makes %s' % (word, alternades)

#test
alternade_finder('unixdict.txt')