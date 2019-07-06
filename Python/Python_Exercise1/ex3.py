"""Define a function that computes the length of a 
given list or string. (It is true that Python has 
the len() function built in, but writing it yourself 
is nevertheless a good exercise.)"""

def length(str):
  count = 0
  for i in str:
    count += 1
  return count

#test
print length("Hello, world!")
print length("Nick was here.")
print length("Cool")