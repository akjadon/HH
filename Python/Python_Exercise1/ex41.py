"""In a game of Lingo, there is a hidden word, five characters long. 
The object of the game is to find this word by guessing, and in return 
receive two kinds of clues: 1) the characters that are fully correct, with 
respect to identity as well as to position, and 2) the characters that are 
indeed present in the word, but which are placed in the wrong position. 
Write a program with which one can play Lingo. Use square brackets to 
mark characters correct in the sense of 1), and ordinary parentheses to 
mark characters correct in the sense of 2). Assuming, for example, that 
the program conceals the word "tiger", you should be able to interact with 
it in the following way:

>>> import lingo
snake
Clue: snak(e)
fiest
Clue: f[i](e)s(t)
times
Clue: [t][i]m[e]s
tiger
Clue: [t][i][g][e][r]"""


from random import randrange

def lingo(words):
    # Choose a word from the list randomly
    hidden = words[randrange(0, len(words))]

    # Map to build clue
    sym_map = {0: "%s", 1:"(%s)", 2: "[%s]"}
    def lingo_finder(guess):
        # 0: letter not present in the hidden word
        # 1: letter present but position is wrong
        # 2: correct letter and position
        cenc = [(int(guess[i] == hidden[i])) + int(guess[i] in hidden) for i in range(5)] 
        # Enclose the letter with appropriate symbols using sym_map
        print "".join([sym_map[cenc[i]]%guess[i] for i in range(5)])
        return hidden != guess
        print

    if len(hidden) == 5:
        is_wrong=True
        # Until guess is right
        while is_wrong:
            # If user provides a word longer than 5 characters, we
            # truncate it
            guess = raw_input()[:5]
            is_wrong = lingo_finder(guess.lower())
        print "You guessed it!"


# Test
lingo(['alley', 'tally', 'valet', 'tiger', 'house', 'cigar', 'opera', 'modem', 'horse', 'plane', 'white', 'fiery'])
