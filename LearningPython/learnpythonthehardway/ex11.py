# a commma to continue the print statement even when you type at the next line
# int(raw_input()) get a integer value
# default = string value
print " how old are you?",
age = raw_input()
print "how tall are you",
height = raw_input()
print "How much do you weight ",
weight = raw_input()
print " now test with input: my age " ,
testwithinput1 = input()
#try again wif symbol :
print " the value return for the input is",
testwithinput2 = input()



# keep one line of code less than 80 characters
# to further confirm previous exercise
# using %s % would return a string value without a quote for print statement
# while using %r % would include the quotes
# of whichever type of quotes you used to enclose the string
# %r would add a quote on top of yours that is in different type
# not comma is allowed between the string and its %
print " So you are %r old, %r tall and %r heavy. " %( age, height, weight)

# input() would not add a quote string ( single or double) to the printing statement for 
# its %
print " so how about my test 1: %s 2: %s" %( testwithinput1, testwithinput2)


# Interesting example:
# when you add the escaping character : backslash
# the system would add a backslash to escape its escaping function.
# how old are you? '\'
# how tall are you '\'
# How much do you weight  '\'
# now test with input: my age  'a'
# the value return for the input is 'c'
# So you are "'\\'" old, "'\\'" tall and "'\\'" heavy. 

print " now test with input: my age " ,
testwithinput1 = input()

# input() <- could not input a backslash and a blank
# would cause SyntaxError : unexpected EOL while parsing



