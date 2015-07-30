request= int(raw_input('Enter an interger'))
root = 0
pwr  = 0

while root**pwr < request :
	pwr = pwr + 1
	if pwr == 5:
		root = root + 1
		pwr  = 0
if root**pwr == request:
	print ' it is obtained by:', root , ' to the power of:', pwr
else:
	print ' there aint a legitimate combination of the two numbers.'	