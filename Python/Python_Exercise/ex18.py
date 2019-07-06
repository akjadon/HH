"""A pangram is a sentence that contains all the letters 
of the English alphabet at least once, for example: The 
quick brown fox jumps over the lazy dog. Your task here is 
to write a function to check a sentence to see if it is a 
pangram or not."""

import string

alpha = string.ascii_lowercase

def is_pangram(str):
  found = []
  for c in str.lower():
    if c in alpha and c not in found:
      found.append(c)
  if len(found) == len(alpha):
    return True
  else:
    return False

#test
print is_pangram("The quick brown fox jumps over the lazy dog.")
print is_pangram("Obviously not a pangram")