import re
import csv

##class lookup:
##
##    def test ( self, datafile):    
##        reader = open(datafile,"rb")
##        self.data = []
##        for row in reader.readlines():
##            regrex= "([\w+]+)"
##            linearray = re.compile(regrex).findall(row)
##            for position, item in enumerate(linearray):
##                if item == [0]:
##                    self.data.append[ linearray[0:position]]
##                    self.data.append[ position : len(linearray)]
##        self.size = len(self.data) /2

class export:
        
	def __init__ (self, datafile):
		reader = open(datafile,"rb")
		concat_NoandName=""
		self.from_list = []
		self.to_list=[]
		for row in reader.readlines():
			regrex= "([\w+]+)"
			linearray = re.compile(regrex).findall(row)
			for position,item in enumerate(linearray):
				if item == '0':
					self.from_list.append(linearray[0:position])
					self.to_list.append(linearray[position +1  : len(linearray)-1])

		self.lookup={}
		table=open("mapping01.csv", "rb")
		table_name = csv.reader(table)
		outtable = list(table_name)

		for each in outtable:
			concat_NoandName = str(each[0]) + ":" + str(each[1])
			self.lookup[each[0]]= concat_NoandName 
		return None

	def look_up ( self,output="output3.txt"):
		Result= []
		size=len(self.from_list)
		for i in range(size):
			for key in self.lookup:
				for j in range(len(self.from_list[i])):
					if self.from_list[i][j]==key:
						self.from_list[i][j]=self.lookup[key]
				for k in range(len(self.to_list[i])):
					if self.to_list[i][k]==key:
						self.to_list[i][k]=self.lookup[key]
			Result.append( str(self.from_list[i]) + "-> " + str(self.to_list[i])) 


		text=open(output, 'w')
		for i in range(len(Result)):
			text.write(str(Result[i])+ "\n" )

    
  




        
        
            
            
    
                        
                        
                
           
