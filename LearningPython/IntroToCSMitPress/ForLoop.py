x = 4

for i in range(0,x):
# for literal generated at the range function only evaluates at the first iteration.
# see 1a
	for j in range(0,x):
# however, the for j loop is evaluated again every time i value is incremented.
# therefore, the j - literals created for i=1,2,3 is [0,1] i.e. range(2)
		print j
		x = 2

#return answer : 0123010101

# 1a
# x = 4
# for i in range( 0,x):
# 	print i
# 	x = 2
# rebounding x to a value of 2 would no affect i's value for the For loop
