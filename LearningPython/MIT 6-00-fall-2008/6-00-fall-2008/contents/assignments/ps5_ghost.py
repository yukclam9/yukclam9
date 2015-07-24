# Problem Set 5: Ghost
# Name: 
# Collaborators: 
# Time: 
#

import random

# -----------------------------------
# Helper code
# (you don't need to understand this helper code)
import string

WORDLIST_FILENAME = "words.txt"

def load_words():
    """
    Returns a list of valid words. Words are strings of lowercase letters.
    
    Depending on the size of the word list, this function may
    take a while to finish.
    """
    print "Loading word list from file..."
    # inFile: file
    inFile = open(WORDLIST_FILENAME, 'r', 0)
    # wordlist: list of strings
    wordlist = []
    for line in inFile:
        wordlist.append(line.strip().lower())
    print "  ", len(wordlist), "words loaded."
    return wordlist

def get_frequency_dict(sequence):
    """
    Returns a dictionary where the keys are elements of the sequence
    and the values are integer counts, for the number of times that
    an element is repeated in the sequence.

    sequence: string or list
    return: dictionary
    """
    # freqs: dictionary (element_type -> int)
    freq = {}
    for x in sequence:
        freq[x] = freq.get(x,0) + 1
    return freq


# (end of helper code)
# -----------------------------------

# Actually load the dictionary of words and point to it with 
# the wordlist variable so that it can be accessed from anywhere
# in the program.


# TO DO: your code begins here!



def check_word(play_word):
    constructible = False
    Pass = True
    if len(play_word ) <= 3 :
        for word in wordlist:
            if play_word == word[0:len(play_word)]:
                constructible = True
                break
        print "constructible:" , constructible
        if constructible == True:
            return constructible
        if constructible == False:
            print " You lose! The game ends"
            return None
    else:
        if play_word in wordlist:
            Pass = False
            print "Pass : ", Pass
            return Pass
        else:
            Pass = True
            print "Pass : ", Pass
            return Pass
        
                
    

def play_game(play_word = "", Round = 0):
    print "Round : ", Round
    letter1 = raw_input(" Player 1's turn: Enter your letter :")
    Valid = False
    Found = False
    if letter1 in string.ascii_letters:
        if play_word == "":
            play_word = letter1
            Valid = True        
        else:
            play_word = play_word + letter1
            Valid = check_word(play_word)    
            print "Word:", play_word
            print "Valid:", Valid
            
        if Valid:
            letter2 = raw_input("Player 2's turn : Enter your letter:")
            if letter2 in string.ascii_letters:
                play_word = play_word + letter2
                print "Word:", play_word
                Valid = check_word(play_word)
                print "Found:", Found
                if len(play_word) <=3:
                    if Valid:
                        Round +=1
                        return play_game(play_word = play_word, Round=Round)
                else:
                    if Valid:
                        Round += 1
                        return  play_game(play_word = play_word,Round=Round)
                        
                        
                    else:
                        print " You lose! the game ends"
                        return start()
            
        else:
            print " You lose! The game ends"
                
         
    else:
        print " please enter an alphabetic character"
        return play_game(play_word = play_word)
        
                
        

def start():
    while True:
        cmd = raw_input("Enter n to start the game, and e to end the game : ")
        if cmd == "n":
            play_game()
        elif cmd == "e":
            break
        else:
            print "Invalid command."

if __name__ == '__main__':
    wordlist = load_words()
    start()
