formatter = "%r %r %r %r"

print formatter
print formatter %(1,2,3,4)
print formatter %("one", "two", "three","four")
print formatter %(True, False, True, False)
print formatter %( 'I had this thing.', "that you could type",
				" but it did not sing. ", "So I said goodnight."
				)
				
# when there is a quote-in-different-level within the bounding quote at variable string
# %r %() would return the value of string as "value"  
# else: 'value' ( translation of double quote to single quote).
# where single quote remain unchanged.


print formatter %( "I had this thing.", "that you could type",
				'but it didn"t sing. ', "So I said goodnight."
				)