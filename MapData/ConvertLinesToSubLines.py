"""
This file converts every line in the csv into it sub lines:
For example:
If a line contains 5 points, it will be converted into 4 lines containing 2 points each:
(1, 2, 3, 4, 5) -> (1, 2) (2, 3) (3, 4) (4,5)
"""
file = open("lines.csv", "r")#Reading the file
file.readline()#Clearing the first line which is just column headers
lines = []#This list stores the strings that represent the lines, it is later used to write to files
count = 0#used to name lines
for line in file:#go through the file line by line
    if "LINESTRING" in line:#"LINESTRING (-101.8748349 33.5855773, -101.874691 33.5854496)",Line 13,
        between_parenthesis = line[line.index('(') + 1: line.index(')')]#Extract the string that is inbetween the parenthesis
        split_by_comma = between_parenthesis.split(", ")#Split the sting into a list of coords using ", " as a delimiter
        for i in range(len(split_by_comma) - 1):#Go through every coordinate.
            current_node = split_by_comma[i]#Current coords
            next_node = split_by_comma[i + 1]#next coords
            string = "\"LINESTRING ("#THe next lines are for converting to a LINESTRING so that google maps can understsand it
            string += current_node
            string += ", "
            string += next_node
            string += ")\", Line " + str(count) + ",\n"
            #print(string)
            lines.append(string)#Append the LINESTRING to lines list so that it can later be written to a file
            count = count + 1

        #print(split_by_comma)
    else:
        print("Not a line", line)
file.close()


"""
THe rest of the code is for writing to multiple files(depending on how many lines there are since there is a limit of 2000 lines per file)

Data is written to linesConverted.csb
"""
fileNumber = 1
count = 0
#file = open("linesCoverted.csv", "w")
#file.write("WKT,name,description\n")
for line in lines:
    if count % 2000 == 0:#This conditional block changes the file that we are writing to after we write 2000 lines to the current file.
        file.close()
        fileName = "linesConverted" + str(fileNumber) + ".csv"
        fileNumber = fileNumber + 1
        file = open(fileName, "w")
        file.write("WKT,name,description\n")
    file.write(line)
    count = count + 1
file.close()