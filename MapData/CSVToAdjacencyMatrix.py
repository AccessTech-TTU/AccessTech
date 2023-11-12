import geopy.distance
"""
This function takes to co-ordiates and returns the distance between them.
"""
def distance_between_coordinates(latitude_1, latitude_2, longitude_1, longitude_2):  # (latitude_1, longitude_1) (latitude_2, longitude_2)
    return geopy.distance.geodesic((latitude_1, longitude_1),(latitude_2, longitude_2)).miles


"This function finds the closest node to the endpoint of a path"
def find_closest_node(all_nodes, edges_node):
    closest_node = null
    min_distance = 100000000 #very large number
    for node in all_nodes:
        coordinates = node.get_coordinates
        distance = distance_between_coordinates(node, edges_node)
        if distance < min_distance:
            closest_node = node
            min_distance = distance
    if min_distance > 10:#TODO change number
        print("It is likely that a path is not properly drawn to a node")
    return closest_node





file.readLine() #Clearing the fisrt line that describes the columns #WKT, name, description
for line in file:
    if "POINT" in line: #"POINT (-101.8750809 33.5851397)",Ramp,
        between_parenthesis = line[lines.index('(') + 1, line.index(')')] #(-101.8750809 33.5851397)
        coordinates = between_parenthesis.split(' ')
        name = line[line.index(',') + 1, line.rindex(',')]
        node = Node(coordinates[0], coordinates[1], name)
        nodes.append(node)
    elif "LINESTRING" in line:#"LINESTRING (-101.8748349 33.5855773, -101.874691 33.5854496)",Line 13,
        between_parenthesis = line[lines.index('(') + 1, line.index(')')]
        split_by_comma = between_parenthesis.split(", ")
        edges.append(split_by_comma)
    else:
        print("Invalid entry")
"""
Matching nodes and edges
"""

for edge in edges:#Note an edge may have more than two nodes. The middle node(s) are just for drawing curved lines.
    edge[0] = find_closest_node(nodes, edge[0])
    edge[-1] = find_closest_node(nodes, edge[-1])
