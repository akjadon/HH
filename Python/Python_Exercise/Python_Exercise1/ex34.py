"""Write a procedure char_freq_table() that, when run in a terminal, 
accepts a file name from the user, builds a frequency listing of the 
characters contained in the file, and prints a sorted and nicely formatted 
character frequency table to the screen."""

def char_freq_table(file_name):
  freq = {}
  with open(file_name, 'r') as f:
    # We make sure to remove spaces and newlines or they will be
    # counted too.
    str = filter(lambda x: x not in [' ','\n'], f.read())

    # Then we fill the dictionary with each character and their frequency
    for c in str:
      if c in freq:
        freq[c] += 1
      else:
        freq[c] = 1

    # Now we display each character with their frequency 
    # (in descending order)
    print 'Characters frequency listing:'
    for char in sorted(freq.items(), key=lambda x: x[1], reverse=True):
      print char[0], freq[char[0]]

#test
file_name = raw_input('Enter file name (ex. poem.txt)> ')
char_freq_table(file_name)