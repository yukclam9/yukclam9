# coding=UTF-8
import copy
import re
import time
import csv
import os

class Item:
    elements=[]
    supp=0.0
    def __init__(self,elements,supp=0.0):
        self.elements = elements
        self.supp = supp
    def __str__(self):
        returnstr = '[ '
        for e in self.elements:
            returnstr += e+','
        returnstr+=' ]'+' (support :%.3f)\t' %(self.supp)
        return returnstr
    def getSubset(self,k,size):
        subset=[]
        if k == 1:
            for i in range(size):
                subset.append([self.elements[i]])
            return subset
        else:
            i = size - 1
            while i >= k-1 :
                myset = self.getSubset(k-1,i)
                j = 0
                while j < len(myset):

                    myset[j] +=  [self.elements[i]]
                    j += 1
                subset += (myset)
                i -= 1
            return subset

    def lastDiff(self,items):
        length = len(self.elements)
        if length != len(items.elements):
            return False
        if self.elements == items:
            return False
        return self.elements[0:length-1] == items.elements[0:length-1]
    def setSupport(self,supp):
        self.supp = supp

    def join(self,items):
        temp = copy.copy(self.elements)
        temp.insert(len(self.elements), items.elements[len(items.elements) - 1])
        it = Item(temp,0.0)
        return it

class C:
    '''candidate '''
    elements=[]
    k = 0 #order
    def __init__(self,elements,k):
        self.elements = elements
        self.k = k

    def isEmpty(self):
        if len(self.elements) == 0:
            return True
        return False
    #get the same order of itemsets whose support is at lease the threshold
    def getL(self,threshold):
        items=[]
        for item in self.elements:
            if item.supp >= threshold:
                items.append(copy.copy(item))
        if len(items) == 0:
            return L([],self.k)
        return L(copy.deepcopy(items),self.k)

    def __str__(self):
        returnstr = str(self.k)+'-itemset:'+str(len(self.elements))+' \r\n{ '
        for e in self.elements:
            if True == isinstance(e,Item):
                returnstr += e.__str__()
        returnstr +=' }'
        return returnstr

class L:
    '''store all the  1-itemsets,2-itemsets,...k-itemsets'''
    items=[] #all the item in order K
    k=0
    def __init__(self,items,k):
        self.items = items
        self.k = k
    def has_inFrequentItemsets(self,item):
        subs = item.getSubset(self.k, len(item.elements))
        for each in subs:
            flag=False
            for i in self.items:
                if i.elements==each:
                    flag=True
                    break
            if flag==False:

                return True
        return False

    def aprioriGen(self):
        length=len(self.items)
        result=[]
        for i in range(length):
            for j in range(i+1,length):
                if self.items[i].lastDiff(self.items[j]):
                    item = self.items[i].join(self.items[j])
                    if False == self.has_inFrequentItemsets(item):
                        result.append(item)
        if(len(result) == 0):
            return C([],self.k+1)
        return C(result,self.k+1)

    def __str__(self):
        returnstr="\r\n"+str(self.k) + '-itemsets :'+str(len(self.items))+"\r\n{"
        for item in self.items:
            returnstr += item.__str__()
        returnstr += '}'
        return returnstr

class LS:
    '''store from 1-itemset to k-itemset'''
    values={}#L1,L2,Lk
    def get(self,k):
        return self.values[k]
    def size(self):
        return len(self.values)
    def put(self,l,k):
        self.values[k]=l
    def isEmpty(self):
        return self.size()==0
    def __str__(self):
        returnstr = '-----result--------\r\n'
        for l in self.values:
            returnstr += self.values[l].__str__()
        return returnstr
class Rule:
    confidence=.0
    str_rule=''
    def __init__(self,confidence,str_rule):
        self.confidence = confidence
        self.str_rule = str_rule
    def __str__(self):
        return self.str_rule

