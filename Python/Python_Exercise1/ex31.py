"""Implement the higher order functions map(), filter() and reduce(). 
(They are built-in but writing them yourself may be a good exercise.)"""
from functools import reduce

# My solutions are based on the definitions from the python help function
# >> help('map')
# >> help('filter')
# >> help('reduce')
# See for yourself.
# map() implementation. I know I didn't fully implement it because it would 
# be kinda long, but that's the basic
def map(function, sequence):
  result = []
  for item in sequence:
    result.append(function(item))
  return result

# filter() implementation  
def filter(function, sequence):
  # If sequence is a tuple or string, return the same type, 
  # else return a list.
  if isinstance(sequence, tuple):
    result = ()
  elif isinstance(sequence, str):
    result = ''
  else:
    result = []
    
  for item in sequence:
    if function(item):
      # Add the item according to the type of sequence
      if isinstance(sequence, tuple):
        result += (item,)
      elif isinstance(sequence, str):
        result += item
      else:
        result.append(item)
  return result

# reduce() implementation
def reduce(function, sequence, initial=None):
  # Set result to the initial number if initial is set, else, set it to the 
  # first element.
  result = initial if initial else sequence[0]
  if initial:
    for item in sequence:
      result = function(result, item)
  else:
    for item in sequence[1:]:
      result = function(result, item)
  return result

#test
print([x * 2 for x in [1,2,3,4]])
print([x for x in ('lapin', 'cretin', 'ah', 'oui') if x.endswith('in')])
print(reduce(lambda x, y: x+y, [1, 2, 3, 4, 5], 5))