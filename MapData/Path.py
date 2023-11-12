class Path:
    def __init__(self, nodes, distance):
        self.nodes = nodes
        self.distance = distance

    def get_start_node(self):
        return self.nodes[0]

    def get_end_node(self):
        return self.nodes[-1]

    def get_nodes(self):
        return self.nodes
    def get_distance(self):
        return self.distance