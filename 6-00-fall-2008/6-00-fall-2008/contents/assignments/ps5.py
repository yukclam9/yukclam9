# Problem Set 5: 6.00 Word Game
# Name: 
# Collaborators: 
# Time: 
#

import random
import string
import time
import operator
import copy

VOWELS = 'aeiou'
CONSONANTS = 'bcdfghjklmnpqrstvwxyz'
HAND_SIZE = 15

SCRABBLE_LETTER_VALUES = {
    'a': 1, 'b': 3, 'c': 3, 'd': 2, 'e': 1, 'f': 4, 'g': 2, 'h': 4, 'i': 1, 'j': 8, 'k': 5, 'l': 1, 'm': 3, 'n': 1, 'o': 1, 'p': 3, 'q': 10, 'r': 1, 's': 1, 't': 1, 'u': 1, 'v': 4, 'w': 4, 'x': 8, 'y': 4, 'z': 10
}

points_dict= {}




WORDLIST_FILENAME = "words.txt"

def load_words(wordlist = WORDLIST_FILENAME):
    
    print "Loading word list from file..."
    inFile = open(wordlist, 'r', 0)
    wordlist = []
    for line in inFile:
        wordlist.append(line.strip().lower())
    print "  ", len(wordlist), "words loaded."
    return wordlist

def get_frequency_dict(sequence):
 
    # freqs: dictionary (element_type -> int)
    freq = {}
    for x in sequence:
        freq[x] = freq.get(x,0) + 1
    return freq


def get_words_to_points(wordlist):
    for row in word_list:
        points_dict[row] =  get_word_score(row,HAND_SIZE)
    return points_dict

def get_word_score(word, n):
    
    
    score = 0
    if len(word) >0 :
        booking = get_frequency_dict(word)
        for key in booking:
            for charKey in SCRABBLE_LETTER_VALUES:
                if key == charKey:
                    score = score +  SCRABBLE_LETTER_VALUES[charKey] * booking[key]
                    break
        if len(word) == 7:
            score = score + 50
    else:
        return score
    return score
            


def display_hand(hand):
 
    for letter in hand.keys():
        for j in range(hand[letter]):
            print letter,              
    print                              

def deal_hand(n):
   
    hand={}
    num_vowels = n / 3
    
    for i in range(num_vowels):
        x = VOWELS[random.randrange(0,len(VOWELS))]
        hand[x] = hand.get(x, 0) + 1
        
    for i in range(num_vowels, n):    
        x = CONSONANTS[random.randrange(0,len(CONSONANTS))]
        hand[x] = hand.get(x, 0) + 1
        
    return hand



def update_hand(hand, word):
    
   
    if word != ".":
        for char in word:
            if char in hand:
                if hand[char] >1 :
                    hand[char]= hand[char]-1
                else:
                    hand.pop(char,None)
                print " you used the letter:", char, "and its value is : ",  SCRABBLE_LETTER_VALUES[char]
            else: pass    
    else:
        return hand       
    return hand
                
            


def is_valid_word(word, hand, word_list  = WORDLIST_FILENAME):
 

    Valid = True
    if word in load_words(word_list):
        for char in word:
            if char not in hand:
                Valid = False
    else:
        Valid = False
    if Valid:
        return Valid
   
                


def pick_best_word( handlist, wordlistScore = points_dict):
    pick_word=""
    result_dict= {}
    test_list= []
    
    print len(points_dict)
    for key in points_dict:
        test_list=copy.copy(handlist)
        flag = True
        for letter in key:
            if letter not in test_list:
                flag = False
                break
            else:
                test_list.remove(letter)
        if flag :
            result_dict[key]=points_dict[key]
    if len(result_dict) < 1 :
        return "."
    else:
        pick_word = max(result_dict.iteritems(), key=operator.itemgetter(1))[0]
        return pick_word               
        


def play_hand(hand, word_list = WORDLIST_FILENAME, score =0 , gamingTime = 30):
    
    hand_list= []
    for key in hand:
        for i in range(hand[key]):
            hand_list.append(key)
    print hand_list
            
    display_hand(hand)
    start_time=time.time()
    word = pick_best_word(hand_list) 
    end_time=time.time()
    total_time= end_time - start_time
    Remained_time= gamingTime - total_time
    
    
    print "You take %s to enter the value : "%total_time,  word
    print " You have %d second remaining " %Remained_time
    if Remained_time <= 0:
        print "  The game is done. Your score:", score
        return None
    if word != ".":
        if is_valid_word(word, hand) :
            score += get_word_score(word, HAND_SIZE)
            hand=update_hand(hand, word)
        else:
            print " Invalid word! Please type it again "
            return play_hand(hand,score=score)
    else:
        print " The game is done. Your score: ", score
        return None
    print "Your current score is ", score
    print "Your remained hand : ", hand
    return play_hand( hand , word_list=WORDLIST_FILENAME, score=score)


def play_game(word_list=WORDLIST_FILENAME):
   
    hand = deal_hand(HAND_SIZE) # random init
    while True:
        cmd = raw_input('Enter n to deal a new hand, r to replay the last hand, or e to end game: ')
        if cmd == 'n':
            hand = deal_hand(HAND_SIZE)
            play_hand(hand.copy(), word_list)
            print
        elif cmd == 'r':
            play_hand(hand.copy(), word_list)
            print
        elif cmd == 'e':
            break
        else:
            print "Invalid command."

        

#
# Build data structures used for entire session and play game
#
if __name__ == '__main__':
    word_list = load_words()
    get_words_to_points(word_list)
    play_game(word_list)

