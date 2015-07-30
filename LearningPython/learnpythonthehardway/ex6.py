x= " there are %d types of people." % 10
binary = "binary"
do_not = "Don't"
y = " Those who know %s and those who %s. " %( binary, do_not)

print x
print y

# x has bounded with the str " there are....." with 10 already input on it.
# therefore when we use %r with value = x:
# there is a ten with it.


z= " %r %r %r %r"
print z

print "lets test with %r." %x
# where this would return syntax error
#c ould we supply a string to %?
# had tested with parenthesis/ single or double quotes


# hardcoding the value of for %r like below would result in:
# lets test with 'str' 
print " lets test with %r" %'str'
print " I said :%r." %x
print "I alo said: %s'. " %y

hilarious= False
joke_evaluation= "Isn't that joke so funny ?! %r"

print joke_evaluation %hilarious
 
w = "this is the left side of"
e = "a string with  a right side"

# printing with a 'plus' will trigger concatenation and 
# would not include a blank in between
print w + e



