"""Using the higher order function filter(), define a function 
filter_long_words() that takes a list of words and an integer n 
and returns the list of words that are longer than n."""

def filter_long_words(words, n):
  return [x for x in words if len(x) > n]

#test
print(filter_long_words(['that', ' was', 'not', 'funny', 'at', 'all'], 3))