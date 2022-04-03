"""Write a function char_freq() that takes a string and builds 
a frequency listing of the characters contained in it. Represent 
the frequency listing as a Python dictionary. Try it with something 
like char_freq("abbabcbdbabdbdbabababcbcbab")."""

def char_freq(str):
  freq = {}
  for c in str:
    if c in freq:
      freq[c] += 1
    else:
      freq[c] = 1
  return freq
      

#test
print char_freq("abbabcbdbabdbdbabababcbcbab")
print char_freq("hello")