class Apriori:
    def __init__(self,min_supp,datafile , directory ):
        self.data=[]
        self.size=0
        self.directory=directory
        os.chdir(self.directory)
        self.min_supp = min_supp
        reader = open(datafile,"rb")
        inputfile = open(datafile,"r")
        for row in reader.readlines():
            regrex= "(\w+)"
            linearray = re.compile(regrex).findall(row)
            self.data.append(linearray)

        self.size=len(self.data)

    def  findFrequent1Itemsets(self):
        totalItemsets=[]
        for temp in self.data:
            totalItemsets.extend(temp)
        items = []

        while len(totalItemsets)>0:
            item=totalItemsets[0]
            count=0
            j=0
            while j<len(totalItemsets):
                if (item == totalItemsets[j]) :
                    count += 1
                    totalItemsets.remove(item)
                else:
                    j += 1
            t_supp = count*1.0/self.size

            if t_supp >= self.min_supp:
                items.append(Item([item],t_supp))

        temp = L(copy.deepcopy(items),1)
        return   temp

    def ralationRules(self,min_confidence):
        ruls=[]
        ruls2=[]
        k = 1 #order
        noruleUnderK = 1 #no of rules in kth order
        for i in range(1,ls.size()):
            Sequence = ls.get(i).items
            for each in Sequence:
                for i in range(len(each.elements)-1):
                    subsets = each.getSubset(i+1,len(each.elements))
                    for subset in subsets:
                        count=0
                        for tran_item in self.data:
                            flag = False
                            for ele in subset:
                                if ele not in tran_item:
                                    flag=True
                                    break
                            if flag == False:
                                count += 1
                        confidence = round((each.supp*self.size)/count , 3)
                        if  confidence >= min_confidence:
                            
                            str_rule = "Rule no. " + str(noruleUnderK) + "of"  + " order  " + str(k) + " : " + str(subset ) + str(list( set(each.elements )- set(subset))) +"Confidence : " + str(confidence)
                        ## for easier lookup
                            str_rule2= str("Order"+ str(k) + str(subset) +str(0) ) + str(str(list( set(each.elements )- set(subset)))+ str(confidence)) 
                            rule =Rule(confidence,str_rule)
                            rule2= Rule(confidence,str_rule2)
                            ruls.append(rule)
                            ruls2.append(rule2)
                            noruleUnderK += 1
            k += 1

        return ruls,ruls2

    def do(self):
        ls = LS()
        oneitemset = self.findFrequent1Itemsets()
        ls.put(oneitemset, 1)
        k = 2
        while False == ls.isEmpty():
            cand = ls.get(k - 1).aprioriGen()
            if cand.isEmpty():
                break
            for each in cand.elements:
                count = 0
                for each_src in self.data:
                    if len(each_src)<len(each.elements):
                        pass
                    else:

                        flag = True
                        for just_one_e in each.elements:
                                flag = just_one_e in each_src
                                if flag == False:
                                    break
                        if flag == True:
                            count += 1

                supp = count*1.0/self.size
                each.setSupport(supp)
            ls.put(cand.getL(a.min_supp), k)
            k += 1
        return ls

class export:

    def __init__ (self, datafile,  direct ):
        reader = open(datafile,"rb")
        concat_NoandName=""
        self.from_list = []
        self.to_list=[]
        self.order_list=[]
        self.confidence_list=[]
        
        for row in reader.readlines():
            regrex= "([\w+]+)"
            linearray = re.compile(regrex).findall(row)
            self.order_list.append(linearray[0])
            if linearray[-1] == 0:
                self.confidence_list.append( 1 )
            else:
                self.confidence_list.append( "0." + str(linearray[-1]) )
            for position,item in enumerate(linearray):
                    if item == '0' :
                        self.from_list.append(linearray[1:position])
                        self.to_list.append(linearray[position +1  : len(linearray)-2])
                        break
        os.chdir(direct)
        table=open("mapping01.csv", "rb")
        os.chdir(a.directory)
        table_name = csv.reader(table)
        outtable = list(table_name)
        self.lookup= {}
        for each in outtable:
            concat_NoandName = str(each[0]) + ":" + str(each[1])
            self.lookup[each[0]]= concat_NoandName
        return None

    def look_up ( self,output):
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
            Result.append( "\n"+ "Rule : " +str(self.order_list[i]) +  str(self.from_list[i]) + "\n"+ "---> " + str(self.to_list[i])  +"\n"+"Confidence :" + str(self.confidence_list[i])+"\n" )

        text=open(output, 'w')
        for i in range(len(Result)):
            text.write(str(Result[i])+ "\n" )


starttime = time.time()
#modify the filename/ location according to month
a = Apriori(0.01,'product.csv','Z:\dataset201403')
ls = a.do()
endtime =  time.time()
rules1,rules2 = a.ralationRules(0.3)
with open("Output.txt", "w") as outputFile:
    for rule in rules1:
        print >>outputFile, rule
with open("OutputM.txt", "w") as outputFile2:
    for rule2 in rules2:
        print >>outputFile2, rule2
ex = export("OutputM.txt",'Z:\Program_Product_basket_analysis' )
ex.look_up( output="outputR.txt")


