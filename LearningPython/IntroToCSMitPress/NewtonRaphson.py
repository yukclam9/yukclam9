# find x such that x**2 - 24 is within epsilon of 0
# which is to find the square root of 24
# any polynominal : ( any degree) written in p(X) = 0 where X are the solutions.
# for any guess you make :
# if you input the guess into guess - ( p(guess) / p'(guess)) 
# where p' is the first derivative of p(X)

epsilon = 0.01
k = 24.0
guess = k / 2.0
while abs(guess*guess - k ) >= epsilon:
	guess = guess - (((guess **2 ) -k ) / ( 2**guess))
print ' the Square root of k is:', guess