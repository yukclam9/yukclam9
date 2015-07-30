s = '1.23,2.4,3.123'
sum =  float()
DecNumber = str()
position = 0 # keep track of where the iteration up to

for digit in s:
	if digit != ',' and position != len(s) -2:
		DecNumber = DecNumber + digit
		position = position + 1
# my mistakes:
# fail to consider the end of the string i.e. without a ',', it would not perform addition
# if either levels(top branches) of the conditionals are executed, the remained level(s) would not 
# not be executed 
# i.e. if a: elif b: elif c < - if a is executed, b,c would not be executed ( at least
# for the current iteration.

	if digit == ',' or position == len(s) -2:
		sum = sum + float(DecNumber)
		DecNumber=str()
print sum

	
	


