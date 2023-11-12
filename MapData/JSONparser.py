import json
import shapely
from shapely.geometry import LineString, Point
from Node import Node
"""
This file takes is openstreetmap data, originally in .osm formal but converted to json using xml to json converter: https://www.convertjson.com/xml-to-json.htm

"""
file = open("convertjson.json")#Opening the json file containing openstreetmap data in an easily parsable json format #TODO maybe take in file name as input instead of hardcode
data = json.load(file) #dictionary contianing the json data

index = 0
"""
In open streetmap, a node has an id a latitude and a logitude
A footway is a sequence of node id's, so to get the sequence of latitudes and longitudes for a footway, we have to convert the node ids to their corresponding lat and long.
"""
footways = []#stores the list of nodes associated with a footway (a footway is a type of way in OSM)
dict = {}#stores the node_id: (node latitude, node longitude)
nodeSet = set()#stores only the nodes that are used in a path

# The following for loop makes a dictionary between
# node_id: (lat, lon)
# the key of the dictionary is node_id
# the value is a list of (lat, lon)
for node in data["osm"]["node"]:
    id = node['_id']
    lat = node['_lat']
    lon = node['_lon']
    dict[id] = (lat, lon)

# The following for loop extracts all of the paths with type "footway"
# It stores the sequence of nodes ids associated with that footway
for i in data["osm"]["way"]: #getting all of the ways
    if "tag" in i.keys():   #if the way has a tag value
        if i["tag"][0]["_v"] == "footway":  #if _v = "footway"
            path = []
            for node in i["nd"]:
                path.append(node["_ref"]) #append all of the node ids in that footway
            footways.append(path)


footwaysUpdated = []
# The following for loop goes through each path in the footways list, which is currenty a sequence of node ids
# and converts the node ids to their corresponding co ordinates and stores these co ordinates in footwaysUpdated list
for path in footways:
    temp = []
    for node in path:
        #print(1, node)
        #print(2, dict[node])
        node = dict[node] #swapping the node id with the nodes (lat, lon)
        nodeSet.add(node)
        temp.append(node)#print(3, node)
    footwaysUpdated.append(temp)

#for path in footwaysUpdated:
#    print(path)
file.close()

#"LINESTRING (-101.8744434 33.5855774, -101.8744392 33.5853069)",Line 26,


"""
In the following lines of code we store the parsed data into csv files
"""

#This loop stores the footways in the JSONTOCSVLines.csv file
file = open("JSONToCSVLines.csv", "w")
file.write("WKT,name,description\n")
count = 1
for path in footwaysUpdated:
    string = "\"LINESTRING ("
    for node in path:
        string += node[1] + " " + node[0] + ", "
    string = string[:-2]
    #print(string)
    string += ")\", Line " + str(count) + ",\n"
    count = count + 1
    #print(string)
    file.write(string)
file.close()
count = 1
#"POINT (-101.8732499 33.5855035)", Name ,


#The following loop stores the node data in several files, because google maps only allows 2000 markers in a layer
file = open("JSONToCSVPoints1.csv", "w")
file.write("WKT,name,description\n")

fileNumber = 2
for node in nodeSet:
    if count % 2000 == 0:#This conditional block changes the file that we are writing to after we write 2000 lines to the current file.
        file.close()
        fileName = "JSONToCSVPoints" + str(fileNumber) + ".csv"
        fileNumber = fileNumber + 1
        file = open(fileName, "w")
        file.write("WKT,name,description\n")
    string = "\"POINT ("
    string += node[1] + " " + node[0] + ")\", "
    string += "Name " + str(count) + " ,\n"
    count = count + 1;
    #print(string)
    file.write(string)
file.close()



# The rest of the code is for extracting the nodes that are associated with the start and end of a footway, ignoring any nodes in the middle
file = open("JSONToCSVPointsOnlyStartAndEndOfLines.csv", "w")
file.write("WKT,name,description\n")
startAndEndNodes = []#List that stores only the start and end nodes of a path
count = 1
for path in footwaysUpdated:
    startNode = path[0]#first node in path
    endNode = path[-1]#last node in path
    #print(startNode, endNode)
    startAndEndNodes.append((startNode[1], startNode[0]))#appending the co-ordinates of the start node
    startAndEndNodes.append((endNode[1], endNode[0]))# same with end node


for node in startAndEndNodes:#converting the node to csv format and writing to the file.
    #print(node)
    string = "\"POINT ("
    string += node[0] + " " + node[1] + ")\", "
    string += "Start or End node Name " + str(count) + " ,\n"
    count = count + 1;
    #print(string)
    file.write(string)


file.close()

#Next block of code is for finding intersectin of lines
def line(node1, node2):#TODO switch lat and long
    A = (node1.get_lat() - node2.get_lat())
    B = (node2.get_long() - node1.get_long())
    C = (node1.get_long()*node2.get_lat() - node2.get_long()*node1.get_lat())
    return A, B, -C

def intersection(L1, L2):
    D = L1[0] * L2[1] - L1[1] * L2[0]
    Dx = L1[2] * L2[1] - L1[1] * L2[2]
    Dy = L1[0] * L2[2] - L1[2] * L2[0]
    if D != 0:
        x = Dx / D
        y = Dy / D
        return x, y
    else:
        return False


#[('33.5841090', '-101.8761881'), ('33.5842032', '-101.8761901'), ('33.5842450', '-101.8761910')]

intersect_nodes = []
for path_i in range(len(footwaysUpdated) - 1):
    for nodeIndex in range(len(footwaysUpdated[path_i]) - 1):
        for path_j in range(path_i, len(footwaysUpdated)):#TODO range
            for node2Index in range(len(footwaysUpdated[path_j]) - 1):

                nodes1 = footwaysUpdated[path_i][nodeIndex]
                nodes1next = footwaysUpdated[path_i][nodeIndex + 1]
                nodes2 = footwaysUpdated[path_j][node2Index]
                nodes2next = footwaysUpdated[path_j][node2Index + 1]
                stringToNode1 = Node(float(nodes1[1]), float(nodes1[0]), "")
                stringToNode2 = Node(float(nodes2[1]), float(nodes2[0]), "")
                stringToNode1Next = Node(float(nodes1next[1]), float(nodes1next[0]), "")
                stringToNode2Next = Node(float(nodes2next[1]), float(nodes2next[0]), "")
                #print("Node 1: ", stringToNode1.toString(), " Node 2: ", stringToNode2.toString())
                #print(path_i, path_j)
                point1 = (stringToNode1.get_long(), stringToNode1.get_lat())
                point2 = (stringToNode1Next.get_long(), stringToNode1Next.get_lat())
                point3 = (stringToNode2.get_long(), stringToNode2.get_lat())
                point4 = (stringToNode2Next.get_long(), stringToNode2Next.get_lat())
                line1 = LineString([point1, point2])
                line2 = LineString([point3, point4])

                int_pt = line1.intersection(line2)

                #print(type(int_pt))
                if int_pt.is_empty == False:
                    point_of_intersection = int_pt.xy
                    print(point_of_intersection)
                #line1 = line(stringToNode1, stringToNode2)
                #line2 = line(stringToNode1Next, stringToNode2Next)

                #result = intersection(line1, line2)
                #print(result)
                #if result != False:
                #    #print(result)
                #    intersect_nodes.append(result)

print(intersect_nodes)
