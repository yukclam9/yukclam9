# sys is a module
# importing a module
from sys import argv

# argv holds all the arguments we pass to python script while running it
# The below command asks argy to 'unpack' its value  to the 4 variables 
# on the left hand side in-order
script, first, second, third = argv

print " The script is called :", script
print " Your first variable is :", first
print " Your second variable is :", second
print " Your third variable is :" , third

# this exercise has to pass three command line arguments
# python ex13.py and where ( ex13.py ) is an argument.
