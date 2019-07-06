"""Define a function sum() and a function multiply() that 
sums and multiplies (respectively) all the numbers in a list 
of numbers. For example, sum([1, 2, 3, 4]) should return 10, 
and multiply([1, 2, 3, 4]) should return 24."""

def sum(lst):
  result = 0
  for i in lst:
    result += i
  return result

def multiply(lst):
  result = 1
  for i in lst:
    result *= i
  return result

#test
print sum([1,2,3,4])
print multiply([1,2,3,4])