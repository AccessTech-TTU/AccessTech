import json

import geopy as geopy

from Node import Node
from NodeJson import NodeJson
from Path import Path
from geopy.distance import geodesic #pip install geopy


def distance_between_nodes(node1, node2):  #Takes in two node objects and returns the distance between them in miles
    #return (node1.get_lat() - node2.get_lat()) ** 2 + (node1.get_long() - node2.get_long()) ** 2 #removing ineffient sqrt operation
    return geopy.distance.geodesic((node1.get_lat(), node1.get_long()),(node2.get_lat(), node2.get_long())).miles * 1760 #Getting the distance in miles and then converting to yards. TODO mulitpyly by 3 to get feet

''' The commented out code is for when a line's start or end node doesn't land on a marker, and autosnaps the line's start or end node to the marker. It is not needed.
def find_closest_node(all_nodes, edges_node): #This function is not needed anymore just ignore it
    closest_node = Node(0,0,'')
    min_distance = 100000000 #very large number
    for node in all_nodes:
        distance = distance_between_nodes(node, edges_node)
        print("Distance: ", distance)
        if distance < min_distance:
            closest_node = node
            min_distance = distance
    if min_distance > 10:#TODO change number
        print("It is likely that a path is not properly drawn to a node")
    return closest_node
    '''

file = open("updatedMapKMLtoJson.json")#Loading the converted kml to json data
data = json.load(file)

nodes = []#This list will hold data for the co-ordinates and names of markers. It will hold them as Node objects
edges = []#This list will hold data for the paths. A path is a sequence of nodes and the distance from the start node(at index 0) and the end node(at index -1)

for layer in data['kml']['Document']['Folder']:#Parsing the json file
    for placemark in layer['Placemark']:#Both "Point" data and "LineString" data are in the "Placemark" key
        #TODO if getting error if 'Point' in placemark.keys():#If it is a Point
        #then delete polygon from json file
        if 'Point' in placemark.keys():#If it is a Point
            coords = placemark['Point']['coordinates'].split(',')#Getting the co ordinates of the point
            nodes.append(Node(float(coords[1]), float(coords[0]), placemark['name']))#Storing the "Point" data as a new node in the nodes list. Takes in the Point's (latitude, longitude, name)
        if 'LineString' in placemark.keys():#If it is a LineString
            edge = placemark["LineString"]["coordinates"].split(',0\n            ')  #Getting a list of co-ordinates. Each co-cordinate is seperated by the parameter string
            edge[-1] = edge[-1][:-2]#Removing ',0' on last coordinate pair
            path = []#temperary list for converting from a sequence of co-ordinates to a sequence of nodes
            for node in edge:#Iterating for each co-ordinate pair in the edge
                coords = node.split(',')#Splitting the latitude from the longitude
                node = Node(float(coords[1]), float(coords[0]), "")#New nodee with (latitude, longitude, name)
                path.append(node)
            edges.append(path)#Final version of the data, where the path list contains a sequence of nodes representing a path


#TODO if marker name contains "entrance"
#TODO if markter name contains "ramp"
entrance_nodes = []#list for storing entrance nodes
start_or_end_nodes = []#list for storing start or end nodes, ignores the middle nodes of paths that dont connect to a marker
ramp_nodes = []#list for storing ramp nodes
ramp_count = 1 #for naming the ramps after the ramp number
for node in nodes:
    if "entrance" in node.get_name().lower(): # if the name of the node contains "entrance"
        node_json = NodeJson(node.get_name(), "", node.get_lat(), node.get_long(), "", "entrance")#id, image, lat, lng, description, type
        entrance_nodes.append(node_json)#TODO maybe remove entrance nodes from the set of all nodes
    if "ramp" in node.get_name().lower():#if the name of the node contains "ramp"
        node_json = NodeJson(node.get_name() + str(ramp_count), "", node.get_lat(), node.get_long(), "", "ramp")#id, image, lat, lng, description, type
        ramp_count = ramp_count + 1
        ramp_nodes.append(node_json)
markers = entrance_nodes + ramp_nodes
# Serializing json
json_string = json.dumps([ob.__dict__ for ob in markers])
print(markers[0].__dict__)
print(json_string)
# Writing to sample.json
with open("sample.json", "w") as outfile:
    outfile.write(json_string)

"""

"""


#for node in nodes:
#    print(node.toString())

''' The following commented out code is for autosnapping, which is not needed anymore
#Autosnapping edge nodes(which are slightly off due to the google maps not autosnapping line endpoints to a marker) to markers TODO nerest neighbour algo
for edge in edges[0:100]:
    edge[0] = find_closest_node(nodes, edge[0])#Find the closest marker to the start node and make that the new start node
    edge[-1] = find_closest_node(nodes, edge[-1])#Find the closest marker to the end node and make that the end node
    '''

#for edge in edges:
#    print(edge)

