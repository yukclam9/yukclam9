## examine three variables - x,y and z
## and return the largest old number among them


x=4
y=4
z=2

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

	
			
			



# wrong solution to think a bit
# 
# 
# x = 2
# y =4
# z=6
# 
# 
# if x %2 == 1 or y% 2 == 1 or z% 2 == 1 : # if y is not odd number
#     if x < y and x < z:                    # y<x and y<z
#         print x       
#     elif y<z:                              # print y
#         print y                            # However, it is not an odd number!
#     else:
#         print z      
# else:
#     print "None of the numbers are odd"
#     

	

	
			
			
		
		
