"""Write a program that maps a list of words into a list of integers 
representing the lengths of the correponding words. Write it in three 
different ways: 1) using a for-loop, 2) using the higher order function 
map(), and 3) using list comprehensions."""

# Using a for-loop
def words_length_one(words):
  wordsLength = []
  for word in words:
    wordsLength.append(len(word))
  return wordsLength

# Using the higher order function map()
def words_length_two(words):
  return map(len, words)
  
#  Using list comprehensions
def words_length_three(words):
  return [len(word) for word in words]

#test
print words_length_one(['lol', 'this', 'is', 'funny'])
print words_length_two(['lol', 'this', 'is', 'NOT', 'funny'])
print words_length_three(['or', 'is', 'it', '?'])