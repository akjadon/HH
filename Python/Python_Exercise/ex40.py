"""An anagram is a type of word play, the result of rearranging the letters
of a word or phrase to produce a new word or phrase, using all the original 
letters exactly once; e.g., orchestra = carthorse, A decimal point = I'm 
a dot in place. Write a Python program that, when started 1) randomly 
picks a word w from given list of words, 2) randomly permutes w (thus 
creating an anagram of w), 3) presents the anagram to the user, and 4) 
enters an interactive loop in which the user is invited to guess the 
original word. It may be a good idea to work with (say) colour words 
only. The interaction with the program may look like so:

>>> import anagram
Colour word anagram: onwbr
Guess the colour word!
black
Guess the colour word!
brown
Correct!"""

from random import randrange

def anagram(word_list, subject):
	# Choose a random word from the provided list
	w = word_list[randrange(0, len(word_list))]
	ana = ''

	# Create our anagram
	# This won't end until the anagram is the same length as the word
	while len(ana) < len(w):
		char = w[randrange(0, len(w))] # Choose a random letter
		
		if char not in ana: # If the letter isn't in the anagram yet
			# Insert it in the anagram the number of times it is found in the word
			for x in range(w.count(char)):
				ana += char
		if ana == w: # This is to make sure the anagram is never the same as the word
			continue

	# The game
	print '%s word anagram: %s' % (subject.capitalize(), ana)
	while True:
		print 'Guess the %s word!' % subject
		guess = raw_input()
		if guess == w:
			print 'Correct!'
			break

#test
anagram(['brown','yellow', 'green', 'red', 'blue'], 'colour')
anagram(['Haiti','USA', 'France', 'Spain', 'China'], 'country')