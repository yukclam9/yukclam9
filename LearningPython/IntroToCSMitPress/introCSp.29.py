#find cubic root

x= -27.00
high =max(1.00,x)
low = min(0.00,x)
ans = (high+low)/2.00
epsilon = 0.01

#mid point is calculated as ( x + y ) /2 ( averaging them)
# not ( x-y) /2 <- this is finding 1/2 of their difference ( 10 -5 ) /2 = 2.5
# while ( x + y ) /2 is finding the mid point between two numbers  (10 + 5) / 2 = 7.5
while abs(ans**3 - x) >= epsilon:
	if ans**3 - x > 0:
		high = ans
	else:
		low = ans
	ans = (high+low)/2.00
		
	print 'the approximated cubic root of' , x, 'is :', ans

	
	

