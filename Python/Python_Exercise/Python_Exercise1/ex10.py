"""Define a function overlapping() that takes two lists and 
returns True if they have at least one member in common, 
False otherwise. You may use your is_member() function, 
or the in operator, but for the sake of the exercise, 
you should (also) write it using two nested for-loops."""

def overlapping(lst1, lst2):
  for i in lst1:
    for j in lst2:
      if i == j:
        return True
  return False

#test
print overlapping(['nope', 'nothing', 'in'], ['common'])
print overlapping(['this', 'might', 'work'], ['or', 'maybe', 'this'])
print overlapping(['I', 'think', 'I am', 19], ['19', 'kids'])
print overlapping([1,2,3,4,5], [9,8,7,6,5])