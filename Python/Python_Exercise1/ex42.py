"""A sentence splitter is a program capable of splitting a text into 
sentences. The standard set of heuristics for sentence splitting includes 
(but isn't limited to) the following rules:

Sentence boundaries occur at one of "." (periods), "?" or "!", except that

Periods followed by whitespace followed by a lower case letter are not 
sentence boundaries. 
Periods followed by a digit with no intervening whitespace are not sentence 
boundaries. 
Periods followed by whitespace and then an upper case letter, but preceded 
by any of a short list of titles are not sentence boundaries. Sample titles 
include Mr., Mrs., Dr., and so on. 
Periods internal to a sequence of letters with no adjacent whitespace are 
not sentence boundaries (for example, www.aptex.com, or e.g). 
Periods followed by certain kinds of punctuation (notably comma and more 
periods) are probably not sentence boundaries. 
Your task here is to write a program that given the name of a text file is 
able to write its content with each sentence on a separate line. Test your 
program with the following short text: 
Mr. Smith bought cheapsite.com for 1.5 million dollars, i.e. he paid 
a lot for it. Did he mind? Adam Jones Jr. thinks he didn't. In any case, 
this isn't true... Well, with a probability of .9 it isn't. The result 
should be:

Mr. Smith bought cheapsite.com for 1.5 million dollars, i.e. he paid a lot 
for it.
Did he mind??
Adam Jones Jr. thinks he didn't.
In any case, this isn't true...
Well, with a probability of .9 it isn't."""

import re

def sentence_splitter(file_name):
	with open(file_name, 'r') as f:
		file_content = f.read()

	# We first remove the newlines that were already there
	sentences = re.sub(r'\n', '', file_content)

	# Now we add a newline after each period only if that period is not
	# preceded by 'Mr', 'Mrs' or 'Dr' and is followed by a space and an
	# uppercase letter
	sentences = re.sub(r'(?<!Mr)(?<!Mrs)(?<!Dr)\.\s([A-Z])', r'.\n\1', sentences)

 	# Then we do the same after every '!'
 	sentences = re.sub(r'!\s', '!\n', sentences)

 	# Finally, we do the same after every '?'
 	sentences = re.sub(r'\?\s', '?\n', sentences)

	print sentences

#test
sentence_splitter('splitter.txt')

