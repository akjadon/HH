"""Represent a small bilingual lexicon as a Python dictionary in the 
following fashion {"merry":"god", "christmas":"jul", "and":"och", 
"happy":gott", "new":"nytt", "year":"ar"} and use it to translate 
your Christmas cards from English into Swedish. That is, write a 
function translate() that takes a list of English words and returns 
a list of Swedish words."""

dictionary = {"merry":"god", "christmas":"jul", "and":"och", 
"happy":"gott", "new":"nytt", "year":"ar"}

def translate(lst):
  return [dictionary[w.lower()] for w in lst if w.lower() in dictionary]

#test
print translate(['Merry', 'christmas', 'and', 'happy', 'new', 'year', 'mom'])