"""Write a version of a palindrome recogniser that accepts a file name 
from the user, reads each line, and prints the line to the screen if it 
is a palindrome."""
 
import string

file_name = input('Enter the file name (ex. palindromes.txt)> ')
unwanted = string.punctuation + ' '

def is_palindrome(str):
  # Remove the unwanted chars
  new_str = [x for x in str.lower() if x not in unwanted]
  if new_str == new_str[::-1]:
    return True

with open(file_name, 'r') as f:
  for line in f:
    # Here I used rstrip to remove the newline (\n) at the end of the line
    if is_palindrome(line.rstrip()):
      print(line.rstrip())