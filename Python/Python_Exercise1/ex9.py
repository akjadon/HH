"""Write a function is_member() that takes a value 
i.e. a number, string, etc) x and a list of values a, 
and returns True if x is a member of a, False otherwise. 
(Note that this is exactly what the in operator does, but 
  for the sake of the exercise you should pretend Python 
  did not have this operator.)"""

def is_member(ele, lst):
  for e in lst:
    if ele == e:
      return True
  return False

#test
print is_member("e", ['a', 'e', 'i', 'o', 'u'])
print is_member(19, [1,3,4,6,18,20])
print is_member('right', ['wrong', 'list', 'to', 'search'])
print is_member('panda', ['lion', 'zebra', 'elephant', 'panda'])