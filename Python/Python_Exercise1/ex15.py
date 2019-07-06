""" Write a function find_longest_word() that takes 
a list of words and returns the length of the longest one."""

def find_longest_word(lst):
  longest = ""
  for w in lst:
    if len(w) > len(longest):
      longest = w
  return len(longest)

#test
print find_longest_word(['hello', 'world', 'Python'])
print find_longest_word(['Live', 'laugh', 'love'])
print find_longest_word(['I', 'found', 'Haiti'])