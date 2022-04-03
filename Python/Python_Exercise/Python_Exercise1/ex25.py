"""In English, the present participle is formed by adding the suffix -ing 
to the infinite form: go -> going. A simple set of heuristic rules can be 
given as follows:

If the verb ends in e, drop the e and add ing (if not exception: be, see, 
  flee, knee, etc.)
If the verb ends in ie, change ie to y and add ing
For words consisting of consonant-vowel-consonant, double the final letter 
before adding ing
By default just add ing
Your task in this exercise is to define a function make_ing_form() which 
given a verb in infinitive form returns its present participle form. Test 
your function with words such as lie, see, move and hug. However, you must 
not expect such simple rules to work for all cases."""

vowels = 'aeiou'
def make_ing_form(verb):
  if verb.endswith('ie'):
    return verb[:-2]+'ying'
  elif verb.endswith('e'):
    return verb[:-1]+'ing'
  elif verb[-3] not in vowels:
    if verb[-2] in vowels:
      if verb[-1] not in vowels:
        return verb+verb[-1]+'ing'
  else:
    return verb+'ing' 

#test
print make_ing_form('lie')
print make_ing_form('see') # I know. Doesn't work. It's an exception
print make_ing_form('move')
print make_ing_form('hug')
print make_ing_form('touch')
