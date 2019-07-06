"""The International Civil Aviation Organization (ICAO) alphabet assigns 
code words to the letters of the English alphabet acrophonically 
(Alfa for A, Bravo for B, etc.) so that critical combinations of letters 
(and numbers) can be pronounced and understood by those who transmit and 
receive voice messages by radio or telephone regardless of their native 
language, especially when the safety of navigation or persons is essential. 
Here is a Python dictionary covering one version of the ICAO alphabet:

d = {'a':'alfa', 'b':'bravo', 'c':'charlie', 'd':'delta', 'e':'echo', 
	 'f':'foxtrot', 'g':'golf', 'h':'hotel', 'i':'india', 'j':'juliett', 
	 'k':'kilo', 'l':'lima', 'm':'mike', 'n':'november', 'o':'oscar', 
	 'p':'papa', 'q':'quebec', 'r':'romeo', 's':'sierra', 't':'tango', 
	 'u':'uniform', 'v':'victor', 'w':'whiskey', 'x':'x-ray', 'y':'yankee', 
	 'z':'zulu'}
Your task in this exercise is to write a procedure speak_ICAO() able to 
translate any text (i.e. any string) into spoken ICAO words. You need to 
import at least two libraries: os and time. On a mac, you have access to 
the system TTS (Text-To-Speech) as follows: os.system('say ' + msg), where 
msg is the string to be spoken. (Under UNIX/Linux and Windows, something 
	similar might exist.) Apart from the text to be spoken, your procedure 
also needs to accept two additional parameters: a float indicating the 
length of the pause between each spoken ICAO word, and a float indicating 
the length of the pause between each word spoken."""

import time, os
from string import punctuation

d = {'a':'alfa', 'b':'bravo', 'c':'charlie', 'd':'delta', 'e':'echo', 
	 'f':'foxtrot', 'g':'golf', 'h':'hotel', 'i':'india', 'j':'juliett', 
	 'k':'kilo', 'l':'lima', 'm':'mike', 'n':'november', 'o':'oscar', 
	 'p':'papa', 'q':'quebec', 'r':'romeo', 's':'sierra', 't':'tango', 
	 'u':'uniform', 'v':'victor', 'w':'whiskey', 'x':'x-ray', 'y':'yankee', 
	 'z':'zulu'}

def icao(txt, icao_pause=1, word_pause=3):
	words = txt.split() # Take each word from provided string

	for word in words: # For every word in the provided string
		for char in word: # For every character in the word
			if char not in punctuation: # If this character is not a punctuation. Do our business
				os.system('say ' + d[char.lower()])
				time.sleep(icao_pause) # The wait time after every letter
		time.sleep(word_pause) # The wait time after every word

#test
icao("Hello world, hi, I'm Nick!", 0.10, 1)
icao("The quick brown Fox jumps over the laZy Dog!")