#Getting the distance of an edge TODO
paths = []# a path is an object that more accurately represents an edge. It has a distance value. This list will store a path objects.
for edge in edges:
    distance = 0
    #distance = distance_between_nodes(edge[0], edge[-1]) #This could be used if an edge only has two nodes
    for nodeIndex in range (len(edge) - 1):#TODO optional: move distance calculation into a method of the Path class
        distance = distance + distance_between_nodes(edge[nodeIndex], edge[nodeIndex + 1])#Finding the distance between this node and the next node
    paths.append(Path(edge, distance))#Adding a path, which is a sequence of nodes and the total distance between those nodes.

for path in paths:#TODO getting start or end nodes in a different way than is already done above. Remove worst one
    if path.get_start_node() not in start_or_end_nodes:
        start_or_end_nodes.append(path.get_start_node())
    if path.get_end_node() not in start_or_end_nodes:
        start_or_end_nodes.append(path.get_end_node())

#for path in paths:
#    print(path.distance)



print(len(edges), len(nodes))
file.close();

#TODO use paths, nodes, entrance_nodes, to make an adjacency matrix
'''Adjacency matrix doesnt look right at the moment
coordsToIndex = {}#dictionary that maps a set of coordinates to an index in the adjacency matrix
for i in range(len(start_or_end_nodes)):
    coordsToIndex[start_or_end_nodes[i].get_coordinates()] = i#Mapping the cooridinates to the index

adjMatrix = [[0]*len(start_or_end_nodes)]*len(start_or_end_nodes) #creating a square 2d list with size len(start_or_end_nodes all values set to 0 TODO add entrances

for path in paths:
    startNode = path.get_start_node()#the first node in the path
    endNode = path.get_end_node()#the last node in the path
    startIndex = coordsToIndex[startNode.get_coordinates()]#Converting the coordinates of the node to the index in the adjMatrix using the dicitonary
    endIndex = coordsToIndex[endNode.get_coordinates()]
    adjMatrix[startIndex][endIndex] = path.get_distance()#Setting the weight to the distance
    adjMatrix[endIndex][startIndex] = path.get_distance()#and vice versa

#print(adjMatrix)
for x in adjMatrix:
    print(*x, sep='')
'''

#Making a adj list in python. These two for loops can be commended out because they are redundant.
"""
adjList = {} #maps (start coordinate tuple) : (distance (end coordinate tuple)), (distance (end coordinate tuple)), ...
for path in paths:
    startNode = path.get_start_node().get_coordinates()  # the first node in the path
    endNode = path.get_end_node().get_coordinates()  # the last node in the path
    if startNode not in adjList.keys():
        adjList[startNode] = []#initializes an empty list to add nodes to.
    if endNode not in adjList.keys():
        adjList[endNode] = []#initializes an empty list to add nodes to.
for path in paths:
    #print("test")
    startNode = path.get_start_node().get_coordinates()  # the first node in the path
    endNode = path.get_end_node().get_coordinates()  # the last node in the path
    adjList[startNode].append((path.distance, endNode))#maps (start coordinate tuple) : (distance (end coordinate tuple))
    adjList[endNode].append((path.distance, startNode))#maps (start coordinate tuple) : (distance (end coordinate tuple))
"""




#The rest of the file is for outputting dart code into adjacencyList.dart
file = open("adjacencyList.dart", "w")
code = """class Edge {
  final String vertex1;
  final String vertex2;
  final double weight;

  Edge(this.vertex1, this.vertex2, this.weight);
}

class UndirectedWeightedGraph {
  final Map<String, List<Edge>> _adjacencyList = {};

  void addVertex(String vertex) {
    if (!_adjacencyList.containsKey(vertex)) {
      _adjacencyList[vertex] = [];
    }
  }

  void addEdge(String vertex1, String vertex2, double weight) {
    addVertex(vertex1);
    addVertex(vertex2);

    final edge = Edge(vertex1, vertex2, weight);
    _adjacencyList[vertex1]?.add(edge);
    _adjacencyList[vertex2]?.add(edge); // Undirected graph, so we add the edge for both vertices
  }

  void printGraph() {
    _adjacencyList.forEach((vertex, edges) {
      print('$vertex -> ${edges.map((e) => '${e.vertex1}-${e.vertex2}:${e.weight}').join(', ')}');
    });
  }
}

void main() {
  final graph = UndirectedWeightedGraph();
"""
file.write(code)
for path in paths:
    startNode = path.get_start_node().get_coordinates()  # the first node in the path
    endNode = path.get_end_node().get_coordinates()  # the last node in the path
    distance = path.distance
    #s= "graph.addEdge(" + startNode + ", " + endNode + ", " + distance + ")"
    a =f"  graph.addEdge(\"{startNode}\", \"{endNode}\", {distance});\n"
    #print(a)
    file.write(a)
    #print(f"graph.addEdge({startNode}, {endNode}, {distance})")

code2 = """
        graph.printGraph();
        }

"""
file.write(code2)
file.close()

#for key, value in adjList.items():
#    print(key, ":", value)


