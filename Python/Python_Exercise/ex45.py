"""A certain childrens game involves starting with a word in a particular 
category. Each participant in turn says a word, but that word must begin 
with the final letter of the previous word. Once a word has been given, it 
cannot be repeated. If an opponent cannot give a word in the category, they 
fall out of the game. For example, with "animals" as the category,

Child 1: dog 
Child 2: goldfish
Child 1: hippopotamus
Child 2: snake
...
Your task in this exercise is as follows: Take the following selection of 70 
English Pokemon names (extracted from Wikipedia's list of Pokemon) and 
generate the/a sequence with the highest possible number of Pokemon names 
where the subsequent name starts with the final letter of the preceding name. 
No Pokemon name is to be repeated.

audino bagon baltoy banette bidoof braviary bronzor carracosta charmeleon
cresselia croagunk darmanitan deino emboar emolga exeggcute gabite
girafarig gulpin haxorus heatmor heatran ivysaur jellicent jumpluff kangaskhan
kricketune landorus ledyba loudred lumineon lunatone machamp magnezone mamoswine
nosepass petilil pidgeotto pikachu pinsir poliwrath poochyena porygon2
porygonz registeel relicanth remoraid rufflet sableye scolipede scrafty seaking
sealeo silcoon simisear snivy snorlax spoink starly tirtouga trapinch treecko
tyrogue vigoroth vulpix wailord wartortle whismur wingull yamask"""

import re

def poke_names(file_name):
	# Get all the names from the file
	with open(file_name, 'r') as f:
		names = re.findall(r'\w+', f.read())

	# Prepare our lists
	longest_series, current_series = [], []

	# Returns the index of the next word that starts with the last letter
	# of the previous word
	def name_starts_with(lastletter, names):
		for index, name in enumerate(names):
			if name.startswith(lastletter):
				return index
		return False

	# This is where the magic happens
	# For each name in the pokemon names list
	for name in names:
		current_name = name
		current_series.append(current_name) # Add the first name to the series

		namelist = names[:] # Make a copy of the names list
		namelist.pop(namelist.index(current_name)) # Remove the first name from the list

		index = name_starts_with(current_name[-1], namelist) # Get the index of the next name

		# As long as there will be a name that starts with the last letter
		# of the previous word
		while index is not False:
			current_name = namelist[index] # Get this name
			current_series.append(current_name) # Add it to the series
			namelist.pop(index) # Remove it from the list
			index = name_starts_with(current_name[-1], namelist) # Get the position of the next one

		# If the current series... ah, this is pretty self explanatory
		if len(current_series) > len(longest_series):
			longest_series = current_series

		# Empty our current series for the next loop
		current_series = []

	# Print the longest series
	print longest_series

#test
poke_names('poke_names.txt')