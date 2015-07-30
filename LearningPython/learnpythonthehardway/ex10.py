# \t does the tab function in python
tabby_cat = "\tI'm tabbed in."
persian_cat = "I'm split\non a line."
# \ would not cause anything, and \\ would
# escape the later \
backslash_cat = "I'm \\ a \\ cat."

# tab appears at any place

# would skip a line if the string starts at another line
# after """
# = """
#stringstringstring
#stringstringstring
#"""


# \ escaping another type of quote
# quote(s) within quotes that have the same type
# would confuse the system
# mistakenly end the string

teststringa = " I am 6'2\" tall."
teststringb = ' I am 6\'2" tall. '
# try remove the \
# the string would change in colour immediately
# ' I am 6'2" tall. '




fat_cat = """
I'll do a list:
\t* Cat food
\t* Fishies
\t* Catnip\n\t* Grass
"""

print tabby_cat
print persian_cat
print backslash_cat
print fat_cat