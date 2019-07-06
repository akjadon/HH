"""Using the higher order function reduce(), write a function max_in_list() 
that takes a list of numbers and returns the largest one. Then ask yourself:
why define and call a new function, when I can just as well call the reduce() 
function directly?"""

def max_in_list(lst):
  return reduce(lambda x, y: x if x > y else y, lst)

#test
print max_in_list([1,2,3,4,5,6,10,3])