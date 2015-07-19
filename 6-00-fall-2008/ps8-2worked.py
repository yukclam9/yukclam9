
import time
import operator
import copy

SUBJECT_FILENAME = "subjects.txt"
VALUE, WORK = 0, 1


def loadSubjects(filename):
  
    mapping={}
    inputFile = open(filename)
    for line in inputFile:
        #split return a list
        line=(line.strip()).split(',')
        ##type(line[2]) = str and tuple(line[2]) yields ("1","17")
        ## _ instead of ( "17")
        ## a more efficent way to do it with
        mapping[line[0]]=(line[1],)+(line[2],)
    return mapping


def printSubjects():
    """
    Prints a string containing name, value, and work of each subject in
    the dictionary of subjects and total value and work of all subjects
    """
    mapping=loadSubjects(SUBJECT_FILENAME)
    totalVal, totalWork = 0,0
    if len(mapping) == 0:
        return 'Empty SubjectList'
    #\t means tab
    res = 'Course\tValue\tWork\n======\t====\t=====\n'
    #dict.keys is a list of keys of a dict
    subNames = mapping.keys()
    ## values should be sorted with floats but not the first value of a float
    ## 10.09 should after 9.2 while if key=float is neglected, 10.09 comes before 9.2
    subNames.sort(key=float)
    print subNames
    for s in subNames:
        val = mapping[s][0]
        work = mapping[s][1]
        res = res + s + '\t' + str(val) + '\t' + str(work) + '\n'
        totalVal += int(val)
        totalWork += int(work)
    res = res + '\nTotal Value:\t' + str(totalVal) +'\n'
    res = res + 'Total Work:\t' + str(totalWork) + '\n'
    print res

def cmpValue(subInfo1, subInfo2):
    """
    Returns True if value in (value, work) tuple subInfo1 is GREATER than
    value in (value, work) tuple in subInfo2
    """
    val1 = int(subInfo1[0])
    val2 = int(subInfo2[0])
    return  val1 > val2

def cmpWork(subInfo1, subInfo2):
    """
    Returns True if work in (value, work) tuple subInfo1 is LESS than than work
    in (value, work) tuple in subInfo2
    """
    work1 = int(subInfo1[1])
    work2 = int(subInfo2[1])
    return  work1 < work2

def cmpRatio(subInfo1, subInfo2):
    """
    Returns True if value/work in (value, work) tuple subInfo1 is 
    GREATER than value/work in (value, work) tuple in subInfo2
    """
    val1 = int(subInfo1[0])
    val2 = int(subInfo2[0])
    work1 = int(subInfo1[1])
    work2 = int(subInfo2[1])
    return float(val1) / work1 > float(val2) / work2

def test(list):
    here= []
    for i,x in enumerate(list):
        if x == ('10', '3'):
            here.append(i)
    return here

def test2(list):
    here= []
    for i,x in enumerate(list):
        if x == '10.18':
            here.append(i)
    return here

def greedyAdvisor(dictionary, maxWork, comparator):
    mapping = loadSubjects(SUBJECT_FILENAME)
    subNames = mapping.keys()
    courseVal = mapping.values()
    courseValForCompare = copy.copy(courseVal)
    ans={}
    ans2={}
    Remained_weight= maxWork
    loop = 0
    i,j=0,1
    locate = []
    record = int()
    while 1:
        if j == len(courseValForCompare)   or len(courseValForCompare) == 2:
            loop += 1
            print "ANOTHER LOOP , LOOP NUMBER:", loop
            if result:
                if int(courseValForCompare[j-1][1]) <= Remained_weight:
                    ans[subNames[-1]]= courseValForCompare[-1]
                    subNames.remove(subNames[-1])
                    Remained_weight -= int(courseValForCompare[-1][1])
                    locate.append(courseValForCompare[-1])
            else:
                if int(courseValForCompare[0][1]) <= Remained_weight:
                    ans[subNames[i]]= courseValForCompare[0]
                    Remained_weight -= int(courseValForCompare[0][1])
                    locate.append(courseValForCompare[0])
                else:
                    locate.append(courseValForCompare[0])
                    
                subNames.remove(subNames[i])
                                                 
            courseValForCompare = copy.copy(courseVal)
            print courseValForCompare[record]
            j = 1
            i = 0
            for number in range(loop):
                courseValForCompare.remove(locate[number])

            print courseValForCompare[record]
            courseValForCompare = courseValForCompare[record:]
            subNames = subNames[record:]
            
            if  loop == len(courseVal)-1 or Remained_weight ==  0:
                break
        result= comparator( courseValForCompare[j] ,courseValForCompare[0] )
##        if loop == 2:
##            print "now check items ", courseValForCompare[j], courseValForCompare[0],subNames[i]
        if result :
##            record = i - loop
            courseValForCompare = courseValForCompare[j:]
            i += j
            j = 1
        else:
            j += 1
##        if loop ==2:
##            print " and the result is:", result
    return ans
       
              
        
    
    

def bruteForceAdvisor(subjects, maxWork):
    """
    Returns a dictionary mapping subject name to (value, work), which
    represents the globally optimal selection of subjects using a brute force
    algorithm.

    subjects: dictionary mapping subject name to (value, work)
    maxWork: int >= 0
    returns: dictionary mapping subject name to (value, work)
    """
    nameList = subjects.keys()
    tupleList = subjects.values()
    bestSubset, bestSubsetValue = \
            bruteForceAdvisorHelper(tupleList, maxWork, 0, None, None, [], 0, 0)
    outputSubjects = {}
    for i in bestSubset:
        outputSubjects[nameList[i]] = tupleList[i]
    return outputSubjects

def bruteForceAdvisorHelper(subjects, maxWork, i, bestSubset, bestSubsetValue,
                            subset, subsetValue, subsetWork):
    # Hit the end of the list.
    if i >= len(subjects):
        if bestSubset == None or subsetValue > bestSubsetValue:
            # Found a new best.
            return subset[:], subsetValue
        else:
            # Keep the current best.
            return bestSubset, bestSubsetValue
    else:
        s = subjects[i]
        # Try including subjects[i] in the current working subset.
        if subsetWork + s[WORK] <= maxWork:
            subset.append(i)
            bestSubset, bestSubsetValue = bruteForceAdvisorHelper(subjects,
                    maxWork, i+1, bestSubset, bestSubsetValue, subset,
                    subsetValue + s[VALUE], subsetWork + s[WORK])
            subset.pop()
        bestSubset, bestSubsetValue = bruteForceAdvisorHelper(subjects,
                maxWork, i+1, bestSubset, bestSubsetValue, subset,
                subsetValue, subsetWork)
        return bestSubset, bestSubsetValue

#
# Problem 3: Subject Selection By Brute Force
#
def bruteForceTime():
    """
    Runs tests on bruteForceAdvisor and measures the time required to compute
    an answer.
    """
    # TODO...

# Problem 3 Observations
# ======================
#
# TODO: write here your observations regarding bruteForceTime's performance

#
# Problem 4: Subject Selection By Dynamic Programming
#
def dpAdvisor(subjects, maxWork):
    """
    Returns a dictionary mapping subject name to (value, work) that contains a
    set of subjects that provides the maximum value without exceeding maxWork.

    subjects: dictionary mapping subject name to (value, work)
    maxWork: int >= 0
    returns: dictionary mapping subject name to (value, work)
    """
    # TODO...

#
# Problem 5: Performance Comparison
#
def dpTime():
    """
    Runs tests on dpAdvisor and measures the time required to compute an
    answer.
    """
    # TODO...

# Problem 5 Observations
# ======================
