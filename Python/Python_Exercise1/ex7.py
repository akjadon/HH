"""Define a function reverse() that computes the reversal 
of a string. For example, reverse("I am testing") should 
return the string "gnitset ma I"."""

def reverse(str):
  return str[::-1]

#test
print reverse("I am testing")
print reverse("It's cool, isn't it?")