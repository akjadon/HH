"""Write a function translate() that will translate a text 
into "rovarspraket" (Swedish for "robber's language"). 
That is, double every consonant and place an occurrence 
of "o" in between. For example, translate("this is fun") 
should return the string "tothohisos isos fofunon"."""

import string

all_letters = string.ascii_letters
vowels = ['a','e', 'i', 'o', 'u']
consonants = [chr for chr in all_letters if chr not in vowels]

def robberlang(str):
  result = ""
  for c in str:
    if c.lower() in consonants:
      result += c+'o'+c
    else:
      result += c
  return result

#test
print robberlang("This is kinda fun")
print robberlang("I Think YoU Might BE righT!")