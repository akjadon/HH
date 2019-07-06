"""Define a procedure histogram() that takes a list of 
integers and prints a histogram to the screen. For example, 
histogram([4, 9, 7]) should print the following:
****
*********
*******
"""

def histogram(lst):
  for n in lst:
    print n * "*"
  print 10 * "-" # Just to add some space between each test

#test
histogram([4,9,7])
histogram([5,6,8])
histogram([10,8,19])