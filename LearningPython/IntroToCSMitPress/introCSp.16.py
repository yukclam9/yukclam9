x = 4
y = 9 
z = 6
if x%2 ==0 and y%2 ==0 and z%2 ==0:
	print 'None of them are odd number'
elif x%2 != 0:
	if x > y and x > z:
		print 'The largest odd number is',x
	elif y%2 != 0 and y > z and y > x:
		print 'The largest odd number is',y
	elif z%2 != 0:
		print 'The largest odd number is',z
	else:
		print 'The largest odd number is',x
else:
	if y%2 !=0 and y > z:
		print 'The largest odd number is',y
	elif z%2 != 0: 
		print 'The largest odd number is',z
	else:
		print 'The largest odd number is',y