"""Define a function max_of_three() that takes three 
numbers as arguments and returns the largest of them."""

def max_of_three(num1, num2, num3):
  if num1 > num2 > num3:
    return num1
  elif num1 < num2 < num3:
    return num3
  else: return num2

#test
print max_of_three(2, 3, 4)
print max_of_three(4, 3, 2)
print max_of_three(2, 4, 3)